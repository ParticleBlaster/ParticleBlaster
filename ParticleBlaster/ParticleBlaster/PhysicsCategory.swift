//
//  PhysicsCategory.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 12/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0x1 << 0       // 1
    static let Projectile: UInt32 = 0x1 << 1       // 2
    static let Player    : UInt32 = 0x1 << 2       // 3
}
