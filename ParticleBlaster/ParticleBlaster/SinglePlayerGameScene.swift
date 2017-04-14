//
//  GameScene.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 12/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit
import GameplayKit

class SinglePlayerGameScene: GameScene {
    private var monstersDestroyed = 0
    private let monstersDestroyRequirement = 10

    private var plateAllowedRange: SKShapeNode!
    private var plateTouchEndRange: SKShapeNode!
    private var plateAllowedRangeDistance: CGFloat!
    private var prevTime: TimeInterval?
    
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
    
    override func didMove(to view: SKView) {
        self.isPaused = false
        self.setupBackgroundWithSprite()
        
        addChild(player.shape)
        
        setupVirtualJoystick()
        //setupBackButton()
        setupPhysicsWorld()
    }
    
    private func setupVirtualJoystick() {
        // Initialization of joystick set has been done in PlayerController class
        addChild(joystickPlate.shape)
        addChild(joystick.shape)
        addChild(fireButton.shape)
        
        // plateAllowedRange and plateTouchEndRange are to give a buffer area for joystick operation and should not be added as child
        plateAllowedRange = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 50)
        plateAllowedRange.position = CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY)
        plateTouchEndRange = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 100)
        plateTouchEndRange.position = CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY)
    }
    
    private func checkVirtualControllerOp(touch: UITouch) {
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
        // Called before each frame is rendered
        guard self.isPaused == false else {
            return
        }
        
        if self.prevTime == nil {
            self.prevTime = currentTime
        } else {
            if let playerVelocityHandler = self.playerVelocityUpdateHandlers.first {
                playerVelocityHandler()
            }
            if let obstacleVelocityHandler = self.obstacleVelocityUpdateHandler {
                obstacleVelocityHandler()
            }
            if let velocityHandler = self.updateWeaponVelocityHandlers.first {
                velocityHandler()
            }

            self.prevTime = currentTime
        }
    }
}
