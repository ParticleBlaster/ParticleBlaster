//
//  GameScene.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 12/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var monstersDestroyed = 0
    private let monstersDestroyRequirement = 10

    private var plateAllowedRange: SKShapeNode!
    private var plateTouchEndRange: SKShapeNode!
    private var plateAllowedRangeDistance: CGFloat!
    private var prevTime: TimeInterval?
    
    var viewController: UIViewController!
    var player: Player!
    var joystickPlate: JoystickPlate!
    var joystick: Joystick!
    var fireButton: FireButton!
    var rotateJoystickAndPlayerHandler: ((CGPoint) -> ())?
    var endJoystickMoveHandler: (() -> ())?
    var playerVelocityUpdateHandler: (() -> ())?
    
    var obstacleHitHandler: (() -> ())?
    var obstacleMoveHandler: (() -> ())?
    var obstacleVelocityUpdateHandler: (() -> ())?
    var fireHandler: (() -> ())?
    
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
        addChild(joystick.shape)
        joystick.shape.zPosition = 2
        
        fireButton.shape.size = CGSize(width: Constants.fireButtonWidth, height: Constants.fireButtonHeight)
        fireButton.shape.position = CGPoint(x: Constants.fireButtonCenterX, y: Constants.fireButtonCenterY)
        fireButton.shape.alpha = 0.8
        addChild(fireButton.shape)
        
        // plateAllowedRange is to give a buffer area for joystick operation and should not be added as child
        plateAllowedRange = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 50)
        plateAllowedRange.position = CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY)
        plateTouchEndRange = SKShapeNode(circleOfRadius: Constants.joystickPlateWidth / 2 + 100)
        plateTouchEndRange.position = CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY)
        
        // Set up the physics world to have no gravity
        physicsWorld.gravity = CGVector.zero
        // Set the scene as the delegate to be notified when two physics bodies collide.
        //physicsWorld.contactDelegate = self
        if let controller = self.viewController {
            //physicsWorld.contactDelegate = controller as! SKPhysicsContactDelegate?
            physicsWorld.contactDelegate = controller as? SKPhysicsContactDelegate
        }
        
        // Play and loop the background music
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
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
    
    // Possible implementation: displays a sequence of skspritenode showing the explosion
    func displayBulletHitAnimation() {
        
    }
    
    func displayObstacleImpulseAnimation() {
        
    }
    
    func removeElement(node: SKSpriteNode) {
        node.removeFromParent()
    }
    
    func addSingleObstacle(newObstacle: Obstacle) {
        // obstacle's size has been set previously
        // TODO: think about whether to put the position and size setting for spritenodes
        newObstacle.shape.position = newObstacle.initialPosition
        addChild(newObstacle.shape)
    }
    
    func addBoundary(boundary: SKShapeNode) {
        addChild(boundary)
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
                if let rotateHandler = self.rotateJoystickAndPlayerHandler {
                    let location = touch.location(in: self)
                    rotateHandler(location)
                }
            } else {
                if let endHandler = self.endJoystickMoveHandler {
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
                if let endHandler = self.endJoystickMoveHandler {
                    endHandler()
                }
            } else if self.checkTouchRange(touch: touch, frame: fireButton.shape.frame) {
                // Play the sound of shooting
                run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
                self.fireButton.shape.alpha = 0.8
                if let shootHandler = self.fireHandler {
                    shootHandler()
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // TODO: if not using the concept of elapsed time then delete self.prevTime
        if self.prevTime == nil {
            self.prevTime = currentTime
        } else {
            // new logic goes here
            if let playerVelocityHandler = self.playerVelocityUpdateHandler {
                playerVelocityHandler()
            }
            if let obstacleVelocityHandler = self.obstacleVelocityUpdateHandler {
                obstacleVelocityHandler()
            }

            self.prevTime = currentTime
        }
    }
}
