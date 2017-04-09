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
    var player: Player
    var joystickPlate = JoystickPlate(image: "plate")
    var joystick = Joystick(image: "top")
    var fireButton = FireButton(image: "fire")
    var weaponPool = [Weapon]()
    var scene: GameScene!
    var joystickPlateCenterX: CGFloat?
    var joystickPlateCenterY: CGFloat?
    var grenadeAnimationList = [SKTexture]()
    
    var obtainObstacleListHandler: (() -> ([Obstacle]))!
    
    private var flyingVelocity: CGFloat = CGFloat(0)
    private var isFlying: Bool = false
    private var playerUnitDirection: CGVector = CGVector(dx: 0, dy: 1)
    
    var selectedWeaponType = WeaponCategory.Bullet
    var selectedWeapon: Weapon!
    var specialWeaponCounter: Int = 0
    
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
    
    init(gameViewController: GameViewController, playerIndex: Int = 1) {
        let playerImageName = playerIndex == 1 || playerIndex == 2 ? "\(Constants.playerFilenamePrefix)\(playerIndex)" : Constants.spaceshipFilename
        self.player = Player(image: playerImageName)
        self.scene = gameViewController.scene
        self.grenadeAnimationList = SpriteUtils.obtainSpriteNodeList(textureName: "explosion", rows: 4, cols: 4)
    }
    
    func removeWeaponAfterCollision(weaponNode: SKSpriteNode) {
        self.weaponPool = self.weaponPool.filter({$0.shape != weaponNode})
        self.scene.removeElement(node: weaponNode)
    }

    func updatePlayerVelocityHandler() {
        let direction = self.playerUnitDirection
        let newVelocity = CGVector(dx: direction.dx * self.flyingVelocity, dy: direction.dy * self.flyingVelocity)
        self.player.updateVelocity(newVelocity: newVelocity)
    }
    
//    func updateMissileVelocityHandler() {
//        if self.selectedWeapon == WeaponCategory.Missile {
//            for missile in self.missilePool {
//                if missile.isReady {
//                    let currPosition = missile.shape.position
//                    let direction = CGVector(dx: missile.target.shape.position.x - currPosition.x, dy: missile.target.shape.position.y - currPosition.y).normalized()
//                    let nextAngle = direction.eulerRotation()
//                    let rotateAction = SKAction.rotate(toAngle: nextAngle, duration: 1)
//                    missile.shape.run(rotateAction)
//                    
//                    let appliedForce = CGVector(dx: direction.dx * Constants.missileInitialForceValue, dy: direction.dy * Constants.missileInitialForceValue)
//                    let forceCenter = self.scene.convert(CGPoint(x: 0.5, y: 1), from: missile.shape)
//                    missile.pushedByForceWithPoint(appliedForce: appliedForce, point: forceCenter)
//                }
//            }
//        }
//    }
    
    func updateWeaponVelocityHandler() {
        for currFlyingWeapon in self.weaponPool {
            switch currFlyingWeapon.weaponType {
            case .Bullet, .Grenade:
                break
            case .Missile:
                // Implement here to call the update velocity function
                guard let currFlyingMissile = currFlyingWeapon as? Missile else {
                    return
                }
                currFlyingMissile.updateFlyingVelocity()
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
    
    func grenadeExplode(grenadeNode: SKSpriteNode) {
//        let grenade = self.grenadePool.filter({$0.shape == grenadeNode})[0]
//        let explosionAnimation = SKAction.animate(with: self.grenadeAnimationList, timePerFrame: 0.05)
//        
//        grenade.explode()
//        grenade.shape.run(explosionAnimation, completion: {
//            self.removeWeaponAfterCollision(weaponNode: grenadeNode, weaponType: WeaponCategory.Grenade)
//        })
        
        
        if let grenade = self.weaponPool.filter({$0.shape == grenadeNode}).first as? Grenade {
            grenade.explode()
            let removeGrenadeElementTime = DispatchTime.now() + Constants.grenadeExplosionAnimationTime
            DispatchQueue.main.asyncAfter(deadline: removeGrenadeElementTime) {
                self.removeWeaponAfterCollision(weaponNode: grenadeNode)
            }
        }
    }
    
    func fireHandler() {
//        if self.selectedWeapon == WeaponCategory.Bullet || self.specialWeaponCounter == 0 {
//            shootHandler()
//            self.selectedWeapon = WeaponCategory.Bullet
//        } else {
//            switch self.selectedWeapon {
//            case .Missile:
//                launchMissileHandler()
//            case .Grenade:
//                throwGrenadeHandler()
//            default:
//                break
//            }
//            self.specialWeaponCounter -= 1
//        }
        
        
        self.selectedWeaponType = self.specialWeaponCounter <= 0 ? WeaponCategory.Bullet : self.selectedWeaponType
        
        switch self.selectedWeaponType {
        case .Bullet:
            self.selectedWeapon = Bullet(shootLocation: self.currFiringPosition, shootDirection: self.playerUnitDirection, rotation: self.currFiringAngle)
        case .Grenade:
            self.selectedWeapon = Grenade(shootLocation: self.currFiringPosition, shootDirection: self.playerUnitDirection, rotation: self.currFiringAngle)
        case .Missile:
            // Note: currently it will choose the first obstacle in the list
            if let getObsListHandler = self.obtainObstacleListHandler {
                let obstacleList = getObsListHandler()
                // Current logic: always get the first obs available, otherwise switch back to Bullet
                if obstacleList.count > 0 {
                    let targetObstacle = obstacleList[0]
                    
                    self.selectedWeapon = Missile(shootLocation: self.currFiringPosition, shootDirection: self.playerUnitDirection, rotation: self.currFiringAngle, targetObs: targetObstacle, scene: self.scene)
                } else {
                    self.selectedWeapon = Bullet(shootLocation: self.currFiringPosition, shootDirection: self.playerUnitDirection, rotation: self.currFiringAngle)
                }
            }
            
        }
        
        guard let weaponToUse = self.selectedWeapon else {
            return
        }
        weaponToUse.launch()
        self.specialWeaponCounter -= 1
        self.scene.addChild(weaponToUse.shape)
        self.weaponPool.append(weaponToUse)
        
    }

    /*
    func throwGrenadeHandler() {
        
        let grenade = Grenade()
        let grenadeDistance = CGVector(dx: self.playerUnitDirection.dx * Constants.grenadeThrowingDistance, dy: self.playerUnitDirection.dy * Constants.grenadeThrowingDistance)
        
        grenade.shape.position = self.currFiringPosition
        grenade.shape.zRotation = self.currFiringAngle
        grenade.shape.zPosition = -1
        
        self.scene.addChild(grenade.shape)
        
        let throwingAction = SKAction.move(by: grenadeDistance, duration: TimeInterval(Constants.grenadeThrowingTime))
        
        
        self.grenadePool.append(grenade)
        
        grenade.shape.run(throwingAction, completion: {
//            grenade.explode()
//            grenade.shape.run(explosionAnimation, completion: {
//                grenade.shape.removeFromParent()
//            })
            
            self.grenadeExplode(grenadeNode: grenade.shape)
        })
        
        
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
        AudioUtils.playShootingSound(on: self.scene)
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
                    let forceCenter = self.scene.convert(CGPoint(x: 0.5, y: 1), from: missile.shape)
                    let missileInitalAccelerationAction = SKAction.applyForce(initialForce, at: forceCenter, duration: Constants.missileInitialAccelerationTime)
                    let missileFlyAction = missileInitalAccelerationAction
                    missile.shape.run(missileFlyAction, completion: {
                        missile.isReadyToFly()
                    })
                })
            }
            
        }
        
    }
    */
    
    func upgradeWeapon(newWeapon: WeaponCategory) {
        self.selectedWeaponType = newWeapon
        self.specialWeaponCounter = newWeapon.getSpecialWeaponCounterNumber()
        
    }

    func updateJoystickPlateCenter(x: CGFloat, y: CGFloat) {
        self.joystickPlateCenterX = x
        self.joystickPlateCenterY = y
    }
    
    func playerIsDead() {
        self.player.shape.removeFromParent()
    }
}
