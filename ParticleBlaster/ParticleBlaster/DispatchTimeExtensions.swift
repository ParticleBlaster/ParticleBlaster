//
//  DispatchTimeExtensions.swift
//  ParticleBlaster
//
//  Created by Richthofen on 07/04/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation

extension DispatchTime {
    func getTimeInSecond(to: DispatchTime) -> Float{
        return abs(Float(to.uptimeNanoseconds - self.uptimeNanoseconds) / 1_000_000_000)
    }
}
