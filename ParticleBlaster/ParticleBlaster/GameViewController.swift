//
//  GameViewController.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 12/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, SKPhysicsContactDelegate {
    
    // Initialise game scene for displaying game objects
    var scene: GameScene!

    // Initialise game objects
    var player = Player(image: "Spaceship")
    var joystickPlate = JoystickPlate(image: "plate")
    var joystick = Joystick(image: "top")
    var fireButton = FireButton(image: "fire")
    var obstaclePool = [Obstacle]()
    var map: MapObject!
    
    // Initialised physical property related supporting attributes
    private var xDestination: CGFloat = CGFloat(0)
    private var yDestination: CGFloat = CGFloat(0)
    private var unitOffset: CGVector = CGVector(dx: 0, dy: 1)
    private var flyingVelocity: CGFloat = CGFloat(0)
    private var flying: Bool = false
    
    // Initialised score related supporting attributes
    private var startTime: DispatchTime!
    private var currLevelObtainedScore: Int = 0

    /* Start of UIViewController related methods */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        setupGameScene()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /* End of UIViewController related methods */
    
    /* TODO: Implement game mode indicator for single player mode and multiplayer mode
    func setGameMode(_ mode: Constants.gameMode) {
        self.mode = mode
    }
     */
    
    /* TODO: Implement Level object for loading initial status of players and obstacles
    func loadLevel(_ level: Level) {
    }
     */
    
    /* Start of setup related methods */
    
    private func setupMap() {
        self.map = MapObject(view: self.view)
    }
    
    private func setupGameScene() {
        self.scene = GameScene(size: view.bounds.size)
        Constants.initializeJoystickInfo(viewSize: view.bounds.size)
        
        // Initialise game scene sttributes assignment
        scene.viewController = self
        scene.player = self.player
        scene.joystick = self.joystick
        scene.joystickPlate = self.joystickPlate
        scene.fireButton = self.fireButton
        
        // Logic handlers assignment
        scene.updatePlayerPositionHandler = self.movePlayerHandler
        scene.rotateJoystickAndPlayerHandler = self.moveJoystickAndRotatePlayerHandler
        scene.endJoystickMoveHandler = self.endJoystickMoveHandler
        scene.obstacleVelocityUpdateHandler = self.updateObstacleVelocityHandler
        scene.fireHandler = self.shootHandler
        
        // TODO: Remove prepareObstacles() method after the Level class is implemented
        
        self.initialiseFakeObstacles()
        self.prepareObstacles()
        
        self.preparePlayer()

        self.prepareMap()
        
        // Link game scene to view
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        self.startTime = DispatchTime.now()
    }
    
    private func prepareMap() {
        for boundary in self.map.boundaries {
            scene.addBoundary(boundary: boundary)
        }
    }

    // Logic for preparing the obstacle according to selected level information
    private func initialiseFakeObstacles() {
        // TODO: Remove manual assignment of obstacle information after the Level class is created
        let obs1 = Obstacle(userSetInitialPosition: CGPoint(x: Constants.obstacle1CenterX, y: Constants.obstacle1CenterY))
        let obs2 = Obstacle(userSetInitialPosition: CGPoint(x: Constants.obstacle2CenterX, y: Constants.obstacle2CenterY))
        self.prepareObstaclePhysicsProperty(obs: obs1)
        self.prepareObstaclePhysicsProperty(obs: obs2)
        
        self.obstaclePool.append(obs1)
        self.obstaclePool.append(obs2)
    }
    
    private func prepareObstacles() {
        for obs in self.obstaclePool {
            self.prepareObstaclePhysicsProperty(obs: obs)
            scene.addSingleObstacle(newObstacle: obs)
        }
    }
    
    private func prepareObstaclePhysicsProperty(obs: Obstacle) {
        obs.shape.size = CGSize(width: Constants.obstacleWidth, height: Constants.obstacleHeight)
        obs.shape.physicsBody = SKPhysicsBody(rectangleOf: obs.shape.size)
        obs.shape.physicsBody?.isDynamic = true
        obs.shape.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        obs.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile | PhysicsCategory.Monster | PhysicsCategory.Player | PhysicsCategory.Map
        obs.shape.physicsBody?.collisionBitMask = PhysicsCategory.Projectile | PhysicsCategory.Monster | PhysicsCategory.Map
    }
    
    
    private func preparePlayer() {
        self.player.shape.size = CGSize(width: Constants.playerWidth, height: Constants.playerHeight)
        self.player.shape.physicsBody = SKPhysicsBody(texture: self.player.shape.texture!, size: self.player.shape.size)
        self.player.shape.physicsBody?.isDynamic = true
        self.player.shape.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.player.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Monster | PhysicsCategory.Map
        self.player.shape.physicsBody?.collisionBitMask = PhysicsCategory.Map
    }
    
    /* End of setup related methods */
    
    /* Start of game logic related methods */
    private func isGameObjectOutOfBound(object: GameObject, position: CGPoint) -> Bool {
        let leftLimit = position.x - object.shape.size.width / 2
        if leftLimit >= view.bounds.width {
            return true
        }
        
        let rightLimit = position.x + object.shape.size.width / 2
        if rightLimit <= 0 {
            return true
        }
        
        let topLimit = position.y - object.shape.size.height / 2
        if topLimit <= 0 {
            return true
        }
        
        let bottomLimit = position.y + object.shape.size.height / 2
        if bottomLimit >= view.bounds.height {
            return true
        }
        
        return false
    }
    
    private func movePlayerHandler(elapsedTime: TimeInterval) {
        let currPos = self.player.shape.position
        let offset = CGVector(dx: self.flyingVelocity * self.unitOffset.dx * CGFloat(elapsedTime),
                              dy: self.flyingVelocity * self.unitOffset.dy * CGFloat(elapsedTime))
        let finalPos = CGPoint(x: currPos.x + offset.dx, y: currPos.y + offset.dy)

        self.player.shape.run(SKAction.move(to: finalPos, duration: elapsedTime))
    }
    
    private func moveJoystickAndRotatePlayerHandler(touchLocation: CGPoint) {
        self.flying = true
        let direction = CGVector(dx: touchLocation.x - Constants.joystickPlateCenterX, dy: touchLocation.y - Constants.joystickPlateCenterY)
        let length = sqrt(direction.dx * direction.dx + direction.dy * direction.dy)
        self.unitOffset = direction.normalized()
        let rotationAngle = atan2(self.unitOffset.dy, self.unitOffset.dx) - CGFloat.pi / 2
        var radius = Constants.joystickPlateWidth / 2
        self.flyingVelocity = length >= radius ? Constants.playerVelocity : Constants.playerVelocity * (length / radius)
        if length < radius {
            radius = length
        }
        
        let newJoystickPosition = CGPoint(x: Constants.joystickPlateCenterX + self.unitOffset.dx * radius, y: Constants.joystickPlateCenterY + self.unitOffset.dy * radius)
        self.joystick.updatePosition(newLoation: newJoystickPosition)
        self.player.updateRotation(newAngle: rotationAngle)
    }
    
    private func endJoystickMoveHandler() {
        self.flyingVelocity = CGFloat(0)
        if self.flying {
            self.flying = false
            self.joystick.releaseJoystick()
            self.flyingVelocity = CGFloat(0)
        }
    }
    
    private func moveObstacleHandler(elapsedTime: TimeInterval) {
        
    }
    
    private func updateObstacleVelocityHandler() {
        for obs in self.obstaclePool {
            let direction = CGVector(dx: self.player.shape.position.x - obs.shape.position.x, dy: self.player.shape.position.y - obs.shape.position.y).normalized()
            let newVelocity = CGVector(dx: direction.dx * Constants.obstacleVelocity, dy: direction.dy * Constants.obstacleVelocity)
            // Note: change here from using velocity to using applyForce
            obs.updateVelocity(newVelocity: newVelocity)
        }
    }
    
    // Ideas for the implementation of level: each GameObject should be associated with a default size
    private func shootHandler() {
        let bullet = Bullet()
        bullet.shape.size = CGSize(width: Constants.defaultBulletRadius, height: Constants.defaultBulletRadius)
        bullet.shape.physicsBody = SKPhysicsBody(circleOfRadius: Constants.defaultBulletRadius)
        bullet.shape.physicsBody?.isDynamic = true
        bullet.shape.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        bullet.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        bullet.shape.physicsBody?.collisionBitMask = PhysicsCategory.None //PhysicsCategory.Monster
        bullet.shape.physicsBody?.usesPreciseCollisionDetection = true
        
        let bulletVelocity = CGVector(dx: self.unitOffset.dx * Constants.bulletVelocity, dy: self.unitOffset.dy * Constants.bulletVelocity)
        bullet.updateVelocity(newVelocity: bulletVelocity)
        let currFiringAngle = self.player.shape.zRotation
        let currFiringPosition = self.player.shape.position
        self.scene.addBullet(bullet: bullet, directionAngle: currFiringAngle, position: currFiringPosition)
        
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
            if let obs = firstBody.node as? SKSpriteNode, let
                bullet = secondBody.node as? SKSpriteNode {
                self.bulletObstacleDidCollide(bullet: bullet, obstacle: obs)
            }
        } else if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Monster != 0)) {
            if let obs1 = firstBody.node as? SKSpriteNode, let
                obs2 = secondBody.node as? SKSpriteNode {
                self.obstaclesDidCollideWithEachOther(obs1: obs1, obs2: obs2)
            }
        } else if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Player != 0)) {
            if let obs = firstBody.node as? SKSpriteNode, let
                currPlayer = secondBody.node as? SKSpriteNode {
                self.obstacleDidCollideWithPlayer(obs: obs, player: currPlayer)
            }
        } else if ((secondBody.categoryBitMask & PhysicsCategory.Map != 0)) {
            if let object = firstBody.node as? SKSpriteNode {
                self.objectDidCollideWithMap(object: object)
            }
        }
    }
    
    private func bulletObstacleDidCollide(bullet: SKSpriteNode, obstacle: SKSpriteNode) {
        print ("Hit!")
        self.scene.removeElement(node: bullet)
        let obstacleGotHit = self.obstaclePool.filter({$0.shape == obstacle})[0]
        // obstacle's physics body shape should be modified to the current size
        obstacleGotHit.hitByBullet()
        if obstacleGotHit.checkDestroyed() {
            self.scene.removeElement(node: obstacle)
            let obsDestroyedTime = DispatchTime.now()
            let elapsedTimeInSeconds = Float(obsDestroyedTime.uptimeNanoseconds - self.startTime.uptimeNanoseconds) / 1_000_000_000
            let scoreForThisObs = Int(Constants.defaultScoreDivider / elapsedTimeInSeconds)
            self.currLevelObtainedScore += scoreForThisObs
            self.scene.displayScoreAnimation(displayScore: scoreForThisObs)
            print (self.currLevelObtainedScore)
        }
    }
    
    // For now impulse does not seem to show great visual effects
    private func obstaclesDidCollideWithEachOther(obs1: SKSpriteNode, obs2: SKSpriteNode) {
        let obstacle1Velocity = obs1.physicsBody?.velocity.normalized()
        let obstacle2Velocity = obs2.physicsBody?.velocity.normalized()
        
        let impulse1 = CGVector(dx: obstacle2Velocity!.dx * Constants.obstacleImpulseValue, dy: obstacle2Velocity!.dy * Constants.obstacleImpulseValue)
        let impulse2 = CGVector(dx: obstacle1Velocity!.dx * Constants.obstacleImpulseValue, dy: obstacle1Velocity!.dy * Constants.obstacleImpulseValue)

        obs1.physicsBody?.applyImpulse(impulse1)
        obs2.physicsBody?.applyImpulse(impulse2)
        
        // print ("Impulse triggered!")
        //self.scene.displayObstacleImpulseAnimation()
    }
    
    private func obstacleDidCollideWithPlayer(obs: SKSpriteNode, player: SKSpriteNode) {
        self.player.hitByObstacle()
        if self.player.checkDead() {
            print ("You are dead!")
            self.scene.removeElement(node: player)
        }
    }

    private func objectDidCollideWithMap(object: SKSpriteNode) {
        // TODO: The interaction between player and boundary seems buggy (probably due to player physics body)
        object.removeAllActions()
        print("collision detected")
    }
    /* End of game logic related methods */
}
