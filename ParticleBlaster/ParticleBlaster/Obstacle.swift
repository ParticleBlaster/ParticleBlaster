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
        setupShape()
    }

    init() {
        self.initialPosition = CGPoint(x: Constants.obstacle1CenterX, y: Constants.obstacle1CenterY)
        super.init(imageName: "obs")
        setupShape()
    }

    init(userSetInitialPosition: CGPoint) {
        self.initialPosition = userSetInitialPosition
        super.init(imageName: "obs")
        setupShape()
    }
    
    init(userSetInitialPosition: CGPoint, isStatic: Bool) {
        self.initialPosition = userSetInitialPosition
        super.init(imageName: "obs", isStatic: isStatic)
        setupShape()
    }

    init(image: String, userSetInitialPosition: CGPoint) {
        self.imageName = image
        self.initialPosition = userSetInitialPosition
        super.init(imageName: image)
        setupShape()
    }
    
    init(image: String, userSetInitialPosition: CGPoint, isPhysicsBody: Bool) {
        self.imageName = image
        self.initialPosition = userSetInitialPosition
        super.init(imageName: image)
        if isPhysicsBody {
            setupShape()
        }
    }

    init(obstacle: Obstacle) {
        self.imageName = obstacle.imageName
        self.initialPosition = obstacle.initialPosition
        super.init(shape: obstacle.shape.copy() as! SKSpriteNode,
                   timeToLive: obstacle.timeToLive,
                   isStatic: obstacle.isStatic)
        self.shape.position = obstacle.shape.position
        self.shape.physicsBody = nil
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

    override func copy() -> Any {
        let copy = Obstacle(obstacle: self)
        return copy
    }
    
    private func setupShape() {
        let remainingLifePercentage = CGFloat(Float(self.timeToLive) / Float(Constants.defaultTimeToLive))
        let computedWidth = Constants.obstacleWidth * remainingLifePercentage
        let computedHeight = Constants.obstacleHeight * remainingLifePercentage
        self.shape.size = CGSize(width: computedWidth, height: computedHeight)
        setupPhysicsProperty()
    }

    func setupPhysicsProperty() {
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
}

// A simple class to help storing using NSCoding, as Obstacle class can not conform to NSCoding
class SimpleObstacle: NSObject, NSCoding {
    var imageName: String
    var position: CGPoint

    init(imageName: String?, position: CGPoint) {
        self.imageName = imageName ?? "obs"
        self.position = position
    }

    convenience init(obstacle: Obstacle) {
        self.init(imageName: obstacle.imageName, position: obstacle.initialPosition)
    }

    required convenience init?(coder decoder: NSCoder) {
        guard let imageName = decoder.decodeObject(forKey: Constants.imageNameKey) as? String else {
            return nil
        }
        let position = decoder.decodeCGPoint(forKey: Constants.initialPositionKey)
        self.init(imageName: imageName, position: position)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(imageName, forKey: Constants.imageNameKey)
        aCoder.encode(position, forKey: Constants.initialPositionKey)
    }
}
