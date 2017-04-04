//
//  Controller.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 27/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation
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
    
    private var flyingVelocity: CGFloat = CGFloat(0)
    private var isFlying: Bool = false
    private var unitOffset: CGVector = CGVector(dx: 0, dy: 0)
    
    init(gameViewController: GameViewController) {
        self.scene = gameViewController.scene
    }

    func updatePlayerVelocityHandler() {
        let direction = self.unitOffset
        let newVelocity = CGVector(dx: direction.dx * self.flyingVelocity, dy: direction.dy * self.flyingVelocity)
        self.player.updateVelocity(newVelocity: newVelocity)
    }
    
    func updateMissileVelocityHandler() {
        for missile in self.missilePool {
            let currPosition = missile.shape.position
            let direction = CGVector(dx: missile.target.shape.position.x - currPosition.x, dy: missile.target.shape.position.y - currPosition.y).normalized()
            let newVelocity = CGVector(dx: direction.dx * Constants.missileVelocity, dy: direction.dy * Constants.missileVelocity)
            missile.updateVelocity(newVelocity: newVelocity)
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
        self.unitOffset = direction.normalized()
        let rotationAngle = atan2(self.unitOffset.dy, self.unitOffset.dx) - CGFloat.pi / 2
        var radius = Constants.joystickPlateWidth / 2
        self.flyingVelocity = length >= radius ? Constants.playerVelocity : Constants.playerVelocity * (length / radius)
        if length < radius {
            radius = length
        }
        
        let newJoystickPosition = CGPoint(x: joystickPlateCenterX! + self.unitOffset.dx * radius, y: joystickPlateCenterY! + self.unitOffset.dy * radius)
        self.joystick.updatePosition(newLoation: newJoystickPosition)
        self.player.updateRotation(newAngle: rotationAngle)
    }
    
    func moveMFIJoystickAndRotatePlayerHandler(_ directionPercent: CGVector) {
        let direction = directionPercent.normalizeJoystickDirection()
        let length = direction.length()
        self.unitOffset = direction.normalized()
        let rotationAngle = atan2(self.unitOffset.dy, self.unitOffset.dx) - CGFloat.pi / 2
        var radius = Constants.joystickPlateWidth / 2
        self.flyingVelocity = length >= radius ? Constants.playerVelocity : Constants.playerVelocity * (length / radius)
        if length < radius {
            radius = length
        }

//        let newJoystickPosition = CGPoint(x: Constants.joystickPlateCenterX + self.unitOffset.dx * radius, y: Constants.joystickPlateCenterY + self.unitOffset.dy * radius)
//        self.joystick.updatePosition(newLoation: newJoystickPosition)
//        self.player.updateRotation(newAngle: rotationAngle)
        let newJoystickPosition = CGPoint(x: joystickPlateCenterX! + self.unitOffset.dx * radius, y: joystickPlateCenterY! + self.unitOffset.dy * radius)
        self.joystick.updatePosition(newLoation: newJoystickPosition)
        self.player.updateRotation(newAngle: rotationAngle)
    }


    
    func shootHandler() {
        let bullet = Bullet()
        let bulletVelocity = CGVector(dx: self.unitOffset.dx * Constants.bulletVelocity, dy: self.unitOffset.dy * Constants.bulletVelocity)
        let currFiringAngle = self.player.shape.zRotation
        let currFiringPosition = self.player.shape.position
        
        bullet.updateVelocity(newVelocity: bulletVelocity)
        bullet.shape.position = currFiringPosition
        bullet.shape.zRotation = currFiringAngle
        bullet.shape.zPosition = -1
        
        self.bulletPool.append(bullet)
        self.scene.addChild(bullet.shape)
    }
    
    func launchMissile(taregtObstacle: Obstacle) {
        // Note: currently it will choose the first obstacle in the list
        let missile = Missile(targetObs: taregtObstacle)
        let currFiringAngle = self.player.shape.zRotation
        let currFiringPosition = self.player.shape.position
        
        missile.shape.position = currFiringPosition
        missile.shape.zRotation = currFiringAngle
        missile.shape.zPosition = -1
        
        self.missilePool.append(missile)
        self.scene.addChild(missile.shape)
        let preparationDirection = self.unitOffset.orthonormalVector()
        let preparationOffset = CGVector(dx: preparationDirection.dx * Constants.missileLaunchOffset, dy: preparationDirection.dy * Constants.missileLaunchOffset)
        
        let missileFadeInAction = SKAction.fadeIn(withDuration: Constants.missileLaunchTime)
        let missileLaunchAction = SKAction.move(by: preparationOffset, duration: Constants.missileLaunchTime)
        let missileAction = SKAction.group([missileFadeInAction, missileLaunchAction])
        missile.shape.run(missileAction, completion: {
            missile.isReadyToFly()
        })
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
