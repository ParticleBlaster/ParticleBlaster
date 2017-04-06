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
    var viewController: GameViewController!
    var gameLevel: GameLevel!
    var players: [Player] = [Player]()
    var joystickPlates: [JoystickPlate] = [JoystickPlate]()
    var joysticks: [Joystick] = [Joystick]()
    var fireButtons: [FireButton] = [FireButton]()
    
    var rotateJoystickAndPlayerHandlers: [((CGPoint) -> ())] = [((CGPoint) -> ())]()
    var endJoystickMoveHandlers: [(() -> ())] = [(() -> ())]()
    var playerVelocityUpdateHandlers: [(() -> ())] = [(() -> ())]()
    var fireHandlers: [(() -> ())] = [(() -> ())]()
    
    var obstacleHitHandler: (() -> ())?
    var obstacleMoveHandler: (() -> ())?
    var obstacleVelocityUpdateHandler: (() -> ())?
    
    func removeElement(node: SKSpriteNode) {
        node.removeFromParent()
    }
    
    func displayScoreAnimation(displayScore: Int, scoreSceneCenter: CGPoint) {
        let score = "+" + String(displayScore)
        let label = SKLabelNode(fontNamed: Constants.destroyObstacleScoreFont)
        label.text = score
        label.fontSize = Constants.destroyObstacleScoreFontSize
        label.fontColor = SKColor.orange
        label.position = scoreSceneCenter
        label.alpha = 0
        addChild(label)
        // animation for moving the label upwards by Constants.offset, and change alpha to 1
        // then moving it upwards also by offset, change alpha to 0; remove label from scene
        let fadeInAction = SKAction.fadeIn(withDuration: Constants.destroyObstacleScoreFadeTime)
        let fadeOutAction = SKAction.fadeOut(withDuration: Constants.destroyObstacleScoreFadeTime)
        let moveAction = SKAction.move(by: Constants.destroyObstacleScoreOffset, duration: Constants.destroyObstacleScoreFadeTime)
        let labelAction = SKAction.sequence([SKAction.group([fadeInAction, moveAction]), SKAction.group([fadeOutAction, moveAction])])
        label.run(labelAction, completion: {
            label.removeFromParent()
        })
    }
    
    func loadGameLevel() {
        backgroundColor = Constants.backgroundColor
        
        if let backgroundImageName = gameLevel.backgroundImageName {
            let background = SKSpriteNode(imageNamed: backgroundImageName)
            background.position = CGPoint(x: frame.midX, y: frame.midY)
            background.size = size
            background.zPosition = -100
            addChild(background)
        }
        
        for obstacle in gameLevel.obstacles {
            obstacle.shape.zPosition = 1
            addChild(obstacle.shape)
        }
    }
    
    func addSingleObstacle(newObstacle: Obstacle) {
        newObstacle.shape.position = newObstacle.initialPosition
        addChild(newObstacle.shape)
    }
    
    func addBoundary(boundary: SKShapeNode) {
        addChild(boundary)
    }
}
