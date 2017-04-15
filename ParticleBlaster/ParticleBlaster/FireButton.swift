//
//  FireButton.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 22/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class FireButton : GameObject {
    init(image: String) {
        super.init(imageName: image)
    }
    
    override init() {
        super.init(imageName: "fire")
    }
    
    required convenience init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeFireButton(position: CGPoint) {
        self.shape.size = CGSize(width: Constants.fireButtonWidth, height: Constants.fireButtonHeight)
        self.shape.position = position
        self.shape.alpha = Constants.fireButtonReleaseAlpha
        self.shape.zPosition = Constants.defaultFireButtonZPosition
    }
    
    func fireButtonPressed() {
        self.shape.alpha = Constants.fireButtonPressAlpha
    }
    
    func fireButtonReleased() {
        self.shape.alpha = Constants.fireButtonReleaseAlpha
    }
}
