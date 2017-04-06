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
    //var spriteSheet: SKTexture
    
    //init(texture: )
    static func obtainSpriteNodeList(textureName: String, rows: Int, cols: Int) -> [SKSpriteNode] {
        let texture = SKTexture(imageNamed: "explosion")
        let frameWidth = texture.size().width / CGFloat(cols)
        let frameHeight = texture.size().height / CGFloat(rows)
        //let frameSize = CGSize(width: frameWidth, height: frameHeight)
        var resultSpriteNodeList = [SKSpriteNode]()
        
        for rowIndex in 0..<rows {
            for colIndex in 0..<cols {
                var textureRect = CGRect(x: CGFloat(colIndex) * frameWidth, y: CGFloat(rowIndex) * frameHeight, width: frameWidth, height: frameHeight)
                
                textureRect = CGRect(x: textureRect.origin.x / texture.size().width, y: textureRect.origin.y / texture.size().height, width: textureRect.size.width / texture.size().width, height: textureRect.size.height / texture.size().height)
                let currTexture = SKTexture(rect: textureRect, in: texture)
                let currNode = SKSpriteNode(texture: currTexture)
                resultSpriteNodeList.append(currNode)
            }
        }
        
        return resultSpriteNodeList
    }
}
