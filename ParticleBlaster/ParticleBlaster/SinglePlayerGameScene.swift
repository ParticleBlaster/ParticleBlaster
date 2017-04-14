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
        self.setupBackgroundWithSprite()
        
        addChild(player.shape)
        
        // Set up virtual joystick
        setupVirtualJoystick()
        // Set up back to homepage button
        //setupBackButton()
        // Set up physics world
        setupPhysicsWorld()
    }
    
    private func setupVirtualJoystick() {
        
//        joystickPlate.initializeJoystickPlate(position: CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY))
        addChild(joystickPlate.shape)
        
//        joystick.initializeJoystick(position: CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY), plateCenter: CGPoint(x: joystickPlate.shape.position.x, y: joystickPlate.shape.position.y))
        addChild(joystick.shape)
        
//        fireButton.initializeFireButton(position: CGPoint(x: Constants.fireButtonCenterX, y: Constants.fireButtonCenterY))
        addChild(fireButton.shape)
        
        // plateAllowedRange and plateTouchEndRange are to give a buffer area for joystick operation and should not be added as child
        plateAllowedRange = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 50)
        plateAllowedRange.position = CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY)
        plateTouchEndRange = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 100)
        plateTouchEndRange.position = CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY)
    }
    

    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
        
    // Possible implementation: displays a sequence of skspritenode showing the explosion
    func displayBulletHitAnimation() {
        
    }
    
    func addBullet(bullet: Bullet, directionAngle: CGFloat, position: CGPoint) {
        bullet.shape.position = position
        bullet.shape.zRotation = directionAngle
        bullet.shape.zPosition = -1
        
        addChild(bullet.shape)
        
    }
    
    private func checkTouchRange(touch: UITouch, frame: CGRect) -> Bool {
        let location = touch.location(in: self)
        if frame.contains(location) {
            return true
        } else {
            return false
        }
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
        
        if self.prevTime == nil {
            self.prevTime = currentTime
        } else {
            // new logic goes here
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
