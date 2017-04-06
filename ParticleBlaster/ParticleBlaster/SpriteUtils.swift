//
//  SpriteUtils.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 07/04/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

class SpriteUtils {
    
    static func obtainSpriteNodeList(textureName: String, rows: Int, cols: Int) -> [SKSpriteNode] {
        let texture = SKTexture(imageNamed: "explosion")
        let frameWidth = texture.size().width / CGFloat(cols)
        let frameHeight = texture.size().height / CGFloat(rows)
        var resultSpriteNodeList = [SKSpriteNode]()
        
        for rowIndex in 0..<rows {
            var rowList = [SKSpriteNode]()
            for colIndex in 0..<cols {
                var textureRect = CGRect(x: CGFloat(colIndex) * frameWidth, y: CGFloat(rowIndex) * frameHeight, width: frameWidth, height: frameHeight)
                
                textureRect = CGRect(x: textureRect.origin.x / texture.size().width, y: textureRect.origin.y / texture.size().height, width: textureRect.size.width / texture.size().width, height: textureRect.size.height / texture.size().height)
                let currTexture = SKTexture(rect: textureRect, in: texture)
                let currNode = SKSpriteNode(texture: currTexture)
                rowList.append(currNode)
            }
            resultSpriteNodeList = rowList + resultSpriteNodeList
        }
        
        return resultSpriteNodeList
    }
    
}
