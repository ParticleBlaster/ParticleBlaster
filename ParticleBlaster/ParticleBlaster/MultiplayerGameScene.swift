//
//  MultiplayerGameScene.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 23/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit
import GameplayKit

class MultiplayerGameScene: GameScene {
    private var plateAllowedRange1: SKShapeNode!
    private var plateTouchEndRange1: SKShapeNode!
    private var plateAllowedRangeDistance1: CGFloat!
    
    private var plateAllowedRange2: SKShapeNode!
    private var plateTouchEndRange2: SKShapeNode!
    private var plateAllowedRangeDistance2: CGFloat!
    
    private var prevTime: TimeInterval?
    
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
    
    override func didMove(to view: SKView) {
        self.setupBackgroundWithSprite()
        //backgroundColor = Constants.backgroundColor
        // loadGameLevel()
        
//        player1.shape.size = CGSize(width: Constants.playerWidth, height: Constants.playerHeight)
//        player1.shape.position = CGPoint(x: MultiplayerViewParams.playerCenterX1, y: MultiplayerViewParams.playerCenterY1)
        addChild(player1.shape)
        
//        player2.shape.size = CGSize(width: Constants.playerWidth, height: Constants.playerHeight)
//        player2.shape.position = CGPoint(x: MultiplayerViewParams.playerCenterX2, y: MultiplayerViewParams.playerCenterY2)
        addChild(player2.shape)
        
        // Set up virtual joystick
        setupVirtualJoystick()
        // Set up back to homepage button
//        setupBackButton()
        // Set up physics world
        setupPhysicsWorld()
    }
    
    func setupVirtualJoystick() {
        // joystick 1
        
//        joystickPlate1.initializeJoystickPlate(position: CGPoint(x: MultiplayerViewParams.joystickPlateCenterX1, y: MultiplayerViewParams.joystickPlateCenterY1))
        addChild(joystickPlate1.shape)
        
//        joystick1.initializeJoystick(position: CGPoint(x: MultiplayerViewParams.joystickPlateCenterX1, y: MultiplayerViewParams.joystickPlateCenterY1), plateCenter: CGPoint(x: joystickPlate1.shape.position.x, y: joystickPlate1.shape.position.y))
        addChild(joystick1.shape)
        
//        fireButton1.initializeFireButton(position: CGPoint(x: MultiplayerViewParams.fireButtonCenterX1, y: MultiplayerViewParams.fireButtonCenterY1))
        addChild(fireButton1.shape)
        
        // plateAllowedRange is to give a buffer area for joystick operation and should not be added as child
        plateAllowedRange1 = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 50)
        plateAllowedRange1.position = MultiPlayerViewParams.joystickPlateCenter1
        plateTouchEndRange1 = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 100)
        plateTouchEndRange1.position = MultiPlayerViewParams.joystickPlateCenter1
        
        // joystick 2
        
//        joystickPlate2.initializeJoystickPlate(position: CGPoint(x: MultiPlayerViewParams.joystickPlateCenterX2, y: MultiPlayerViewParams.joystickPlateCenterY2))
        addChild(joystickPlate2.shape)
        
//        joystick2.initializeJoystick(position: CGPoint(x: MultiPlayerViewParams.joystickPlateCenterX2, y: MultiPlayerViewParams.joystickPlateCenterY2), plateCenter: CGPoint(x: joystickPlate2.shape.position.x, y: joystickPlate2.shape.position.y))
        addChild(joystick2.shape)
        
//        fireButton2.initializeFireButton(position: CGPoint(x: MultiPlayerViewParams.fireButtonCenterX2, y: MultiPlayerViewParams.fireButtonCenterY2))
        addChild(fireButton2.shape)
        
        // plateAllowedRange is to give a buffer area for joystick operation and should not be added as child
        plateAllowedRange2 = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 50)
        plateAllowedRange2.position = MultiPlayerViewParams.joystickPlateCenter2
        plateTouchEndRange2 = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 200)
        plateTouchEndRange2.position = MultiPlayerViewParams.joystickPlateCenter2
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func displayScoreAnimation(displayScore: Int) {
        
    }
    
    func displayBulletHitAnimation() {
        
    }
    
    func displayObstacleImpulseAnimation() {
        
    }
    
    func addBullet(bullet: Bullet, directionAngle: CGFloat, position: CGPoint) {
        bullet.shape.position = position
        bullet.shape.zRotation = directionAngle
        bullet.shape.zPosition = -1
        
        addChild(bullet.shape)
    }
    
    private func isTouchInRange(touch: UITouch, frame: CGRect) -> Bool {
        let location = touch.location(in: self)
        if frame.contains(location) {
            return true
        } else {
            return false
        }
    }
    
    private func checkVirtualControllerOp(touch: UITouch) {
        if self.isTouchInRange(touch: touch, frame: plateTouchEndRange1.frame) {
            if self.isTouchInRange(touch: touch, frame: plateAllowedRange1.frame) {
                if let rotateHandler = self.rotateJoystickAndPlayerHandler1 {
                    let location = touch.location(in: self)
                    rotateHandler(location)
                }
            } else {
                if let endHandler = self.endJoystickMoveHandler1 {
                    endHandler()
                }
            }
        } else if self.isTouchInRange(touch: touch, frame: plateTouchEndRange2.frame) {
            if self.isTouchInRange(touch: touch, frame: plateAllowedRange2.frame) {
                if let rotateHandler = self.rotateJoystickAndPlayerHandler2 {
                    let location = touch.location(in: self)
                    rotateHandler(location)
                }
            } else {
                if let endHandler = self.endJoystickMoveHandler2 {
                    endHandler()
                }
            }
        } else if self.isTouchInRange(touch: touch, frame: fireButton1.shape.frame) {
            fireButton1.fireButtonPressed()
        } else if self.isTouchInRange(touch: touch, frame: fireButton2.shape.frame) {
            fireButton2.fireButtonPressed()
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
            if self.isTouchInRange(touch: touch, frame: plateAllowedRange1.frame) {
                if let endHandler = self.endJoystickMoveHandler1 {
                    endHandler()
                }
            } else if self.isTouchInRange(touch: touch, frame:  fireButton1.shape.frame) {
                self.fireButton1.shape.alpha = 0.8
                if let shootHandler = self.fireHandler1 {
                    shootHandler()
                }
                fireButton1.fireButtonReleased()
            } else if self.isTouchInRange(touch: touch, frame: plateAllowedRange2.frame) {
                if let endHandler = self.endJoystickMoveHandler2 {
                    endHandler()
                }
            } else if self.isTouchInRange(touch: touch, frame:  fireButton2.shape.frame) {
                self.fireButton2.shape.alpha = 0.8
                if let shootHandler = self.fireHandler2 {
                    shootHandler()
                }
                fireButton2.fireButtonReleased()
            } else if self.isTouchInRange(touch: touch, frame: buttonBackToHomepage.frame) {
                self.viewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if self.prevTime == nil {
            self.prevTime = currentTime
        } else {
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
            
            self.prevTime = currentTime
        }
    }
}
