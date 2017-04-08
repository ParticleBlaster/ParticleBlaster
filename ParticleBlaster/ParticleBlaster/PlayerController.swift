//
//  Controller.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 27/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

class PlayerController {
    var player = Player(image: "Spaceship")
    var joystickPlate = JoystickPlate(image: "plate")
    var joystick = Joystick(image: "top")
    var fireButton = FireButton(image: "fire")
    var bulletPool = [Bullet]()
    var missilePool = [Missile]()
    var scene: GameScene!
    var joystickPlateCenterX: CGFloat?
    var joystickPlateCenterY: CGFloat?
    var grenadeAnimationList = [SKTexture]()
    
    var obtainObstacleListHandler: (() -> ([Obstacle]))!
    
    private var flyingVelocity: CGFloat = CGFloat(0)
    private var isFlying: Bool = false
    private var playerUnitDirection: CGVector = CGVector(dx: 0, dy: 0)
    
    private var currFiringPosition: CGPoint {
        get {
            return self.player.shape.position
        }
    }
    
    private var currFiringAngle: CGFloat {
        get {
            return self.player.shape.zRotation
        }
    }
    
    init(gameViewController: GameViewController) {
        self.scene = gameViewController.scene
        self.grenadeAnimationList = SpriteUtils.obtainSpriteNodeList(textureName: "explosion", rows: 4, cols: 4)
    }

    func updatePlayerVelocityHandler() {
        let direction = self.playerUnitDirection
        let newVelocity = CGVector(dx: direction.dx * self.flyingVelocity, dy: direction.dy * self.flyingVelocity)
        self.player.updateVelocity(newVelocity: newVelocity)
    }
    
    func updateMissileVelocityHandler() {
        for missile in self.missilePool {
            if missile.isReady {
                let currPosition = missile.shape.position
                let direction = CGVector(dx: missile.target.shape.position.x - currPosition.x, dy: missile.target.shape.position.y - currPosition.y).normalized()
                //let rotationAngle = atan2(direction.dy, direction.dx) - CGFloat.pi / 2
                let nextAngle = direction.eulerRotation()
                //let currAngle = missile.shape.zRotation
                //let rotationAngle = nextAngle - currAngle
                //let newVelocity = CGVector(dx: direction.dx * Constants.missileVelocity, dy: direction.dy * Constants.missileVelocity)
                let rotateAction = SKAction.rotate(toAngle: nextAngle, duration: 1)
                missile.shape.run(rotateAction)
                //missile.updateRotation(newAngle: rotationAngle)
                //missile.updateVelocity(newVelocity: newVelocity)
                
                
                let appliedForce = CGVector(dx: direction.dx * Constants.missileInitialForceValue, dy: direction.dy * Constants.missileInitialForceValue)
                let forceCenter = self.scene.convert(CGPoint(x: 0.5, y: 1), from: missile.shape)
                missile.pushedByForceWithPoint(force: appliedForce, point: forceCenter)
            }
        }
    }
    
    func endJoystickMoveHandler() {
        self.flyingVelocity = CGFloat(0)
        self.player.shape.removeAllActions()
        if self.isFlying {
            self.isFlying = false
            self.joystick.releaseJoystick()
            self.flyingVelocity = CGFloat(0)
        }
    }
    
    func moveJoystickAndRotatePlayerHandler(touchLocation: CGPoint) {
        self.isFlying = true
        let direction = CGVector(dx: touchLocation.x - joystickPlateCenterX!, dy: touchLocation.y - joystickPlateCenterY!)
        let length = sqrt(direction.dx * direction.dx + direction.dy * direction.dy)
        self.playerUnitDirection = direction.normalized()
        let rotationAngle = atan2(self.playerUnitDirection.dy, self.playerUnitDirection.dx) - CGFloat.pi / 2
        var radius = Constants.joystickPlateWidth / 2
        self.flyingVelocity = length >= radius ? Constants.playerVelocity : Constants.playerVelocity * (length / radius)
        if length < radius {
            radius = length
        }
        
        let newJoystickPosition = CGPoint(x: joystickPlateCenterX! + self.playerUnitDirection.dx * radius, y: joystickPlateCenterY! + self.playerUnitDirection.dy * radius)
        self.joystick.updatePosition(newLoation: newJoystickPosition)
        self.player.updateRotation(newAngle: rotationAngle)
    }
    
    func moveMFIJoystickAndRotatePlayerHandler(_ directionPercent: CGVector) {
        let direction = directionPercent.normalizeJoystickDirection()
        let length = direction.length()
        self.playerUnitDirection = direction.normalized()
        let rotationAngle = atan2(self.playerUnitDirection.dy, self.playerUnitDirection.dx) - CGFloat.pi / 2
        var radius = Constants.joystickPlateWidth / 2
        self.flyingVelocity = length >= radius ? Constants.playerVelocity : Constants.playerVelocity * (length / radius)
        if length < radius {
            radius = length
        }

//        let newJoystickPosition = CGPoint(x: Constants.joystickPlateCenterX + self.unitOffset.dx * radius, y: Constants.joystickPlateCenterY + self.unitOffset.dy * radius)
//        self.joystick.updatePosition(newLoation: newJoystickPosition)
//        self.player.updateRotation(newAngle: rotationAngle)
        let newJoystickPosition = CGPoint(x: joystickPlateCenterX! + self.playerUnitDirection.dx * radius, y: joystickPlateCenterY! + self.playerUnitDirection.dy * radius)
        self.joystick.updatePosition(newLoation: newJoystickPosition)
        self.player.updateRotation(newAngle: rotationAngle)
    }

    func throwGrenadeHandler() {
        let grenadeNode = SKSpriteNode(imageNamed: "bullet-red")
        grenadeNode.size = CGSize(width: Constants.grenadeRadius, height: Constants.grenadeRadius)
        grenadeNode.position = Constants.viewCentralPoint
        
        self.scene.addChild(grenadeNode)
        
        let explosionAnimation = SKAction.animate(with: self.grenadeAnimationList, timePerFrame: 0.05)
        //let completeAnimation = SKAction.sequence([SKAction.wait(forDuration: 1), explosionAnimation])
        //grenadeNode.run(completeAnimation)
        grenadeNode.run(SKAction.wait(forDuration: 1), completion: {
            //grenadeNode.alpha = 0
            grenadeNode.size = CGSize(width: Constants.grenadeRadius * 4, height: Constants.grenadeRadius * 4)
            grenadeNode.run(explosionAnimation)
        })
        
        
        let grenade = Grenade()
        let grenadeVelocity = CGVector(dx: self.playerUnitDirection.dx * Constants.grenadeThrowingVelocity, dy: self.playerUnitDirection.dy * Constants.grenadeThrowingVelocity)
        
        grenade.updateVelocity(newVelocity: grenadeVelocity)
        grenade.shape.position = self.currFiringPosition
        grenade.shape.zRotation = self.currFiringAngle
        grenade.shape.zPosition = -1
        
        //self.scene.addChild(grenade.shape)
        
        //SKAction.wait
    }
    
    func shootHandler() {
        let bullet = Bullet()
        let bulletVelocity = CGVector(dx: self.playerUnitDirection.dx * Constants.bulletVelocity, dy: self.playerUnitDirection.dy * Constants.bulletVelocity)
        
        bullet.updateVelocity(newVelocity: bulletVelocity)
        bullet.shape.position = self.currFiringPosition
        bullet.shape.zRotation = self.currFiringAngle
        bullet.shape.zPosition = -1
        
        self.bulletPool.append(bullet)
        self.scene.addChild(bullet.shape)
    }
    
    func launchMissileHandler() {
        // Note: currently it will choose the first obstacle in the list
        if let getObsListHandler = self.obtainObstacleListHandler {
            let obstacleList = getObsListHandler()
            // Current logic: always get the first obs available, otherwise don't launch
            if obstacleList.count > 0 {
                let targetObstacle = obstacleList[0]
                
                let missile = Missile(targetObs: targetObstacle)
                
                missile.shape.position = self.currFiringPosition
                missile.shape.zRotation = self.currFiringAngle
                missile.shape.zPosition = -1
                
                self.missilePool.append(missile)
                self.scene.addChild(missile.shape)
                let preparationDirection = self.playerUnitDirection.orthonormalVector()
                let preparationOffset = CGVector(dx: preparationDirection.dx * Constants.missileLaunchOffset, dy: preparationDirection.dy * Constants.missileLaunchOffset)
                
                let missileFadeInAction = SKAction.fadeIn(withDuration: Constants.missileLaunchTime)
                let missileLaunchAction = SKAction.move(by: preparationOffset, duration: Constants.missileLaunchTime)
                let initialForce = CGVector(dx: self.playerUnitDirection.dx * Constants.missileInitialForceValue, dy: self.playerUnitDirection.dy * Constants.missileInitialForceValue)
                
                let missileReleaseAction = SKAction.group([missileFadeInAction, missileLaunchAction])
                missile.shape.run(missileReleaseAction, completion: {
                    //let currObsMissileOffset = CGVector(dx: targetObstacle.shape.position.x - missile.shape.position.x, dy: targetObstacle.shape.position.y - missile.shape.position.y).normalized()
                    //let rotationAngle = currObsMissileOffset.eulerRotation() - missile.shape.zRotation
                    let forceCenter = self.scene.convert(CGPoint(x: 0.5, y: 1), from: missile.shape)
                    let missileInitalAccelerationAction = SKAction.applyForce(initialForce, at: forceCenter, duration: Constants.missileInitialAccelerationTime)
                        //SKAction.applyForce(initialForce, duration: Constants.missileInitialAccelerationTime)
                    //SKAction.app
                    //let missileInitialRotateAction = SKAction.rotate(byAngle: rotationAngle, duration: Constants.missileInitialAccelerationTime)
                    //let missileFlyAction = SKAction.group([missileInitalAccelerationAction, missileInitialRotateAction])
                    let missileFlyAction = missileInitalAccelerationAction
                    missile.shape.run(missileFlyAction, completion: {
                        missile.isReadyToFly()
                    })
                })
            }
            
        }
        
    }
    
    func updateJoystickPlateCenter(x: CGFloat, y: CGFloat) {
        self.joystickPlateCenterX = x
        self.joystickPlateCenterY = y
    }
    
    func playerIsDead() {
        self.player.shape.removeFromParent()
        
    }
    
    func removeBullet(bulletNode: SKSpriteNode) {
        self.bulletPool = self.bulletPool.filter({$0.shape != bulletNode})
    }
}
