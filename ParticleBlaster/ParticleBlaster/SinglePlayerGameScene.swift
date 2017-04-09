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
    
    private let buttonBackToHomepage = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 100, height: 30), cornerRadius: 10)
    
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
        backgroundColor = Constants.backgroundColor
        player.shape.size = CGSize(width: Constants.playerWidth, height: Constants.playerHeight)
        player.shape.position = CGPoint(x: Constants.playerCenterX, y: Constants.playerCenterY)
        addChild(player.shape)
        
        joystickPlate.shape.position = CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY)
        joystickPlate.shape.size = CGSize(width: Constants.joystickPlateWidth, height: Constants.joystickPlateHeight)
        addChild(joystickPlate.shape)
        
        joystick.shape.size = CGSize(width: Constants.joystickPlateWidth / 2, height: Constants.joystickPlateHeight / 2)
        // Note: position is given as center position already
        joystick.shape.position = CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY)
        joystick.shape.alpha = 0.8
        joystick.updateJoystickPlateCenterPosition(x: joystickPlate.shape.position.x, y: joystickPlate.shape.position.y)
        addChild(joystick.shape)
        joystick.shape.zPosition = 2
        
        fireButton.shape.size = CGSize(width: Constants.fireButtonWidth, height: Constants.fireButtonHeight)
        fireButton.shape.position = CGPoint(x: Constants.fireButtonCenterX, y: Constants.fireButtonCenterY)
        fireButton.shape.alpha = 0.8
        addChild(fireButton.shape)
        
        // plateAllowedRange is to give a buffer area for joystick operation and should not be added as child
        plateAllowedRange = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 100)
        plateAllowedRange.position = CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY)
        plateTouchEndRange = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 100)
        plateTouchEndRange.position = CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY)
        
        // Set up back to homepage button
        buttonBackToHomepage.position = CGPoint(x: size.width * 0.03, y: size.height * 0.92)
        buttonBackToHomepage.fillColor = SKColor.clear
        buttonBackToHomepage.strokeColor = SKColor.black
        buttonBackToHomepage.lineWidth = Constants.strokeSmall
        //        buttonBackToHomepage.zPosition = zPositionCounter
        //        zPositionCounter += 1
        
        let buttonText = SKLabelNode(text: "Back to Home")
        buttonText.fontSize = Constants.fontSizeSmall
        buttonText.fontName = Constants.titleFont
        buttonText.position = CGPoint(x: buttonBackToHomepage.frame.size.width * 0.5, y: buttonBackToHomepage.frame.size.height * 0.25)
        buttonText.fontColor = SKColor.black
        //        buttonText.zPosition = zPositionCounter
        //        zPositionCounter += 1
        
        buttonBackToHomepage.addChild(buttonText)
        
        addChild(buttonBackToHomepage)
        
        // Set up the physics world to have no gravity
        physicsWorld.gravity = CGVector.zero
        // Set the scene as the delegate to be notified when two physics bodies collide.
        //physicsWorld.contactDelegate = self
        if let controller = self.viewController {
            //physicsWorld.contactDelegate = controller as! SKPhysicsContactDelegate?
            physicsWorld.contactDelegate = controller as SKPhysicsContactDelegate
        }
        
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
    
    private func checkJoystickOp(touch: UITouch) {
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
            if self.checkTouchRange(touch: touch, frame: plateAllowedRange.frame) {
                if let endHandler = self.endJoystickMoveHandlers.first {
                    endHandler()
                }
            } else if self.checkTouchRange(touch: touch, frame: fireButton.shape.frame) {
                // Play the sound of shooting
                run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
                self.fireButton.shape.alpha = 0.8
//                if let shootHandler = self.fireHandlers.first {
//                    shootHandler()
//                }
//                if let launchMissileHandler = self.launchMissileHandlers.first {
//                    launchMissileHandler()
//                }
                if let currThrowGrenadeHandler = self.throwGrenadeHandlers.first {
                    currThrowGrenadeHandler()
                }
            } else if self.checkTouchRange(touch: touch, frame: buttonBackToHomepage.frame) {
                self.viewController?.dismiss(animated: true, completion: nil)
            }
            // TODO: implement here for more weapon firing options
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // TODO: if not using the concept of elapsed time then delete self.prevTime
        if self.prevTime == nil {
            self.prevTime = currentTime
        } else {
            // new logic goes here
            if let playerVelocityHandler = self.playerVelocityUpdateHandlers.first {
                playerVelocityHandler()
            }
//            if let obstacleVelocityHandler = self.obstacleVelocityUpdateHandler {
//                obstacleVelocityHandler()
//            }
            if let missileVelocityHandler = self.updateMissileVelocityHandlers.first {
                missileVelocityHandler()
            }

            self.prevTime = currentTime
        }
    }
}
