//
//  MFiControllerConfig.swift
//  ParticleBlaster
//
//  Created by Richthofen on 07/04/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/*
 *  The `MFiControllerConfig` is a strcut configuring all the MFiController objects in the is App
 *  It contains an array of MFiController objects for the entire App and provides a function for setting up the next available one
 *      - It specifies the maximum number of the MFi Bluetooth hardware that can be initialized
 *      - It prvides a computable variable returning the index of the next available MFiController
 *
 *  The representation invariants:
 *      - The size of the MFiController array should match the maxMFi
 */

struct MFiControllerConfig {
    static var mfis = [MFiController]()
    static let maxMFi = 2
    
    private static let invalidMFiIndex = -1
    
    /* Start of computable variables */
    // This vairable returns the index of the next available MFiController object in the mfis array
    static var nextMFiConnect: Int {
        _checkRep()
        
        for index in 0 ..< mfis.count {
            if mfis[index].isConnected == false {
                return index
            }
        }
        return invalidMFiIndex
    }
    /* End of computable variables */
    
    /* Start of static functions */
    // This function sets up the connection notification center of the specified MfiController object
    static func startNextMFiConnectionNotificationCenter() {
        _checkRep()
        
        guard nextMFiConnect >= 0 else {
            return
        }
        mfis[nextMFiConnect].setupConnectionNotificationCenter()
        
        _checkRep()
    }
    /* End of static functions */
    
    // A valid Obstacle should be a non-static game object with timeToLive value >= 0
    private static func _checkRep() {
        assert(MFiControllerConfig.mfis.count == MFiControllerConfig.maxMFi, "The size of the mfis does NOT match the maxMFi!")
    }
    /* End of physics body setup and update functions */
}
