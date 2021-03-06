//
//  IconButton.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 23/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/**
 *  The `IconButton` defines a new type of button that has different button images
 *  according to its provided images assets and isPositive value value
 */

import SpriteKit

class IconButton: SKNode {
    private var positiveButton: SKSpriteNode
    private var negativeButton: SKSpriteNode? = nil
    // By setting the isPositive value, the background image will be toggled
    var isPositive: Bool {
        didSet {
            guard oldValue != isPositive else {
                return
            }
            self.toggleBackground()
        }
    }
    var isEnabled: Bool

    var onPressHandler: (() -> Void)?
    var size: CGSize {
        return positiveButton.size
    }

    init(imageNamed: String, disabledImageNamed: String?, isPositive: Bool = true, isEnabled: Bool = true) {
        self.positiveButton = SKSpriteNode(imageNamed: imageNamed)
        if let disabledImageNamed = disabledImageNamed {
            self.negativeButton = SKSpriteNode(imageNamed: disabledImageNamed)
        }
        self.isPositive = isPositive
        self.isEnabled = isEnabled
        super.init()
        setup()
    }

    init(imageNamed: String, disabledImageNamed: String?, size: CGSize, isPositive: Bool = true, isEnabled: Bool = true) {
        positiveButton = SKSpriteNode(texture: SKTexture(imageNamed: imageNamed), size: size)
        if let disabledImageNamed = disabledImageNamed {
            self.negativeButton = SKSpriteNode(texture: SKTexture(imageNamed: disabledImageNamed), size: size)
        }
        self.isPositive = isPositive
        self.isEnabled = isEnabled
        super.init()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        if isPositive {
            addChild(positiveButton)
        } else if let negativeButton = negativeButton {
            addChild(negativeButton)
        }
        self.isUserInteractionEnabled = true
    }

    /// Scale up the button when user touch the button
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled else {
            return
        }
        let scaleAction = SKAction.scale(to: 1.1, duration: 0.1)
        scaleAction.timingMode = .easeOut
        self.run(scaleAction)
        AudioUtils.pressButton(on: self)
    }

    /// Check if the touch ended and still inside the button then call the provided onPressHandler method
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled else {
            return
        }
        guard let touch = touches.first else {
            return
        }
        let scaleAction = SKAction.scale(to: 1, duration: 0.1)
        scaleAction.timingMode = .easeOut
        self.run(scaleAction) {
            if self.positiveButton.frame.contains(touch.location(in: self)) {
                self.onPress()
            }
        }
    }

    private func onPress() {
        if let onPressHandler = onPressHandler {
            onPressHandler()
        }
    }

    /// Toggle background of button between positive <-> negative
    private func toggleBackground() {
        guard let negativeButton = negativeButton else {
            return
        }
        if !isPositive {
            positiveButton.removeFromParent()
            addChild(negativeButton)
        } else {
            negativeButton.removeFromParent()
            addChild(positiveButton)
        }
    }
}
