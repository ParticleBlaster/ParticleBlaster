//
//  FireButton.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 22/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/**
 *  The `FireButton` class defines the fire button to fire weapon
 *
 *  The representation invariants:
 *      - It should be a static game object
 */

import SpriteKit

class FireButton : GameObject {
    init(image: String) {
        super.init(imageName: image)
        _checkRep()
    }
    
    override init() {
        super.init(imageName: "fire")
        _checkRep()
    }
    
    required convenience init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeFireButton(position: CGPoint) {
        _checkRep()
        self.shape.size = CGSize(width: Constants.fireButtonWidth, height: Constants.fireButtonHeight)
        self.shape.position = position
        self.shape.alpha = Constants.fireButtonReleaseAlpha
        self.shape.zPosition = Constants.defaultFireButtonZPosition
        _checkRep()
    }
    
    func fireButtonPressed() {
        _checkRep()
        self.shape.alpha = Constants.fireButtonPressAlpha
        _checkRep()
    }
    
    func fireButtonReleased() {
        _checkRep()
        self.shape.alpha = Constants.fireButtonReleaseAlpha
        _checkRep()
    }
    
    // A valid FireButton should be a static game object
    private func _checkRep() {
        assert(self.isStatic == true, "Should be a static game object.")
    }
}
