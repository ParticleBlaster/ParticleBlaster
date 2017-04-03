//
//  MFiController.swift
//  ParticleBlaster
//
//  Created by Richthofen on 28/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import GameController

class MFiController: NSObject {
    var mainController: GCController?
//    var viewController: GameViewController?
    var direction = CGVector(dx: 0, dy: 0)
    var isConnected = false
    var moveHandler: ((CGVector) -> ())?
    var shootHandler: (() -> ())?
    
    
    func setupConnectionNotificationCenter() {
        print("start setupConnectionNotificationCenter")
        
//        guard gameViewController != nil else {
//            print("game view controller not yet setup")
//            return
//        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(controllerWasConnected),
                                               name: NSNotification.Name.GCControllerDidConnect,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(controllerWasDisconnected),
                                               name: NSNotification.Name.GCControllerDidDisconnect,
                                               object: nil)
        
//        NotificationCenter.default.addObserver(forName: NSNotification.Name.GCControllerDidConnect, object: nil, queue: nil) { (_ notification :Notification) in
//            
//            guard self.isConnected == false else {
//                return
//            }
//            
//            print("1234567")
//            
//            let controller: GCController = notification.object as! GCController
//            let status = "MFi Controller: \(String(describing: controller.vendorName)) is connected"
//            print(status)
//            
//            self.mainController = controller
//            self.isConnected = true
//            Constants.startNextMFiConnectionNotificationCenter()
//            self.reactToInput()
//        }
//        
//        NotificationCenter.default.addObserver(forName: NSNotification.Name.GCControllerDidDisconnect, object: nil, queue: nil) { (_ notification :Notification) in
//            
//            print("3456789")
//            
//            let controller: GCController = notification.object as! GCController
//            let status = "MFi Controller: \(String(describing: controller.vendorName)) is disconnected"
//            print(status)
//            
//            self.mainController = nil
//            self.isConnected = false
//        }
        
        print("done setupConnectionNotificationCenter")
    }
    
    private func reactToInput() {
        guard let profile: GCExtendedGamepad = self.mainController?.extendedGamepad else {
            return
        }
        
        profile.valueChangedHandler = ({
            (gamepad: GCExtendedGamepad, element: GCControllerElement) in
            
            var message: String = ""
            
            
            // A button
            if (gamepad.buttonA == element && gamepad.buttonA.isPressed) {
                message = "A Button"
                if let shoot = self.shootHandler {
                    shoot()
                }
            }
            
            
            // left stick
            if (gamepad.leftThumbstick == element) {
                if (gamepad.leftThumbstick.up.isPressed) {
                    message = "Left Stick %f \(gamepad.leftThumbstick.yAxis.value)"
                }
                if (gamepad.leftThumbstick.down.isPressed) {
                    message = "Left Stick %f \(gamepad.leftThumbstick.yAxis.value)"
                }
                if (gamepad.leftThumbstick.left.isPressed) {
                    message = "Left Stick %f \(gamepad.leftThumbstick.xAxis.value)"
                }
                if (gamepad.leftThumbstick.right.isPressed) {
                    message = "Left Stick %f \(gamepad.leftThumbstick.xAxis.value)"
                }
                self.direction = CGVector(dx: CGFloat(gamepad.leftThumbstick.xAxis.value),
                                          dy: CGFloat(gamepad.leftThumbstick.yAxis.value))
                
                if let move = self.moveHandler {
                    move(self.direction)
                }
            }
            
            print(message)
        }) as GCExtendedGamepadValueChangedHandler
    }
    
    @objc func controllerWasConnected(_ notification: Notification) {
        guard self.isConnected == false else {
            return
        }
        
        print("in controllerWasConnected")
        let controller: GCController = notification.object as! GCController
        let status = "MFi Controller: \(String(describing: controller.vendorName)) is connected"
        print(status)
        
        mainController = controller
        isConnected = true
        Constants.startNextMFiConnectionNotificationCenter()
        reactToInput()
    }
    
    @objc func controllerWasDisconnected(_ notification: Notification) {
        
        print("in controllerWasDisconnected")
        let controller: GCController = notification.object as! GCController
        let status = "MFi Controller: \(String(describing: controller.vendorName)) is disconnected"
        print(status)
        
        mainController = nil
        isConnected = false
    }
}



