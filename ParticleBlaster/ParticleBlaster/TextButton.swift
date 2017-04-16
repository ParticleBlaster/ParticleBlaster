//
//  TextButton.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 23/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/**
 *  The `TextButton` defines a new type of button that 
 *      - Accepts a string to be displayed as the text in the button
 *      - Shows different button images according to the `isEnabled` value
 */

import SpriteKit

class TextButton: SKNode {
    private var positiveButton: SKSpriteNode
    private var negativeButton: SKSpriteNode? = nil
    private var label: SKLabelNode

    var onPressHandler: (() -> Void)?
    var isEnabled: Bool = true
    var size: CGSize {
        return positiveButton.size
    }
    var isPositive: Bool {
        didSet {
            guard oldValue != isPositive else {
                return
            }
            self.toggleBackground()
        }
    }

    init(imageNamed: String, text: String, fontSize: CGFloat = Constants.normalFontSize, size: CGSize = Constants.textButtonDefaultSize) {
        positiveButton = SKSpriteNode(texture: SKTexture(imageNamed: imageNamed), size: size)
        label = SKLabelNode(text: text)
        label.fontName = Constants.normalFont
        label.fontSize = fontSize
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.zPosition = 5
        isPositive = true
        super.init()
        addChild(positiveButton)
        addChild(label)
        self.isUserInteractionEnabled = true
    }
    
    init(imageNamed: String, disabledImageNamed: String?, text: String, fontSize: CGFloat = Constants.normalFontSize, size: CGSize = Constants.textButtonDefaultSize) {
        positiveButton = SKSpriteNode(texture: SKTexture(imageNamed: imageNamed), size: size)
        if let disabledImageNamed = disabledImageNamed {
            self.negativeButton = SKSpriteNode(texture: SKTexture(imageNamed: disabledImageNamed), size: size)
        }
        label = SKLabelNode(text: text)
        label.fontName = Constants.normalFont
        label.fontSize = fontSize
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.zPosition = 5
        isPositive = true
        super.init()
        addChild(positiveButton)
        addChild(label)
        self.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled else {
            return
        }
        let scaleAction = SKAction.scale(to: 1.1, duration: 0.1)
        scaleAction.timingMode = .easeOut
        self.run(scaleAction)
        AudioUtils.pressButton(on: self)
    }

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
