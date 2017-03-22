//
//  IconButton.swift
//  ParticleBlaster
//
//  Created by Bui Hiep on 23/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class IconButton: SKNode {
    private var positiveButton: SKSpriteNode
    private var negativeButton: SKSpriteNode? = nil
    private var isPositive = true

    var onPressHandler: (() -> Void)?

    init(imageNamed: String, disabledImageNamed: String? = nil) {
        self.positiveButton = SKSpriteNode(imageNamed: imageNamed)
        if let disabledImageNamed = disabledImageNamed {
            self.negativeButton = SKSpriteNode(imageNamed: disabledImageNamed)
        }
        super.init()
        addChild(positiveButton)
    }

    init(size: CGSize, imageNamed: String, disabledImageNamed: String? = nil) {
        positiveButton = SKSpriteNode(texture: SKTexture(imageNamed: imageNamed), size: size)
        if let disabledImageNamed = disabledImageNamed {
            self.negativeButton = SKSpriteNode(texture: SKTexture(imageNamed: disabledImageNamed), size: size)
        }
        super.init()
        addChild(positiveButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO: put some animation here
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO: put some animation here and call onPress on completion
        self.onPress()
    }

    private func onPress() {
        if let onPressHandler = onPressHandler {
            onPressHandler()
        }
    }

    /// Toggle background of button between positive <-> negative
    func toggle() {
        guard let negativeButton = negativeButton else {
            return
        }
        defer {
            isPositive = !isPositive
        }
        if isPositive {
            positiveButton.removeFromParent()
            addChild(negativeButton)
        } else {
            negativeButton.removeFromParent()
            addChild(positiveButton)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
