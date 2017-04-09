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
    var gameLevel: GameLevel?
    var players: [Player] = [Player]()
    var joystickPlates: [JoystickPlate] = [JoystickPlate]()
    var joysticks: [Joystick] = [Joystick]()
    var fireButtons: [FireButton] = [FireButton]()
    
    var rotateJoystickAndPlayerHandlers: [((CGPoint) -> ())] = [((CGPoint) -> ())]()
    var endJoystickMoveHandlers: [(() -> ())] = [(() -> ())]()
    var playerVelocityUpdateHandlers: [(() -> ())] = [(() -> ())]()
    var fireHandlers: [(() -> ())] = [(() -> ())]()
    var launchMissileHandlers: [(() -> ())] = [(() -> ())]()
    var updateMissileVelocityHandlers: [(() -> ())] = [(() -> ())]()
    var throwGrenadeHandlers: [(() -> ())] = [(() -> ())]()
    
    var obstacleHitHandler: (() -> ())?
    var obstacleMoveHandler: (() -> ())?
    var obstacleVelocityUpdateHandler: (() -> ())?
    
    let buttonBackToHomepage = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 100, height: 30), cornerRadius: 10)
    
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
        
        guard gameLevel != nil else {
            return
        }
        
        if let backgroundImageName = gameLevel!.backgroundImageName {
            let background = SKSpriteNode(imageNamed: backgroundImageName)
            background.position = CGPoint(x: frame.midX, y: frame.midY)
            background.size = size
            background.zPosition = -100
            addChild(background)
            print("the background is set with: \(backgroundImageName)")
        }
        
        for obstacle in gameLevel!.obstacles {
            obstacle.shape.zPosition = 1
            addChild(obstacle.shape)
            print("obs: \(String(describing: obstacle.imageName)) is added")
        }
    }
    
    func setupBackButton() {
        buttonBackToHomepage.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        buttonBackToHomepage.fillColor = SKColor.clear
        buttonBackToHomepage.strokeColor = SKColor.black
        buttonBackToHomepage.lineWidth = Constants.strokeSmall
        
        let buttonText = SKLabelNode(text: "Back")
        buttonText.fontSize = Constants.fontSizeSmall
        buttonText.fontName = Constants.titleFont
        buttonText.fontColor = UIColor.lightGray
        buttonText.position = CGPoint(x: buttonBackToHomepage.frame.size.width * 0.5, y: buttonBackToHomepage.frame.size.height * 0.25)
        
        buttonBackToHomepage.addChild(buttonText)
        addChild(buttonBackToHomepage)
    }
    
    func setupPhysicsWorld() {
        // Set up the physics world to have no gravity
        physicsWorld.gravity = CGVector.zero
        // Set the scene as the delegate to be notified when two physics bodies collide.
        if let controller = self.viewController {
            physicsWorld.contactDelegate = controller as SKPhysicsContactDelegate
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
