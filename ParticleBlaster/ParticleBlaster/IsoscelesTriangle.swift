//
//  Object.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 12/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/**
 *  The `Object` class defines the game objects that
 */

import Foundation
import SpriteKit
import UIKit

class IsoscelesTriangle: SKShapeNode {
    private let base: CGFloat
    private let height: CGFloat
    private let color: UIColor
    
    init(base: CGFloat, height: CGFloat, color: UIColor) {
        self.base = base
        self.height = height
        self.color = color
        
        super.init()
        
        let p1 = CGPoint(x: 0.0, y: 0.0)
        let p2 = CGPoint(x: base, y: 0.0)
        let p3 = CGPoint(x: base / 2.0, y: height)
        let path = UIBezierPath()
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        path.addLine(to: p1)
        
        self.path = path.cgPath
        self.fillColor = color
        self.strokeColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
