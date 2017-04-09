//
//  MFiControllerConfig.swift
//  ParticleBlaster
//
//  Created by Richthofen on 07/04/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation

struct MFiControllerConfig {
    static var mfis = [MFiController]()
    static let maxMFi = 2
    
    static var nextMFiConnect: Int {
        for index in 0 ..< mfis.count {
            if mfis[index].isConnected == false {
                return index
            }
        }
        return -1
    }
    
    static func startNextMFiConnectionNotificationCenter() {
        guard nextMFiConnect >= 0 else {
            return
        }
        mfis[nextMFiConnect].setupConnectionNotificationCenter()
    }
}
