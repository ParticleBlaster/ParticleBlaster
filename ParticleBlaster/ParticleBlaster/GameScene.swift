//
//  GameScene.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 29/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/*
 * The `GameScene` class is the basic implementation of the SKScene
 *      - It declares the function handlers for the touch gestures to be recognized in the diff modes
 *      - It defines setup methods which should be shared by Single and Multi player modes
 *      - It defines functions for addition and removal of elements inside the scene
 *      - It declares the physics delegate to be implemented
 */


import UIKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    /* Start of stored UI elements and properties */
    var viewController: GameViewController!
    var background = SKSpriteNode()
    var players: [Player] = [Player]()
    var joystickPlates: [JoystickPlate] = [JoystickPlate]()
    var joysticks: [Joystick] = [Joystick]()
    var fireButtons: [FireButton] = [FireButton]()
    /* End of stored UI elements and properties */
    
    /* Start of function handlers declaration for gesture recognition */
    var rotateJoystickAndPlayerHandlers: [((CGPoint) -> ())] = [((CGPoint) -> ())]()
    var endJoystickMoveHandlers: [(() -> ())] = [(() -> ())]()
    var playerVelocityUpdateHandlers: [(() -> ())] = [(() -> ())]()
    var fireHandlers: [(() -> ())] = [(() -> ())]()
    var updateWeaponVelocityHandlers: [(() -> ())] = [(() -> ())]()
    var obstacleVelocityUpdateHandler: (() -> ())!
    /* End of function handlers declaration for gesture recognition */
    
    // UI element: back button; navigation to the previous page
    let buttonBackToHomepage = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 100, height: 30), cornerRadius: 10)
    
    /* Start of setup methods */
    // This function sets up the back button to be displayed
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
    
    // This function initializes the physics world; no gravity, delegate to GameViewController
    func setupPhysicsWorld() {
        physicsWorld.gravity = CGVector.zero
        if let controller = self.viewController {
            physicsWorld.contactDelegate = controller as SKPhysicsContactDelegate
        }
    }
    
    // This function sets up the background given an image name
    func setupBackground(backgroundImageName: String?) {
        guard (backgroundImageName != nil) else {
            return
        }
        
        let background = SKSpriteNode(imageNamed: backgroundImageName!)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = size
        background.zPosition = -100
        addChild(background)
    }
    
    // This function sets up the background based on the requested GameLevel
    func setupBackgroundWithSprite() {
        self.background.texture = SKTexture(imageNamed: self.viewController.gameLevel.backgroundImageName)
        self.background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.background.size = self.size
        self.background.zPosition = Constants.defaultBackgroundZPosition
        self.addChild(self.background)
    }
    /* End of setup methods */
    
    /* Start of UI elements manipulation methods */
    // This function removes the SKNode from the scene
    func removeElement(node: SKSpriteNode) {
        node.removeFromParent()
    }
    
    // This function adds the obstacle into the scene
    func addSingleObstacle(newObstacle: Obstacle) {
        newObstacle.shape.position = newObstacle.initialPosition
        addChild(newObstacle.shape)
    }
    
    // This function is invoked when an obstacle is destroyed, displaying the score obtained
    func displayScoreAnimation(displayScore: Int, scoreSceneCenter: CGPoint) {
        let score = "+" + String(displayScore)
        let label = SKLabelNode(fontNamed: Constants.destroyObstacleScoreFont)
        label.text = score
        label.fontSize = Constants.destroyObstacleScoreFontSize
        label.fontColor = SKColor.orange
        label.position = scoreSceneCenter
        label.alpha = 0
        addChild(label)
        let fadeInAction = SKAction.fadeIn(withDuration: Constants.destroyObstacleScoreFadeTime)
        let fadeOutAction = SKAction.fadeOut(withDuration: Constants.destroyObstacleScoreFadeTime)
        let moveAction = SKAction.move(by: Constants.destroyObstacleScoreOffset, duration: Constants.destroyObstacleScoreFadeTime)
        let labelAction = SKAction.sequence([SKAction.group([fadeInAction, moveAction]), SKAction.group([fadeOutAction, moveAction])])
        label.run(labelAction, completion: {
            label.removeFromParent()
        })
    }
    /* End of UI elements manipulation methods */
    
    /* Start of supporting functions for different implementations of GameScene */
    // This function plays the requested music
    func playMusic(musicName: String) {
        self.run(SKAction.playSoundFileNamed(musicName, waitForCompletion: false))
    }
    
    // This function checks whether an UITouch locates inside the selected area
    func checkTouchRange(touch: UITouch, frame: CGRect) -> Bool {
        let location = touch.location(in: self)
        if frame.contains(location) {
            return true
        } else {
            return false
        }
    }
    /* End of supporting functions for different implementations of GameScene */
}
