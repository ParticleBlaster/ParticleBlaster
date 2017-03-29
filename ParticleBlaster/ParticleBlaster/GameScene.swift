//
//  GameScene.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 29/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var viewController: UIViewController!
    var players: [Player] = [Player]()
    var joystickPlates: [JoystickPlate] = [JoystickPlate]()
    var joystick: [Joystick] = [Joystick]()
    var fireButton: [FireButton] = [FireButton]()
    
    var rotateJoystickAndPlayerHandler: [((CGPoint) -> ())] = [((CGPoint) -> ())]()
    var endJoystickMoveHandler: [(() -> ())] = [(() -> ())]()
    var playerVelocityUpdateHandlers: [(() -> ())] = [(() -> ())]()
    
    var obstacleHitHandler: (() -> ())?
    var obstacleMoveHandler: (() -> ())?
    var obstacleVelocityUpdateHandler: (() -> ())?
    var fireHandler: (() -> ())?
}
