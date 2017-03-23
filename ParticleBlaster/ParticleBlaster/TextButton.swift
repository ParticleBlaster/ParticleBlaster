//
//  TextButton.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 23/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

// TODO: support disable button
class TextButton: SKNode {
    private var positiveButton: SKSpriteNode
    private var label: SKLabelNode

    var onPressHandler: (() -> Void)?
    var size: CGSize {
        return positiveButton.size
    }

    init(imageNamed: String, text: String, fontSize: CGFloat = Constants.normalFontSize, size: CGSize = Constants.textButtonDefaultSize) {
        positiveButton = SKSpriteNode(texture: SKTexture(imageNamed: imageNamed), size: size)
        label = SKLabelNode(text: text)
        label.fontName = Constants.normalFont
        label.fontSize = fontSize
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.zPosition = 5
        super.init()
        addChild(positiveButton)
        addChild(label)
        self.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scaleAction = SKAction.scale(to: 1.25, duration: 0.1)
        scaleAction.timingMode = .easeOut
        self.run(scaleAction)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scaleAction = SKAction.scale(to: 1, duration: 0.1)
        scaleAction.timingMode = .easeOut
        self.run(scaleAction) {
            self.onPress()
        }
    }

    private func onPress() {
        if let onPressHandler = onPressHandler {
            onPressHandler()
        }
    }
}
