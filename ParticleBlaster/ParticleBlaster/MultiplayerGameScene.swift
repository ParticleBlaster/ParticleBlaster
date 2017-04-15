//
//  MultiplayerGameScene.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 23/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/**
 *  The `MultiPlayerGameScene` class subclasses the GameScene class
 *  It defines the logic for user interactions in MultiPlayer mode
 */


import SpriteKit
import GameplayKit

class MultiplayerGameScene: GameScene {
    
    /* Start of stored properties */
    private var plateAllowedRange1: SKShapeNode!
    private var plateTouchEndRange1: SKShapeNode!
    private var plateAllowedRangeDistance1: CGFloat!
    
    private var plateAllowedRange2: SKShapeNode!
    private var plateTouchEndRange2: SKShapeNode!
    private var plateAllowedRangeDistance2: CGFloat!
    /* End of stored properties */
    
    /* Start of computed properties: joystick set UI elements */
    var player1: Player {
        get {
            return self.players[0]
        }
    }
    
    var joystickPlate1: JoystickPlate {
        get {
            return self.joystickPlates[0]
        }
    }
    
    var joystick1: Joystick {
        get {
            return self.joysticks[0]
        }
    }
    
    var fireButton1: FireButton {
        get {
            return self.fireButtons[0]
        }
    }
    
    var player2: Player {
        get {
            return self.players[1]
        }
    }
    
    var joystickPlate2: JoystickPlate {
        get {
            return self.joystickPlates[1]
        }
    }
    
    var joystick2: Joystick {
        get {
            return self.joysticks[1]
        }
    }
    
    var fireButton2: FireButton {
        get {
            return self.fireButtons[1]
        }
    }
    /* End of computed properties: joystick set UI elements */
    
    
    /* Start of computed properties: function handlers for both players' gestures */
    var rotateJoystickAndPlayerHandler1: ((CGPoint) -> ())? {
        get {
            if self.rotateJoystickAndPlayerHandlers.count > 0 {
                return rotateJoystickAndPlayerHandlers[0]
            } else {
                return nil
            }
        }
    }
    
    var endJoystickMoveHandler1: (() -> ())? {
        get {
            if self.endJoystickMoveHandlers.count > 0 {
                return endJoystickMoveHandlers[0]
            } else {
                return nil
            }
        }
    }
    
    var playerVelocityUpdateHandler1: (() -> ())? {
        get {
            if self.playerVelocityUpdateHandlers.count > 0 {
                return playerVelocityUpdateHandlers[0]
            } else {
                return nil
            }
        }
    }
    
    var weaponVelocityUpdateHandler1: (() -> ())? {
        get {
            if self.updateWeaponVelocityHandlers.count > 0 {
                return updateWeaponVelocityHandlers[0]
            } else {
                return nil
            }
        }
    }
    
    var fireHandler1: (() -> ())? {
        get {
            if self.fireHandlers.count > 0 {
                return fireHandlers[0]
            } else {
                return nil
            }
        }
    }
    
    var rotateJoystickAndPlayerHandler2: ((CGPoint) -> ())? {
        get {
            if self.rotateJoystickAndPlayerHandlers.count > 1 {
                return rotateJoystickAndPlayerHandlers[1]
            } else {
                return nil
            }
        }
    }
    
    var endJoystickMoveHandler2: (() -> ())? {
        get {
            if self.endJoystickMoveHandlers.count > 1 {
                return endJoystickMoveHandlers[1]
            } else {
                return nil
            }
        }
    }
    
    var playerVelocityUpdateHandler2: (() -> ())? {
        get {
            if self.playerVelocityUpdateHandlers.count > 1 {
                return playerVelocityUpdateHandlers[1]
            } else {
                return nil
            }
        }
    }
    
    var weaponVelocityUpdateHandler2: (() -> ())? {
        get {
            if self.updateWeaponVelocityHandlers.count > 1 {
                return updateWeaponVelocityHandlers[1]
            } else {
                return nil
            }
        }
    }
    
    var fireHandler2: (() -> ())? {
        get {
            if self.fireHandlers.count > 1 {
                return fireHandlers[1]
            } else {
                return nil
            }
        }
    }
    /* End of computed properties: function handlers for both players' gestures */
    
    /* Start of overriding functions from SKScene */
    override func didMove(to view: SKView) {
        self.isPaused = false
        self.setupBackgroundWithSprite()
        
        addChild(player1.shape)
        addChild(player2.shape)
        
        setupVirtualJoystick()
        setupPhysicsWorld()
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
            if self.checkTouchRange(touch: touch, frame: plateAllowedRange1.frame) {
                if let endHandler = self.endJoystickMoveHandler1 {
                    endHandler()
                }
            } else if self.checkTouchRange(touch: touch, frame:  fireButton1.shape.frame) {
                self.fireButton1.shape.alpha = 0.8
                if let shootHandler = self.fireHandler1 {
                    shootHandler()
                }
                fireButton1.fireButtonReleased()
            } else if self.checkTouchRange(touch: touch, frame: plateAllowedRange2.frame) {
                if let endHandler = self.endJoystickMoveHandler2 {
                    endHandler()
                }
            } else if self.checkTouchRange(touch: touch, frame:  fireButton2.shape.frame) {
                self.fireButton2.shape.alpha = 0.8
                if let shootHandler = self.fireHandler2 {
                    shootHandler()
                }
                fireButton2.fireButtonReleased()
            } else if self.checkTouchRange(touch: touch, frame: buttonBackToHomepage.frame) {
                self.viewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard self.isPaused == false else {
            return
        }
        
        // Called before each frame is rendered
        if let playerPositionHandler1 = self.playerVelocityUpdateHandler1 {
            playerPositionHandler1()
        }
        
        if let weaponVelocityHandler1 = self.weaponVelocityUpdateHandler1 {
            weaponVelocityHandler1()
        }
        
        if let playerPositionHandler2 = self.playerVelocityUpdateHandler2 {
            playerPositionHandler2()
        }
        
        if let weaponVelocityHandler2 = self.weaponVelocityUpdateHandler1 {
            weaponVelocityHandler2()
        }
    }
    /* End of overriding functions from SKScene */
    
    /* Start of overriding supprting functions */
    // This function adds the joystick set UI elements into the scene
    override func setupVirtualJoystick() {
        // Initialization of joystick set UI elements has been done in PlayerController class
        // joystick 1
        addChild(joystickPlate1.shape)
        addChild(joystick1.shape)
        addChild(fireButton1.shape)
        
        // plateAllowedRange is to give a buffer area for joystick operation and should not be added as child
        plateAllowedRange1 = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 50)
        plateAllowedRange1.position = MultiPlayerViewParams.joystickPlateCenter1
        plateTouchEndRange1 = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 100)
        plateTouchEndRange1.position = MultiPlayerViewParams.joystickPlateCenter1
        
        // joystick 2
        addChild(joystickPlate2.shape)
        addChild(joystick2.shape)
        addChild(fireButton2.shape)
        
        // plateAllowedRange is to give a buffer area for joystick operation and should not be added as child
        plateAllowedRange2 = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 50)
        plateAllowedRange2.position = MultiPlayerViewParams.joystickPlateCenter2
        plateTouchEndRange2 = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 200)
        plateTouchEndRange2.position = MultiPlayerViewParams.joystickPlateCenter2
    }
    
    // This function invokes function handlers according to the ongoing gesture location
    override func checkVirtualControllerOp(touch: UITouch) {
        if self.checkTouchRange(touch: touch, frame: plateTouchEndRange1.frame) {
            if self.checkTouchRange(touch: touch, frame: plateAllowedRange1.frame) {
                if let rotateHandler = self.rotateJoystickAndPlayerHandler1 {
                    let location = touch.location(in: self)
                    rotateHandler(location)
                }
            } else {
                if let endHandler = self.endJoystickMoveHandler1 {
                    endHandler()
                }
            }
        } else if self.checkTouchRange(touch: touch, frame: plateTouchEndRange2.frame) {
            if self.checkTouchRange(touch: touch, frame: plateAllowedRange2.frame) {
                if let rotateHandler = self.rotateJoystickAndPlayerHandler2 {
                    let location = touch.location(in: self)
                    rotateHandler(location)
                }
            } else {
                if let endHandler = self.endJoystickMoveHandler2 {
                    endHandler()
                }
            }
        } else if self.checkTouchRange(touch: touch, frame: fireButton1.shape.frame) {
            fireButton1.fireButtonPressed()
        } else if self.checkTouchRange(touch: touch, frame: fireButton2.shape.frame) {
            fireButton2.fireButtonPressed()
        }
    }
    /* End of overriding supprting functions */
    
}
