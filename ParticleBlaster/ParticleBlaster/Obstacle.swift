//
//  Obstacle.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 22/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class Obstacle : GameObject {
    var initialPosition: CGPoint
    // for support storage purpose
    var imageName: String?

    // TODO: refactor to merge all these init methods into one (except the last one)
    init(image: String = "obs") {
        self.imageName = image
        self.initialPosition = CGPoint(x: Constants.obstacle1CenterX, y: Constants.obstacle1CenterY)
        super.init(imageName: image)
        setupPhysicsProperty()
    }

    init() {
        self.initialPosition = CGPoint(x: Constants.obstacle1CenterX, y: Constants.obstacle1CenterY)
        super.init(imageName: "obs")
        setupPhysicsProperty()
    }

    init(userSetInitialPosition: CGPoint) {
        self.initialPosition = userSetInitialPosition
        super.init(imageName: "obs")
        setupPhysicsProperty()
    }
    
    init(userSetInitialPosition: CGPoint, isStatic: Bool) {
        self.initialPosition = userSetInitialPosition
        super.init(imageName: "obs", isStatic: isStatic)
        setupPhysicsProperty()
    }

    init(image: String, userSetInitialPosition: CGPoint) {
        self.initialPosition = userSetInitialPosition
        super.init(imageName: image)
        setupPhysicsProperty()
    }
    
    init(image: String, userSetInitialPosition: CGPoint, isPhysicsBody: Bool) {
        self.initialPosition = userSetInitialPosition
        super.init(imageName: image)
        if isPhysicsBody {
            setupPhysicsProperty()
        }
    }
    
    init(obstacle: Obstacle) {
        self.initialPosition = obstacle.initialPosition
        super.init(shape: obstacle.shape.copy() as! SKSpriteNode,
                   timeToLive: obstacle.timeToLive,
                   isStatic: obstacle.isStatic)
        setupPhysicsProperty()
    }
    
    init(obstacle: Obstacle, isPhysicsBody: Bool) {
        self.initialPosition = obstacle.initialPosition
        super.init(shape: obstacle.shape.copy() as! SKSpriteNode,
                   timeToLive: obstacle.timeToLive,
                   isStatic: obstacle.isStatic)
        if isPhysicsBody {
            setupPhysicsProperty()
        }
    }

    func hitByBullet() {
        self.timeToLive -= 1
        let remainingLifePercentage = CGFloat(self.timeToLive) / CGFloat(Constants.defaultTimeToLive)
        self.shape.size = CGSize(width: Constants.obstacleWidth * remainingLifePercentage, height: Constants.obstacleHeight * remainingLifePercentage)
    }

    func checkDestroyed() -> Bool {
        if self.timeToLive == 0 {
            return true
        } else {
            return false
        }
    }

//    override func copy() -> Any {
//        let copy = Obstacle(obstacle: self)
//        copy.shape.zPosition = self.shape.zPosition
//        return copy
//    }
    
    func copy() -> Obstacle {
        let copy = Obstacle(obstacle: self)
        return copy
    }
    
    func copyWithoutPhysicsBody() -> Obstacle {
        let copy = Obstacle(obstacle: self, isPhysicsBody: false)
        return copy
    }

    private func setupPhysicsProperty() {
        let remainingLifePercentage = CGFloat(Float(self.timeToLive) / Float(Constants.defaultTimeToLive))
        let computedWidth = Constants.obstacleWidth * remainingLifePercentage
        let computedHeight = Constants.obstacleHeight * remainingLifePercentage
        self.shape.size = CGSize(width: computedWidth, height: computedHeight)
        self.shape.physicsBody = SKPhysicsBody(rectangleOf: self.shape.size)
        self.shape.physicsBody?.isDynamic = true
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Obstacle | PhysicsCategory.Player | PhysicsCategory.Map
        if self.isStatic {
            self.shape.physicsBody?.collisionBitMask = PhysicsCategory.None
        } else {
            self.shape.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Obstacle | PhysicsCategory.Map
        }
        
    }

    required convenience init?(coder decoder: NSCoder) {
        guard let imageName = decoder.decodeObject(forKey: Constants.imageNameKey) as? String,
            let position = decoder.decodeObject(forKey: Constants.initialPositionKey) as? CGPoint else {
                return nil
        }
        self.init(image: imageName, userSetInitialPosition: position)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(imageName ?? "obs", forKey: Constants.imageNameKey)
        aCoder.encode(initialPosition, forKey: Constants.initialPositionKey)
    }

//     required convenience init?(coder decoder: NSCoder) {
//         guard let imageName = decoder.decodeObject(forKey: Constants.imageNameKey) as? String,
//             let position = decoder.decodeObject(forKey: Constants.initialPositionKey) as? CGPoint else {
//                 return nil
//         }
//         self.init(image: imageName, userSetInitialPosition: position)
//     }
//    
//     func encode(with aCoder: NSCoder) {
//         aCoder.encode(imageName ?? "obs", forKey: Constants.imageNameKey)
//         aCoder.encode(initialPosition, forKey: Constants.initialPositionKey)
//     }
}
