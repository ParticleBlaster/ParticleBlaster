//
//  GameScene.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 12/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
//    private let player = IsoscelesTriangle(base: 20, height: 25, color: UIColor.black)
    private let player = SKSpriteNode(imageNamed: "Spaceship")
    private var monstersDestroyed = 0
    private let monstersDestroyRequirement = 10
    
    private let plate = SKSpriteNode(imageNamed: "plate")
    private let joystick = SKSpriteNode(imageNamed: "top")
    private var plateAllowedRange: SKShapeNode!
    private var plateTouchEndRange: SKShapeNode!
    private var plateAllowedRangeDistance: CGFloat!
    
    private var xDestination: CGFloat = CGFloat(0)
    private var yDestination: CGFloat = CGFloat(0)
    private var unitOffset: CGVector = CGVector(dx: 0, dy: 1)
    private let basicVelocity: CGFloat = CGFloat(400)
    private var flyingVelocity: CGFloat = CGFloat(0)
    //private var prevTime: DispatchTime!
    private var prevTime: TimeInterval?
    private var flying: Bool = false
    
    // new architecture starts here
    var newPlayer: Player!
    var updatePlayerPositionHandler: (() -> ())?
    
    
    override func didMove(to view: SKView) {
        backgroundColor = Constants.backgroundColor
        player.size = CGSize(width: 50, height: 44)
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        addChild(player)
        
        plate.position = CGPoint(x: self.size.width * 0.1, y: self.size.height * 0.1)
        plate.size = CGSize(width: self.size.width / 8, height: self.size.width / 8)
        addChild(plate)
        
        // plateAllowedRange is to give a buffer area for joystick operation and should not be added as child
        plateAllowedRange = SKShapeNode(circleOfRadius: plate.size.width / 2 + 50)
        plateAllowedRange.position = CGPoint(x: plate.position.x, y: plate.position.y)
        plateTouchEndRange = SKShapeNode(circleOfRadius: plate.size.width / 2 + 100)
        plateTouchEndRange.position = CGPoint(x: plate.position.x, y: plate.position.y)
        
        joystick.size = CGSize(width: plate.size.width / 2, height: plate.size.height / 2)
        // Note: position is given as center position already
        joystick.position = CGPoint(x: plate.position.x, y: plate.position.y)
        joystick.alpha = 0.8
        addChild(joystick)
        joystick.zPosition = 2
        
        // Set up the physics world to have no gravity
        physicsWorld.gravity = CGVector.zero
        // Set the scene as the delegate to be notified when two physics bodies collide.
        physicsWorld.contactDelegate = self
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run {
                    self.addCircleObstacle(radius: 20)
                },
                SKAction.wait(forDuration: 1.0)
            ])
        ))
        
        // Play and loop the background music
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addCircleObstacle(radius: CGFloat) {
        
        // Create sprite
        let monster = SKShapeNode(circleOfRadius: radius)
        monster.fillColor = UIColor.black
        
        // Create a physics body for the sprite defined as a rectangle of the same size
        monster.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        // Set the sprite to be dynamic (The movement of the monster will be conntrolled uusing move actions)
        monster.physicsBody?.isDynamic = true
        // Set the category bit mask to be the monsterCategory
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        // Indicates that contact with projectiles should the contact listener when they intersect
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        // Currently prevent the monster and projectile to bounce off each other
        monster.physicsBody?.collisionBitMask = PhysicsCategory.Projectile
        
        // Determine where to spawn the monster along the Y axis
        let actualY = random(min: radius / 2.0, max: size.height - radius / 2.0)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        monster.position = CGPoint(x: size.width + radius / 2.0, y: actualY)
        
        // Add the monster to the scene
        addChild(monster)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(8.0), max: CGFloat(16.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: -radius / 2.0, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        let loseAction = SKAction.run() {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        
    }
    
    private func checkJoystickTouch(touch: UITouch) -> Bool {
        let location = touch.location(in: self)
        if plateAllowedRange.frame.contains(location) {
            return true
        } else {
            return false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.checkJoystickOp(touch: t)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.checkJoystickOp(touch: t)
        }
    }
    
    private func checkJoystickOp(touch: UITouch) {
        let location = touch.location(in: self)
        if plateTouchEndRange.frame.contains(location) {
            if self.checkJoystickTouch(touch: touch) {
                self.rotateJoystickAndSpaceship(touch: touch)
            } else {
                self.flyingVelocity = CGFloat(0)
                self.endJoystick()
            }
        }
    }
    
    private func rotateJoystickAndSpaceship(touch: UITouch) {
        self.flying = true
        let location = touch.location(in: self)
        let direction = CGVector(dx: location.x - plate.position.x, dy: location.y - plate.position.y)
        let length = sqrt(direction.dx * direction.dx + direction.dy * direction.dy)
        let directionVector = CGVector(dx: direction.dx / length, dy: direction.dy / length)
        self.unitOffset = directionVector
        let rotationAngle = atan2(directionVector.dy, directionVector.dx) - CGFloat.pi / 2
        var radius = plate.size.width / 2
        self.flyingVelocity = length >= radius ? self.basicVelocity : self.basicVelocity * (length / radius)
        if length < radius {
            radius = length
        }
        
        joystick.position = CGPoint(x: plate.position.x + directionVector.dx * radius, y: plate.position.y + directionVector.dy * radius)
        player.zRotation = rotationAngle
    }
    
    // Reserved for possible future use
//    private func updateTriPosition() {
//        let currTime = DispatchTime.now()
//        let elapsedTime = Double(currTime.uptimeNanoseconds - self.prevTime.uptimeNanoseconds) / 1_000_000_000
//        
//        let currPos = self.player.position
//        let offset = CGVector(dx: self.flyingVelocity * self.unitOffset.dx * CGFloat(elapsedTime), dy: self.flyingVelocity * self.unitOffset.dy * CGFloat(elapsedTime))
//        let finalPos = CGPoint(x: currPos.x + offset.dx, y: currPos.y + offset.dy)
//        self.player.run(SKAction.move(to: finalPos, duration: elapsedTime))
//        self.prevTime = currTime
//    }
    
    private func endJoystick() {
        if self.flying {
            self.flying = false
            self.joystick.run(SKAction.move(to: CGPoint(x: plate.position.x, y: plate.position.y), duration: 0.2))
            //        self.player.run(SKAction.rotate(toAngle: 0, duration: 0.2))
            //        self.unitOffset = CGVector(dx:0, dy: 1)
            
            //let endingDrift = CGVector(dx: self.unitOffset.dx * 10, dy: self.unitOffset.dy * 10)
            //self.player.run(SKAction.move(by: endingDrift, duration: 0.2))
            self.flyingVelocity = CGFloat(0)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            if self.checkJoystickTouch(touch: touch) {
                self.flyingVelocity = CGFloat(0)
                self.endJoystick()
            } else { // interpreted as shooting action
                // Play the sound of shooting
                run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
                
                // Choose one of the touches to work with
                guard let touch = touches.first else {
                    return
                }
                let touchLocation = touch.location(in: self)
                
                // Set up initial location of projectile
                let projectileRadius: CGFloat = 5.0
                let projectile = SKShapeNode(circleOfRadius: projectileRadius)
                projectile.position = player.position
                projectile.fillColor = UIColor.black
                
                // Create a physics body for the sprite defined by a cicrle
                projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectileRadius)
                projectile.physicsBody?.mass = (projectile.physicsBody?.mass)! * 16
                projectile.physicsBody?.isDynamic = true
                projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
                projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
                projectile.physicsBody?.collisionBitMask = PhysicsCategory.Monster
                projectile.physicsBody?.usesPreciseCollisionDetection = true
                
                // Determine offset of location to projectile
                let offset = touchLocation - projectile.position
                
                // Bail out if shooting down or backwards
                if (offset.x < 0) { return }
                
                // Add the projectile after double checked position
                addChild(projectile)
                
                // Get the direction of where to shoot
                let direction = offset.normalized()
                
                // Make it shoot far enough to be guaranteed off screen
                let shootAmount = direction * 1000
                
                // Add the shoot amount to the current position
                let realDest = shootAmount + projectile.position
                
                // Create the actions
                let actionMove = SKAction.move(to: realDest, duration: 2.0)
                let actionMoveDone = SKAction.removeFromParent()
                projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if self.prevTime == nil {
            self.prevTime = currentTime
        } else {
            if self.flyingVelocity != CGFloat(0) {
                let elapsedTime = currentTime - self.prevTime!
                let currPos = self.player.position
                let offset = CGVector(dx: self.flyingVelocity * self.unitOffset.dx * CGFloat(elapsedTime), dy: self.flyingVelocity * self.unitOffset.dy * CGFloat(elapsedTime))
                let finalPos = CGPoint(x: currPos.x + offset.dx, y: currPos.y + offset.dy)
                self.player.run(SKAction.move(to: finalPos, duration: elapsedTime))
                
                // new logic goes here
                if let handler = self.updatePlayerPositionHandler {
                    handler()
                }
            }
            self.prevTime = currentTime
        }
    }
    
    // Projectile collides with the monster
    func projectileDidCollideWithMonster(projectile: SKShapeNode, monster: SKShapeNode) {
        print("Hit")
        // projectile.removeFromParent()
        // monster.removeFromParent()
        
        // Update monstersDestroyed count
        monstersDestroyed += 1
        if (monstersDestroyed >= monstersDestroyRequirement) {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    // Contact delegate method
    func didBegin(_ contact: SKPhysicsContact) {
        
        // Arranges two colliding bodies so they are sorted by their category bit masks
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Checks if the two bodies that collide are the projectile and monster
        // If so calls the method you wrote earlier.
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            if let monster = firstBody.node as? SKShapeNode, let
                projectile = secondBody.node as? SKShapeNode {
                projectileDidCollideWithMonster(projectile: projectile, monster: monster)
            }
        }
    }
}
