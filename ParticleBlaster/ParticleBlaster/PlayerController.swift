//
//  Controller.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 27/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/*
 * The `PlayerController` class serves as the controller module for logic related to the player's actions
 * including the movement of the player itself, and the logic regarding the weapon system
 *      - It defines the set of UI elements related to the user, including joystick, fire button, player
 *      - It defines the movement of the joystick and the player according to the user's gestures
 *      - It links the weapon model with the game play logic
 *      - It defines the weapon system and the weapon logic when the user presses the fire button
*/

import UIKit
import SpriteKit

class PlayerController {
    
    /* Start of data models for UI elements */
    var player: Player
    var weaponPool = [Weapon]()
    var joystickPlate = JoystickPlate(image: "plate")
    var joystick = Joystick(image: "top")
    var fireButton = FireButton(image: "fire")
    private var scene: GameScene!
    /* End of data models for UI elements */
    
    /* Start of variables associated with data models */
    private var flyingVelocity: CGFloat = CGFloat(0)
    private var isFlying: Bool = false
    private var playerUnitDirection: CGVector = CGVector(dx: 0, dy: 1)
    
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
    /* End of variables associated with data models */
    
    // Function handlers, for obtaining obstacle list
    var obtainObstacleListHandler: (() -> ([Obstacle]))!
    
    /* Start of variables which support the logic for the game play */
    private var selectedWeaponType = WeaponCategory.Bullet
    private var selectedWeapon: Weapon!
    private var specialWeaponCounter: Int = 0
    /* End of variables which support the logic for the game play */
    
    
    // Initializer
    init(gameViewController: GameViewController, player: Player, controllerType: ControllerType) {
        self.player = player
        self.scene = gameViewController.scene
        self.initilizeJoystickSet(controllerType: controllerType)
    }
    
    /* Start of Joystick and Player position and velocity handler functions */
    // This function initializes the joystick set's components according to the controller type
    private func initilizeJoystickSet(controllerType: ControllerType) {
        switch controllerType {
        case .single:
            self.joystickPlate.initializeJoystickPlate(position: SinglePlayerViewParams.joystickPlateCenter)
            self.joystick.initializeJoystick(position: SinglePlayerViewParams.joystickPlateCenter)
            self.fireButton.initializeFireButton(position: SinglePlayerViewParams.fireButtonCenter)
        case .multi1:
            self.joystickPlate.initializeJoystickPlate(position: MultiPlayerViewParams.joystickPlateCenter1)
            self.joystick.initializeJoystick(position: MultiPlayerViewParams.joystickPlateCenter1)
            self.fireButton.initializeFireButton(position: MultiPlayerViewParams.fireButtonCenter1)
        case .multi2:
            self.joystickPlate.initializeJoystickPlate(position: MultiPlayerViewParams.joystickPlateCenter2)
            self.joystick.initializeJoystick(position: MultiPlayerViewParams.joystickPlateCenter2)
            self.fireButton.initializeFireButton(position: MultiPlayerViewParams.fireButtonCenter2)
            
        }
        
    }
    
    // This function moves the joystick according to the touch gestures
    func moveJoystickAndRotatePlayerHandler(touchLocation: CGPoint) {
        let direction = CGVector(dx: touchLocation.x - self.joystickPlate.shape.position.x, dy: touchLocation.y - self.joystickPlate.shape.position.y)
        self.updateJoystickAndPlayerRotationHandler(direction: direction)
    }
    
    // This function moves the joystick according to the MFI Game Joystick
    func moveMFIJoystickAndRotatePlayerHandler(_ directionPercent: CGVector) {
        let direction = directionPercent.normalizeJoystickDirection()
        self.updateJoystickAndPlayerRotationHandler(direction: direction)
    }
    
    //  This function moves the joystick and rotates the player according to the direction of the joystick, virtual or physical MFI
    private func updateJoystickAndPlayerRotationHandler(direction: CGVector) {
        self.isFlying = true
        let length = direction.length()
        self.playerUnitDirection = direction.normalized()
        let rotationAngle = atan2(self.playerUnitDirection.dy, self.playerUnitDirection.dx) - CGFloat.pi / 2
        var radius = Constants.joystickPlateWidth / 2
        self.flyingVelocity = length >= radius ? Constants.playerVelocity : Constants.playerVelocity * (length / radius)
        if length < radius {
            radius = length
        }
        
        let newJoystickPosition = CGPoint(x: self.joystickPlate.shape.position.x + self.playerUnitDirection.dx * radius, y: self.joystickPlate.shape.position.y + self.playerUnitDirection.dy * radius)
        self.joystick.updatePosition(newLoation: newJoystickPosition)
        self.player.updateRotation(newAngle: rotationAngle)
    }
    
    // This function updates the player's velocity according to the joystick's movement
    func updatePlayerVelocityHandler() {
        let direction = self.playerUnitDirection
        let newVelocity = CGVector(dx: direction.dx * self.flyingVelocity, dy: direction.dy * self.flyingVelocity)
        self.player.updateVelocity(newVelocity: newVelocity)
    }
    
    // This function resets the player's actions when the joystick is released
    func endJoystickMoveHandler() {
        self.flyingVelocity = CGFloat(0)
        self.player.shape.removeAllActions()
        if self.isFlying {
            self.isFlying = false
            self.joystick.releaseJoystick()
            self.flyingVelocity = CGFloat(0)
        }
    }
    /* End of Joystick and Player position and velocity handler functions */
    
    
    /* Start of weapon system logic */
    // This function upgrades the current selected weapon
    func upgradeWeapon(newWeapon: WeaponCategory) {
        self.selectedWeaponType = newWeapon
        self.specialWeaponCounter = newWeapon.getSpecialWeaponCounterNumber()
    }
    
    // This function determines the weapon to be used when the user presses the fire button, and subsequently launches the weapon
    func fireHandler() {
        self.selectedWeapon = nil
        self.selectedWeaponType = self.specialWeaponCounter <= 0 ? WeaponCategory.Bullet : self.selectedWeaponType
        
        // Force the weapon to be Bullet for debugging purposes
        //self.selectedWeaponType = WeaponCategory.Missile
        
        switch self.selectedWeaponType {
        case .Bullet:
            self.selectedWeapon = Bullet(shootLocation: self.currFiringPosition, shootDirection: self.playerUnitDirection, rotation: self.currFiringAngle)
        case .Grenade:
            let newSelectedWeapon = Grenade(shootLocation: self.currFiringPosition, shootDirection: self.playerUnitDirection, rotation: self.currFiringAngle)
            newSelectedWeapon.explosionAdvertiser = self.grenadeDidExplodeListener
            self.selectedWeapon = newSelectedWeapon
        case .Missile:
            if let getObsListHandler = self.obtainObstacleListHandler {
                let obstacleList = getObsListHandler()
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
        
        self.specialWeaponCounter -= 1
        self.scene.addChild(weaponToUse.shape)
        self.weaponPool.append(weaponToUse)
        weaponToUse.launch()
        AudioUtils.playMusic(named: weaponToUse.lauchMusicName, on: self.scene)
    }
    
    // This function updates the weapon's velocity if its velocity needs to be calculated per frame
    func updateWeaponVelocityHandler() {
        var obstacleNodeList = [SKSpriteNode]()
        if let getObsListHandler = self.obtainObstacleListHandler {
            obstacleNodeList = getObsListHandler().map({return $0.shape})
        }
        for currFlyingWeapon in self.weaponPool {
            switch currFlyingWeapon.weaponType {
            case .Bullet, .Grenade:
                break
            case .Missile:
                guard let currFlyingMissile = currFlyingWeapon as? Missile else {
                    return
                }
                if currFlyingMissile.isReady && obstacleNodeList.contains(currFlyingMissile.target.shape) {
                    currFlyingMissile.updateFlyingVelocity()
                }
            }
        }
    }
    
    // This function triggers the grenade to explode if it is hit by the obstacle
    func grenadeExplode(grenadeNode: SKSpriteNode) {
        if let grenade = self.weaponPool.filter({$0.shape == grenadeNode}).first as? Grenade {
            grenade.explode()
        }
    }
    
    // This function subscribes the returning message from Player Controller, and is handling the explosion music play and grenade removal after collision
    func grenadeDidExplodeListener(grenadeNode: SKSpriteNode) {
        AudioUtils.playMusic(named: Grenade.explosionMusicName, on: self.scene)
        let removeGrenadeElementTime = DispatchTime.now() + Constants.grenadeExplosionAnimationTime
        DispatchQueue.main.asyncAfter(deadline: removeGrenadeElementTime) {
            self.removeWeaponAfterCollision(weaponNode: grenadeNode)
        }
    }
    
    // This function is invoked when the weapon collides with the osbtacle; it updates the weapon's physics properties such that it won't collide with another obstacle or player
    func removeWeaponAfterCollision(weaponNode: SKSpriteNode) {
        weaponNode.physicsBody?.collisionBitMask = PhysicsCategory.None
        weaponNode.physicsBody?.contactTestBitMask = PhysicsCategory.None
        weaponNode.physicsBody?.categoryBitMask = PhysicsCategory.None
        self.weaponPool = self.weaponPool.filter({$0.shape != weaponNode})
        self.scene.removeElement(node: weaponNode)
    }
    /* End of weapon system logic */
}
