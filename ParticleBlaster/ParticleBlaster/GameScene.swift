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
//    private let player = SKSpriteNode(imageNamed: "Spaceship")
    private var monstersDestroyed = 0
    private let monstersDestroyRequirement = 10
    
//    private let plate = SKSpriteNode(imageNamed: "plate")
//    private let joystick = SKSpriteNode(imageNamed: "top")
    private var plateAllowedRange: SKShapeNode!
    private var plateTouchEndRange: SKShapeNode!
    private var plateAllowedRangeDistance: CGFloat!
    
//    private var xDestination: CGFloat = CGFloat(0)
//    private var yDestination: CGFloat = CGFloat(0)
//    private var unitOffset: CGVector = CGVector(dx: 0, dy: 1)
//    private let basicVelocity: CGFloat = CGFloat(400)
//    private var flyingVelocity: CGFloat = CGFloat(0)
    //private var prevTime: DispatchTime!
    private var prevTime: TimeInterval?
//    private var flying: Bool = false
    
    // new architecture starts here
    var viewController: UIViewController!
    var newPlayer: Player!
    var joystickPlate: JoystickPlate!
    var joystick: Joystick!
    var fireButton: FireButton!
    var updatePlayerPositionHandler: ((TimeInterval) -> ())?
    var rotateJoystickAndPlayerHandler: ((CGPoint) -> ())?
    var endJoystickMoveHandler: (() -> ())?
    
    var obstacleHitHandler: (() -> ())?
    var obstacleMoveHandler: (() -> ())?
    var obstacleVelocityUpdateHandler: (() -> ())?
    var fireHandler: (() -> ())?
    
    override func didMove(to view: SKView) {
        backgroundColor = Constants.backgroundColor
        newPlayer.shape.size = CGSize(width: Constants.playerWidth, height: Constants.playerHeight)
        newPlayer.shape.position = CGPoint(x: Constants.playerCenterX, y: Constants.playerCenterY)
        addChild(newPlayer.shape)
        
        joystickPlate.shape.position = CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY)
        joystickPlate.shape.size = CGSize(width: Constants.joystickPlateWidth, height: Constants.joystickPlateHeight)
        addChild(joystickPlate.shape)
        
        joystick.shape.size = CGSize(width: Constants.joystickPlateWidth / 2, height: Constants.joystickPlateHeight / 2)
        // Note: position is given as center position already
        joystick.shape.position = CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY)
        joystick.shape.alpha = 0.8
        addChild(joystick.shape)
        joystick.shape.zPosition = 2
        
        fireButton.shape.size = CGSize(width: Constants.fireButtonWidth, height: Constants.fireButtonHeight)
        fireButton.shape.position = CGPoint(x: Constants.fireButtonCenterX, y: Constants.fireButtonCenterY)
        fireButton.shape.alpha = 0.8
        
        // plateAllowedRange is to give a buffer area for joystick operation and should not be added as child
        plateAllowedRange = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 50)
        plateAllowedRange.position = CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY)
        plateTouchEndRange = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 100)
        plateTouchEndRange.position = CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY)
        
        // Set up the physics world to have no gravity
        physicsWorld.gravity = CGVector.zero
        // Set the scene as the delegate to be notified when two physics bodies collide.
        //physicsWorld.contactDelegate = self
        if let controller = self.viewController {
            //physicsWorld.contactDelegate = controller as! SKPhysicsContactDelegate?
            physicsWorld.contactDelegate = controller as? SKPhysicsContactDelegate
        }
        
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
    
    func removeElement(node: SKSpriteNode) {
        node.removeFromParent()
    }
    
    func addSingleObstacle(newObstacle: Obstacle) {
        // obstacle's size has been set previously
        // TODO: think about whether to put the position and size setting for spritenodes
        newObstacle.shape.position = newObstacle.initialPosition
        addChild(newObstacle.shape)
    }
    
    func addMissile(missile: Bullet, directionAngle: CGFloat, position: CGPoint) {
        missile.shape.position = position
        missile.shape.zRotation = directionAngle
        missile.shape.zPosition = -1
        
        addChild(missile.shape)
        
        
        //        let currentFiringAngle = spaceship.zRotation
        //        let projectile = SKSpriteNode(imageNamed: "missile")
        //        //projectile.size = CGSize(width: )
        //        projectile.xScale = 0.3
        //        projectile.yScale = 0.3
        //        projectile.position = CGPoint(x: spaceship.position.x, y: spaceship.position.y)
        //        projectile.zRotation = currentFiringAngle
        //        projectile.zPosition = -1
        //
        //        addChild(projectile)
        //        let travel = CGVector(dx: self.unitOffset.dx * 1200, dy: self.unitOffset.dy * 1200)
        //        let destination = CGPoint(x: spaceship.position.x + travel.dx, y: spaceship.position.y + travel.dy)
        //
        //        projectile.run(SKAction.move(to: destination, duration: 3), completion: {
        //            projectile.removeFromParent()
        //        })
    }
    
    private func checkTouchRange(touch: UITouch, frame: CGRect) -> Bool {
        let location = touch.location(in: self)
        if frame.contains(location) {
            return true
        } else {
            return false
        }
    }
    
    private func checkJoystickOp(touch: UITouch) {
        if self.checkTouchRange(touch: touch, frame: plateTouchEndRange.frame) {
            if self.checkTouchRange(touch: touch, frame: plateAllowedRange.frame) {
                if let rotateHandler = self.rotateJoystickAndPlayerHandler {
                    let location = touch.location(in: self)
                    rotateHandler(location)
                }
            } else {
                if let endHandler = self.endJoystickMoveHandler {
                    endHandler()
                }
            }
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            if self.checkTouchRange(touch: touch, frame: plateAllowedRange.frame) {
                if let endHandler = self.endJoystickMoveHandler {
                    endHandler()
                }
            } else if self.checkTouchRange(touch: touch, frame: fireButton.shape.frame) {
                // Play the sound of shooting
                run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
                self.fireButton.shape.alpha = 0.8
                if let shootHandler = self.fireHandler {
                    shootHandler()
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if self.prevTime == nil {
            self.prevTime = currentTime
        } else {
            // new logic goes here
            let elapsedTime = currentTime - self.prevTime!
            if let handler = self.updatePlayerPositionHandler {
                handler(elapsedTime)
            }
            
            // old logic flow
//            if self.flyingVelocity != CGFloat(0) {
//                let elapsedTime = currentTime - self.prevTime!
//                let currPos = self.player.position
//                let offset = CGVector(dx: self.flyingVelocity * self.unitOffset.dx * CGFloat(elapsedTime), dy: self.flyingVelocity * self.unitOffset.dy * CGFloat(elapsedTime))
//                let finalPos = CGPoint(x: currPos.x + offset.dx, y: currPos.y + offset.dy)
//                self.player.run(SKAction.move(to: finalPos, duration: elapsedTime))
//                
//            }
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
