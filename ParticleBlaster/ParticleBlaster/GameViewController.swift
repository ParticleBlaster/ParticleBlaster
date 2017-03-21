//
//  GameViewController.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 12/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    // Game Objects
    var player = Player(image: "Spaceship")
    var joystickPlate = JoystickPlate(image: "plate")
    var joystick = Joystick(image: "top")
    
    // Supporting Attributes
    private var xDestination: CGFloat = CGFloat(0)
    private var yDestination: CGFloat = CGFloat(0)
    private var unitOffset: CGVector = CGVector(dx: 0, dy: 1)
    //private let basicVelocity: CGFloat = CGFloat(400)
    private var flyingVelocity: CGFloat = CGFloat(0)
    private var flying: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startHomePageView()
    }
    
    func startHomePageView() {
        //let scene = HomePageScene(size: view.bounds.size)
        let scene = GameScene(size: view.bounds.size)
        Constants.initializeJoystickInfo(viewSize: view.bounds.size)
        scene.newPlayer = self.player
        scene.joystick = self.joystick
        scene.joystickPlate = self.joystickPlate
        scene.updatePlayerPositionHandler = self.movePlayerHandler
        scene.rotateJoystickAndPlayerHandler = self.moveJoystickAndRotatePlayerHandler
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Logic for GameScene goes here
    private func movePlayerHandler(elapsedTime: TimeInterval) {
        let currPos = self.player.shape.position
        let offset = CGVector(dx: self.flyingVelocity * self.unitOffset.dx * CGFloat(elapsedTime), dy: self.flyingVelocity * self.unitOffset.dy * CGFloat(elapsedTime))
        let finalPos = CGPoint(x: currPos.x + offset.dx, y: currPos.y + offset.dy)
        self.player.shape.run(SKAction.move(to: finalPos, duration: elapsedTime))
    }
    
    private func moveJoystickAndRotatePlayerHandler(touchLocation: CGPoint) {
        self.flying = true
        //let location = touch.location(in: self)
        let direction = CGVector(dx: touchLocation.x - Constants.joystickPlateCenterX, dy: touchLocation.y - Constants.joystickPlateCenterY)
        let length = sqrt(direction.dx * direction.dx + direction.dy * direction.dy)
        let directionVector = CGVector(dx: direction.dx / length, dy: direction.dy / length)
        self.unitOffset = directionVector
        let rotationAngle = atan2(directionVector.dy, directionVector.dx) - CGFloat.pi / 2
        var radius = Constants.joystickPlateWidth / 2
        self.flyingVelocity = length >= radius ? Constants.playerVelocity : Constants.playerVelocity * (length / radius)
        if length < radius {
            radius = length
        }
        
        let newJoystickPosition = CGPoint(x: Constants.joystickPlateCenterX + directionVector.dx * radius, y: Constants.joystickPlateCenterY + directionVector.dy * radius)
        self.joystick.updatePosition(newLoation: newJoystickPosition)
        //joystick.position = CGPoint(x: Constants.joystickPlateCenterX + directionVector.dx * radius, y: Constants.joystickPlateCenterY + directionVector.dy * radius)
        //player.zRotation = rotationAngle
        self.player.updateRotation(newAngle: rotationAngle)
    }
    
    private func endJoystickMoveHandler() {
        self.flyingVelocity = CGFloat(0)
        if self.flying {
            self.flying = false
            self.joystick.shape.run(SKAction.move(to: CGPoint(x: Constants.joystickPlateCenterX, y: Constants.joystickPlateCenterY), duration: 0.2))
            //        self.player.run(SKAction.rotate(toAngle: 0, duration: 0.2))
            //        self.unitOffset = CGVector(dx:0, dy: 1)
            
            //let endingDrift = CGVector(dx: self.unitOffset.dx * 10, dy: self.unitOffset.dy * 10)
            //self.player.run(SKAction.move(by: endingDrift, duration: 0.2))
            self.flyingVelocity = CGFloat(0)
        }
    }
}
