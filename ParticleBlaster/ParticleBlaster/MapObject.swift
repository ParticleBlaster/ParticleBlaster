//
//  MapObject.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 25/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

class MapObject {
    var boundaries: [SKShapeNode]
    
    init(view: UIView) {
        boundaries = [SKShapeNode]()
        
        let originX = view.bounds.origin.x
        let originY = view.bounds.origin.y
        let limitX = view.bounds.origin.x + view.bounds.width
        let limitY = view.bounds.origin.y + view.bounds.height
        
        let leftPath = CGMutablePath()
        leftPath.move(to: CGPoint(x: originX, y: originY))
        leftPath.addLine(to: CGPoint(x: originX, y: limitY))
        let leftBoundary = SKShapeNode(path: leftPath)
        boundaries.append(leftBoundary)
        
        let rightPath = CGMutablePath()
        rightPath.move(to: CGPoint(x: limitX, y: originY))
        rightPath.addLine(to: CGPoint(x: limitX, y: limitY))
        let rightBoundary = SKShapeNode(path: rightPath)
        boundaries.append(rightBoundary)
        
        let topPath = CGMutablePath()
        topPath.move(to: CGPoint(x: originX, y: originY))
        topPath.addLine(to: CGPoint(x: limitX, y: originY))
        let topBoundary = SKShapeNode(path: topPath)
        boundaries.append(topBoundary)
        
        let bottomPath = CGMutablePath()
        bottomPath.move(to: CGPoint(x: originX, y: limitY))
        bottomPath.addLine(to: CGPoint(x: limitX, y: limitY))
        let bottomBoundary = SKShapeNode(path: bottomPath)
        boundaries.append(bottomBoundary)
    }
}
