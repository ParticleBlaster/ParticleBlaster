//
//  File.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 11/4/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit

extension CGSize {
    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
}
