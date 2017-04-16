//
//  MFiController.swift
//  ParticleBlaster
//
//  Created by Richthofen on 28/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/*
 *  The `MFiController` class is the controller class for MFi Bluetooth joysticks
 *  It contains the connection related attributes and also includes the handler functions
 *      - It specifies the what handler function will be triggered when pressing each button
 *      - It specifies how the connection is established and terminated.
 */

import UIKit
import GameController

class MFiController: NSObject {
    /* Start of class attributes definition */
    // Only when pairing with a hardware it will be initialized, otherwise it remains nil
    var mainController: GCController?
    // For translating the joystick direction input
    var direction = CGVector(dx: 0, dy: 0)
    var isConnected: Bool = false
    var isGamePaused: Bool = false
    // The handler function for moving
    var moveHandler: ((CGVector) -> ())?
    // The handler function for stopping
    var endMoveHandler: (() -> ())?
    // The handler function for shooting
    var shootHandler: (() -> ())?
    // The handler function for pausing
    var pauseHandler: (() -> ())?
    // The handler function for resuming
    var resumeHandler: (() -> ())?
    // For tracking the time elapsed for button press debouncing
    var inputTimestamp: DispatchTime = DispatchTime.now()
    /* End of class attributes definition */
    
    /* Start of connection related functions */
    // This function set up the notification center for connection / disconnection
    func setupConnectionNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(controllerWasConnected),
                                               name: NSNotification.Name.GCControllerDidConnect,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(controllerWasDisconnected),
                                               name: NSNotification.Name.GCControllerDidDisconnect,
                                               object: nil)
    }
    
    // This function specifies the configuration details after the hardware connects to the iPad
    @objc func controllerWasConnected(_ notification: Notification) {
        guard self.isConnected == false else {
            return
        }
        
        let controller: GCController = notification.object as! GCController
        mainController = controller
        isConnected = true
        MFiControllerConfig.startNextMFiConnectionNotificationCenter()
        reactToInput()
    }
    
    // This function specifies the configuration details after the hardware disconnects from the iPad
    @objc func controllerWasDisconnected(_ notification: Notification) {
        mainController = nil
        isConnected = false
    }
    /* End of connection related functions */
    
    
    /* Start of private functions */
    // This function specifies the reaction for pressing different gamepad buttons
    private func reactToInput() {
        guard let profile: GCExtendedGamepad = self.mainController?.extendedGamepad else {
            return
        }
        
        self.mainController!.controllerPausedHandler = ({
            (controller: GCController) in
            
            if self.isGamePaused == true {
                if let doResume = self.resumeHandler {
                    doResume()
                }
            } else {
                if let doPause = self.pauseHandler {
                    doPause()
                }
            }
        })
        
        profile.valueChangedHandler = ({
            (gamepad: GCExtendedGamepad, element: GCControllerElement) in
            
            // A button
            if (gamepad.buttonA == element && gamepad.buttonA.isPressed && self.inputTimestamp.getTimeInSecond(to: DispatchTime.now()) > Constants.debouncingInteval) {
                if let shoot = self.shootHandler {
                    shoot()
                }
                self.inputTimestamp = DispatchTime.now()
            }
            
            // Left stick
            if (gamepad.leftThumbstick == element) {
                self.direction = CGVector(dx: CGFloat(gamepad.leftThumbstick.xAxis.value),
                                          dy: CGFloat(gamepad.leftThumbstick.yAxis.value))
                
                if gamepad.leftThumbstick.yAxis.value == 0 && gamepad.leftThumbstick.xAxis.value == 0 {
                    if let endMove = self.endMoveHandler {
                        endMove()
                    }
                } else {
                    if let move = self.moveHandler {
                        move(self.direction)
                    }
                }
            }
        }) as GCExtendedGamepadValueChangedHandler
    }
    /* End of private functions */
}



