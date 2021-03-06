//
//  GameScene.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 12/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/**
 *  The `SinglePlayerGameScene` class subclasses the GameScene class
 *  It defines the logic for user interactions in SinglePlayer mode
 */


import SpriteKit
import GameplayKit

class SinglePlayerGameScene: GameScene {

    /* Start of stored properties */
    private var plateAllowedRange: SKShapeNode!
    private var plateTouchEndRange: SKShapeNode!
    /* End of stored properties */
    
    /* Start of computed properties; joystick set UI elements */
    var player: Player {
        get {
            return self.players.first!
        }
    }
    
    var joystickPlate: JoystickPlate {
        get {
            return self.joystickPlates.first!
        }
    }

    var joystick: Joystick {
        get {
            return self.joysticks.first!
        }
    }
    
    var fireButton: FireButton {
        get {
            return self.fireButtons.first!
        }
    }
    /* End of computed properties; joystick set UI elements */
    
    /* Start of overriding functions from SKScene */
    override func didMove(to view: SKView) {
        self.wasPaused = false
        self.setupBackgroundWithSprite()
        
        addChild(player.shape)
        
        setupVirtualJoystick()
        setupPhysicsWorld()
        setupPauseButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.checkVirtualControllerOp(touch: t)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.checkVirtualControllerOp(touch: t)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            if self.checkTouchRange(touch: touch, frame: plateAllowedRange.frame) {
                if let endHandler = self.endJoystickMoveHandlers.first {
                    endHandler()
                }
            } else if self.checkTouchRange(touch: touch, frame: fireButton.shape.frame) {
                self.fireButton.shape.alpha = Constants.fireButtonReleaseAlpha
                if let shootHandler = self.fireHandlers.first {
                    shootHandler()
                }
                
                self.fireButton.fireButtonReleased()
            } else if self.checkTouchRange(touch: touch, frame: buttonBackToHomepage.frame) {
                self.viewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard self.wasPaused == false else {
            return
        }
        
        if let playerVelocityHandler = self.playerVelocityUpdateHandlers.first {
            playerVelocityHandler()
        }
        if let obstacleVelocityHandler = self.obstacleVelocityUpdateHandler {
            obstacleVelocityHandler()
        }
        if let velocityHandler = self.updateWeaponVelocityHandlers.first {
            velocityHandler()
        }
    }
    /* End of overriding functions from SKScene */
    
    /* Start of overriding supporting functions */
    // This function adds the joystick set UI elements into the scene
    override func setupVirtualJoystick() {
        // Initialization of joystick set UI elements has been done in PlayerController class
        addChild(joystickPlate.shape)
        addChild(joystick.shape)
        addChild(fireButton.shape)
        
        // plateAllowedRange and plateTouchEndRange are to give a buffer area for joystick operation and should not be added as child
        plateAllowedRange = SKShapeNode(circleOfRadius: Constants.joystickPlateAllowedRange)
        plateAllowedRange.position = CGPoint(x: SinglePlayerViewParams.joystickPlateCenter.x, y: SinglePlayerViewParams.joystickPlateCenter.y)
        plateTouchEndRange = SKShapeNode(circleOfRadius: Constants.joystickPlateTouchEndRange)
        plateTouchEndRange.position = CGPoint(x: SinglePlayerViewParams.joystickPlateCenter.x, y: SinglePlayerViewParams.joystickPlateCenter.y)
    }
    
    // This function invokes function handlers according to the ongoing gesture location
    override func checkVirtualControllerOp(touch: UITouch) {
        if self.checkTouchRange(touch: touch, frame: plateTouchEndRange.frame) {
            if self.checkTouchRange(touch: touch, frame: plateAllowedRange.frame) {
                if let rotateHandler = self.rotateJoystickAndPlayerHandlers.first {
                    let location = touch.location(in: self)
                    rotateHandler(location)
                }
            } else {
                if let endHandler = self.endJoystickMoveHandlers.first {
                    endHandler()
                }
            }
        } else if self.checkTouchRange(touch: touch, frame: self.fireButton.shape.frame) {
            self.fireButton.fireButtonPressed()
        }
    }
    /* End of overriding supporting functions */
    
}
