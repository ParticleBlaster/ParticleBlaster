//
//  Controller.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 27/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation
import UIKit

class Controller {
    var player = Player(image: "Spaceship")
    var joystickPlate = JoystickPlate(image: "plate")
    var joystick = Joystick(image: "top")
    var fireButton = FireButton(image: "fire")
    
    private var flyingVelocity: CGFloat = CGFloat(0)
    private var isFlying: Bool = false
    private var unitOffset: CGVector = CGVector(dx: 0, dy: 0)
    
    init() {
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
    
    func updatePlayerVelocityHandler() {
        let direction = self.unitOffset
        let newVelocity = CGVector(dx: direction.dx * self.flyingVelocity, dy: direction.dy * self.flyingVelocity)
        self.player.updateVelocity(newVelocity: newVelocity)
    }
    
    func moveJoystickAndRotatePlayerHandler(touchLocation: CGPoint) {
        self.isFlying = true
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
}
