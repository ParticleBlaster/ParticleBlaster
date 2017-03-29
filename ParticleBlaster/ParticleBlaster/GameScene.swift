//
//  GameScene.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 29/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation
import UIKit

protocol GameScene {
    var viewController: UIViewController! { get set }
    
    var players: [Player] { get set }
    var joystickPlates: [JoystickPlate] { get set }
    var joystick: [Joystick] { get set }
    var fireButton: [FireButton] { get set }
    
    var rotateJoystickAndPlayerHandler: ((CGPoint) -> ())? { get set }
    var endJoystickMoveHandler: (() -> ())? { get set }
    var playerVelocityUpdateHandler: (() -> ())? { get set }
    
    var obstacleHitHandler: (() -> ())? { get set }
    var obstacleMoveHandler: (() -> ())? { get set }
    var obstacleVelocityUpdateHandler: (() -> ())? { get set }
    var fireHandler: (() -> ())? { get set }
}
