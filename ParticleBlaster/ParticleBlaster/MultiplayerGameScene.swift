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
    
    private let buttonBackToHomepage = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 100, height: 30), cornerRadius: 10)
    
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
        backgroundColor = Constants.backgroundColor
        loadGameLevel()
        
        player1.shape.size = CGSize(width: Constants.playerWidth, height: Constants.playerHeight)
        player1.shape.position = CGPoint(x: MultiplayerViewParams.playerCenterX1, y: MultiplayerViewParams.playerCenterY1)
        addChild(player1.shape)
        
        player2.shape.size = CGSize(width: Constants.playerWidth, height: Constants.playerHeight)
        player2.shape.position = CGPoint(x: MultiplayerViewParams.playerCenterX2, y: MultiplayerViewParams.playerCenterY2)
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
        
        joystickPlate1.shape.size = CGSize(width: Constants.joystickPlateWidth, height: Constants.joystickPlateHeight)
        joystickPlate1.shape.position = CGPoint(x: MultiplayerViewParams.joystickPlateCenterX1, y: MultiplayerViewParams.joystickPlateCenterY1)
        addChild(joystickPlate1.shape)
        
        joystick1.shape.size = CGSize(width: Constants.joystickPlateWidth / 2, height: Constants.joystickPlateHeight / 2)
        joystick1.shape.position = CGPoint(x: MultiplayerViewParams.joystickPlateCenterX1, y: MultiplayerViewParams.joystickPlateCenterY1)
        joystick1.shape.alpha = 0.8
        joystick1.updateJoystickPlateCenterPosition(x: joystickPlate1.shape.position.x, y: joystickPlate1.shape.position.y)
        addChild(joystick1.shape)
        joystick1.shape.zPosition = 2
        
        fireButton1.shape.size = CGSize(width: Constants.fireButtonWidth, height: Constants.fireButtonHeight)
        fireButton1.shape.position = CGPoint(x: MultiplayerViewParams.fireButtonCenterX1, y: MultiplayerViewParams.fireButtonCenterY1)
        fireButton1.shape.alpha = 0.8
        addChild( fireButton1.shape)
        
        // plateAllowedRange is to give a buffer area for joystick operation and should not be added as child
        plateAllowedRange1 = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 50)
        plateAllowedRange1.position = CGPoint(x: MultiplayerViewParams.joystickPlateCenterX1, y: MultiplayerViewParams.joystickPlateCenterY1)
        plateTouchEndRange1 = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 100)
        plateTouchEndRange1.position = CGPoint(x: MultiplayerViewParams.joystickPlateCenterX1, y: MultiplayerViewParams.joystickPlateCenterY1)
        
        // joystick 2
        
        joystickPlate2.shape.size = CGSize(width: Constants.joystickPlateWidth, height: Constants.joystickPlateHeight)
        joystickPlate2.shape.position = CGPoint(x: MultiplayerViewParams.joystickPlateCenterX2, y: MultiplayerViewParams.joystickPlateCenterY2)
        addChild(joystickPlate2.shape)
        
        joystick2.shape.size = CGSize(width: Constants.joystickPlateWidth / 2, height: Constants.joystickPlateHeight / 2)
        joystick2.shape.position = CGPoint(x: MultiplayerViewParams.joystickPlateCenterX2, y: MultiplayerViewParams.joystickPlateCenterY2)
        joystick2.shape.alpha = 0.8
        joystick2.updateJoystickPlateCenterPosition(x: joystickPlate2.shape.position.x, y: joystickPlate2.shape.position.y)
        addChild(joystick2.shape)
        joystick2.shape.zPosition = 2
        
        fireButton2.shape.size = CGSize(width: Constants.fireButtonWidth, height: Constants.fireButtonHeight)
        fireButton2.shape.position = CGPoint(x: MultiplayerViewParams.fireButtonCenterX2, y: MultiplayerViewParams.fireButtonCenterY2)
        fireButton2.shape.alpha = 0.8
        addChild(fireButton2.shape)
        
        // plateAllowedRange is to give a buffer area for joystick operation and should not be added as child
        plateAllowedRange2 = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 50)
        plateAllowedRange2.position = CGPoint(x: MultiplayerViewParams.joystickPlateCenterX2, y: MultiplayerViewParams.joystickPlateCenterY2)
        plateTouchEndRange2 = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 200)
        plateTouchEndRange2.position = CGPoint(x: MultiplayerViewParams.joystickPlateCenterX2, y: MultiplayerViewParams.joystickPlateCenterY2)
    }
    
//    override func didMove(to view: SKView) {
//        backgroundColor = Constants.backgroundColor
//        
//        player1.shape.size = CGSize(width: Constants.playerWidth, height: Constants.playerHeight)
//        player1.shape.position = CGPoint(x: MultiplayerViewParams.playerCenterX1, y: MultiplayerViewParams.playerCenterY1)
//        addChild(player1.shape)
//        
//        joystickPlate1.shape.size = CGSize(width: Constants.joystickPlateWidth, height: Constants.joystickPlateHeight)
//        joystickPlate1.shape.position = CGPoint(x: MultiplayerViewParams.joystickPlateCenterX1, y: MultiplayerViewParams.joystickPlateCenterY1)
//        addChild(joystickPlate1.shape)
//        
//        joystick1.shape.size = CGSize(width: Constants.joystickPlateWidth / 2, height: Constants.joystickPlateHeight / 2)
//        joystick1.shape.position = CGPoint(x: MultiplayerViewParams.joystickPlateCenterX1, y: MultiplayerViewParams.joystickPlateCenterY1)
//        joystick1.shape.alpha = 0.8
//        joystick1.updateJoystickPlateCenterPosition(x: joystickPlate1.shape.position.x, y: joystickPlate1.shape.position.y)
//        addChild(joystick1.shape)
//        joystick1.shape.zPosition = 2
//        
//        fireButton1.shape.size = CGSize(width: Constants.fireButtonWidth, height: Constants.fireButtonHeight)
//        fireButton1.shape.position = CGPoint(x: MultiplayerViewParams.fireButtonCenterX1, y: MultiplayerViewParams.fireButtonCenterY1)
//        fireButton1.shape.alpha = 0.8
//        addChild( fireButton1.shape)
//        
//        // plateAllowedRange is to give a buffer area for joystick operation and should not be added as child
//        plateAllowedRange1 = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 50)
//        plateAllowedRange1.position = CGPoint(x: MultiplayerViewParams.joystickPlateCenterX1, y: MultiplayerViewParams.joystickPlateCenterY1)
//        plateTouchEndRange1 = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 100)
//        plateTouchEndRange1.position = CGPoint(x: MultiplayerViewParams.joystickPlateCenterX1, y: MultiplayerViewParams.joystickPlateCenterY1)
//        
//        player2.shape.size = CGSize(width: Constants.playerWidth, height: Constants.playerHeight)
//        player2.shape.position = CGPoint(x: MultiplayerViewParams.playerCenterX2, y: MultiplayerViewParams.playerCenterY2)
//        addChild(player2.shape)
//        
//        joystickPlate2.shape.size = CGSize(width: Constants.joystickPlateWidth, height: Constants.joystickPlateHeight)
//        joystickPlate2.shape.position = CGPoint(x: MultiplayerViewParams.joystickPlateCenterX2, y: MultiplayerViewParams.joystickPlateCenterY2)
//        addChild(joystickPlate2.shape)
//        
//        joystick2.shape.size = CGSize(width: Constants.joystickPlateWidth / 2, height: Constants.joystickPlateHeight / 2)
//        joystick2.shape.position = CGPoint(x: MultiplayerViewParams.joystickPlateCenterX2, y: MultiplayerViewParams.joystickPlateCenterY2)
//        joystick2.shape.alpha = 0.8
//        joystick2.updateJoystickPlateCenterPosition(x: joystickPlate2.shape.position.x, y: joystickPlate2.shape.position.y)
//        addChild(joystick2.shape)
//        joystick2.shape.zPosition = 2
//        
//        fireButton2.shape.size = CGSize(width: Constants.fireButtonWidth, height: Constants.fireButtonHeight)
//        fireButton2.shape.position = CGPoint(x: MultiplayerViewParams.fireButtonCenterX2, y: MultiplayerViewParams.fireButtonCenterY2)
//        fireButton2.shape.alpha = 0.8
//        addChild(fireButton2.shape)
//        
//        // plateAllowedRange is to give a buffer area for joystick operation and should not be added as child
//        plateAllowedRange2 = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 50)
//        plateAllowedRange2.position = CGPoint(x: MultiplayerViewParams.joystickPlateCenterX2, y: MultiplayerViewParams.joystickPlateCenterY2)
//        plateTouchEndRange2 = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 200)
//        plateTouchEndRange2.position = CGPoint(x: MultiplayerViewParams.joystickPlateCenterX2, y: MultiplayerViewParams.joystickPlateCenterY2)
//        
//        // Set up back to homepage button
//        buttonBackToHomepage.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
//        buttonBackToHomepage.fillColor = SKColor.clear
//        buttonBackToHomepage.strokeColor = SKColor.black
//        buttonBackToHomepage.lineWidth = Constants.strokeSmall
//        //        buttonBackToHomepage.zPosition = zPositionCounter
//        //        zPositionCounter += 1
//        
//        let buttonText = SKLabelNode(text: "Back to Home")
//        buttonText.fontSize = Constants.fontSizeSmall
//        buttonText.fontName = Constants.titleFont
//        buttonText.position = CGPoint(x: buttonBackToHomepage.frame.size.width * 0.5, y: buttonBackToHomepage.frame.size.height * 0.25)
//        buttonText.fontColor = SKColor.black
//        //        buttonText.zPosition = zPositionCounter
//        //        zPositionCounter += 1
//        
//        buttonBackToHomepage.addChild(buttonText)
//        
//        addChild(buttonBackToHomepage)
//        
//        // Set up the physics world to have no gravity
//        physicsWorld.gravity = CGVector.zero
//        // Set the scene as the delegate to be notified when two physics bodies collide.
//        if let controller = self.viewController {
//            physicsWorld.contactDelegate = controller as SKPhysicsContactDelegate
//        }
//        
////        // Play and loop the background music
////        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
////        backgroundMusic.autoplayLooped = true
////        addChild(backgroundMusic)
//    }
    
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
    
    private func checkJoystickOp(touch: UITouch) {
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
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.checkJoystickOp(touch: t)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.checkJoystickOp(touch: t)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if self.isTouchInRange(touch: touch, frame: plateAllowedRange1.frame) {
                if let endHandler = self.endJoystickMoveHandler1 {
                    endHandler()
                }
            } else if self.isTouchInRange(touch: touch, frame:  fireButton1.shape.frame) {
                // Play the sound of shooting
                run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
                self.fireButton1.shape.alpha = 0.8
                if let shootHandler = self.fireHandler1 {
                    shootHandler()
                }
            } else if self.isTouchInRange(touch: touch, frame: plateAllowedRange2.frame) {
                if let endHandler = self.endJoystickMoveHandler2 {
                    endHandler()
                }
            } else if self.isTouchInRange(touch: touch, frame:  fireButton2.shape.frame) {
                // Play the sound of shooting
                run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
                self.fireButton2.shape.alpha = 0.8
                if let shootHandler = self.fireHandler2 {
                    shootHandler()
                }
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
            
            if let playerPositionHandler2 = self.playerVelocityUpdateHandler2 {
                playerPositionHandler2()
            }
            
            self.prevTime = currentTime
        }
    }
    
    func setupPhysicsWorld() {
        // Set up the physics world to have no gravity
        physicsWorld.gravity = CGVector.zero
        // Set the scene as the delegate to be notified when two physics bodies collide.
        if let controller = self.viewController {
            physicsWorld.contactDelegate = controller as SKPhysicsContactDelegate
        }
    }
}
