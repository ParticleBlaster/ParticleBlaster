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
    
    var scene: GameScene!
    // Game Objects
    var player = Player(image: "Spaceship")
    var joystickPlate = JoystickPlate(image: "plate")
    var joystick = Joystick(image: "top")
    var fireButton = FireButton(image: "fire")
    
    var obstaclePool = [Obstacle]()
    
    // Supporting Attributes
    private var xDestination: CGFloat = CGFloat(0)
    private var yDestination: CGFloat = CGFloat(0)
    private var unitOffset: CGVector = CGVector(dx: 0, dy: 1)
    //private let basicVelocity: CGFloat = CGFloat(400)
    private var flyingVelocity: CGFloat = CGFloat(0)
    //private var obstacleDirection: CGVector = CGVector(dx: 0, dy: 0)
    private var flying: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startHomePageView()
    }
    
    func startHomePageView() {
        //let scene = HomePageScene(size: view.bounds.size)
        self.scene = GameScene(size: view.bounds.size)
        Constants.initializeJoystickInfo(viewSize: view.bounds.size)
        
        // Attributes assignment
        scene.viewController = self
        scene.newPlayer = self.player
        scene.joystick = self.joystick
        scene.joystickPlate = self.joystickPlate
        scene.fireButton = self.fireButton
        
        // Logic handlers assignments
        scene.updatePlayerPositionHandler = self.movePlayerHandler
        scene.rotateJoystickAndPlayerHandler = self.moveJoystickAndRotatePlayerHandler
        scene.obstacleVelocityUpdateHandler = self.updateObstacleVelocityHandler
        scene.fireHandler = self.shootHandler
        
        // add here: prepare obstacles and pass obstacles into the scene according to level info
        self.prepareObstacles()
        for obs in self.obstaclePool {
            scene.addSingleObstacle(newObstacle: obs)
        }
        
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
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
    
    // Logic for preparing the obstacle according to selected level information
    private func prepareObstacles() {
        // Currently no level information, hence just add obstacles with fixed info
        let obs1 = Obstacle(userSetInitialPosition: CGPoint(x: Constants.obstacle1CenterX, y: Constants.obstacle1CenterY))
        let obs2 = Obstacle(userSetInitialPosition: CGPoint(x: Constants.obstacle2CenterX, y: Constants.obstacle2CenterY))
        self.prepareObstaclePhysicsProperty(obs: obs1)
        self.prepareObstaclePhysicsProperty(obs: obs2)
        
        self.obstaclePool.append(obs1)
        self.obstaclePool.append(obs2)
    }
    
    private func prepareObstaclePhysicsProperty(obs: Obstacle) {
        obs.shape.size = CGSize(width: Constants.obstacleWidth, height: Constants.obstacleHeight)
        obs.shape.physicsBody = SKPhysicsBody(rectangleOf: obs.shape.size)
        obs.shape.physicsBody?.isDynamic = true
        obs.shape.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        obs.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        obs.shape.physicsBody?.collisionBitMask = PhysicsCategory.Projectile
    }
    
    // Logic for GameScene goes here
    private func movePlayerHandler(elapsedTime: TimeInterval) {
        let currPos = self.player.shape.position
        let offset = CGVector(dx: self.flyingVelocity * self.unitOffset.dx * CGFloat(elapsedTime), dy: self.flyingVelocity * self.unitOffset.dy * CGFloat(elapsedTime))
        let finalPos = CGPoint(x: currPos.x + offset.dx, y: currPos.y + offset.dy)
        self.player.shape.run(SKAction.move(to: finalPos, duration: elapsedTime))
    }
    
    private func moveJoystickAndRotatePlayerHandler(touchLocation: CGPoint) {
        self.flying = true
        let direction = CGVector(dx: touchLocation.x - Constants.joystickPlateCenterX, dy: touchLocation.y - Constants.joystickPlateCenterY)
        let length = sqrt(direction.dx * direction.dx + direction.dy * direction.dy)
//        let directionVector = CGVector(dx: direction.dx / length, dy: direction.dy / length)
        self.unitOffset = direction.normalized()
        let rotationAngle = atan2(self.unitOffset.dy, self.unitOffset.dx) - CGFloat.pi / 2
        var radius = Constants.joystickPlateWidth / 2
        self.flyingVelocity = length >= radius ? Constants.playerVelocity : Constants.playerVelocity * (length / radius)
        if length < radius {
            radius = length
        }
        
        let newJoystickPosition = CGPoint(x: Constants.joystickPlateCenterX + self.unitOffset.dx * radius, y: Constants.joystickPlateCenterY + self.unitOffset.dy * radius)
        self.joystick.updatePosition(newLoation: newJoystickPosition)
        //joystick.position = CGPoint(x: Constants.joystickPlateCenterX + directionVector.dx * radius, y: Constants.joystickPlateCenterY + directionVector.dy * radius)
        //player.zRotation = rotationAngle
        self.player.updateRotation(newAngle: rotationAngle)
    }
    
    private func endJoystickMoveHandler() {
        self.flyingVelocity = CGFloat(0)
        if self.flying {
            self.flying = false
            self.joystick.shape.run(SKAction.move(to: CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY), duration: 0.2))
            //        self.player.run(SKAction.rotate(toAngle: 0, duration: 0.2))
            //        self.unitOffset = CGVector(dx:0, dy: 1)
            
            //let endingDrift = CGVector(dx: self.unitOffset.dx * 10, dy: self.unitOffset.dy * 10)
            //self.player.run(SKAction.move(by: endingDrift, duration: 0.2))
            self.flyingVelocity = CGFloat(0)
        }
    }
    
    private func moveObstacleHandler(elapsedTime: TimeInterval) {
        let currPlayerPosition = self.player.shape.position
    }
    
    private func updateObstacleVelocityHandler() {
        
    }
    
    // Ideas for the implementation of level: each GameObject should be associated with a default size
    private func shootHandler() {
        
        let missile = Bullet()
        missile.shape.size = CGSize(width: Constants.defaultBulletWidth, height: Constants.defaultBulletHeight)
        missile.shape.physicsBody = SKPhysicsBody(rectangleOf: missile.shape.size)
        missile.shape.physicsBody?.isDynamic = true
        missile.shape.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        missile.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        missile.shape.physicsBody?.collisionBitMask = PhysicsCategory.Monster
        missile.shape.physicsBody?.usesPreciseCollisionDetection = true
        missile.shape.physicsBody?.velocity = CGVector(dx: self.unitOffset.dx * Constants.bulletVelocity, dy: self.unitOffset.dy * Constants.bulletVelocity)
        let currFiringAngle = self.player.shape.zRotation
        let currFiringPosition = self.player.shape.position
        self.scene.addMissile(missile: missile, directionAngle: currFiringAngle, position: currFiringPosition)
        
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
                //projectileDidCollideWithMonster(projectile: projectile, monster: monster)
                self.bulletObstacleDidCollide(bullet: bullet, obstacle: obs)
                print ("Contact!")
            }
        }
    }
    
    private func bulletObstacleDidCollide(bullet: SKSpriteNode, obstacle: SKSpriteNode) {
        print ("Hit!")
        self.scene.removeElement(node: bullet)
    }
}
