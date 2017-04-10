//
//  Obstacle.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 22/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import SpriteKit

class Obstacle : GameObject {
    // This position is archived as ratio position, and need to convert to absolute value when displaying
    var initialPosition: CGPoint
    // for support storage purpose
    var imageName: String = "obs"
    
    private var remainingLifePercentage: CGFloat {
        get {
            return CGFloat(self.timeToLive) / CGFloat(Constants.defaultTimeToLive)
        }
    }

    // TODO: refactor to merge all these init methods into one (except the last one)
    init(image: String = "obs") {
        self.imageName = image
        self.initialPosition = CGPoint(x: Constants.obstacle1CenterX, y: Constants.obstacle1CenterY)
        super.init(imageName: image)
        setupShape()
    }

    init(userSetInitialPosition: CGPoint?, isStatic: Bool = false) {
        self.initialPosition = userSetInitialPosition ?? CGPoint(x: Constants.obstacle1CenterX, y: Constants.obstacle1CenterY)
        super.init(imageName: imageName, isStatic: isStatic)
        setupShape()
    }

    init(image: String, userSetInitialPosition: CGPoint) {
        self.imageName = image
        self.initialPosition = userSetInitialPosition
        super.init(imageName: image)
        setupShape()
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
        let decreasePersentage = CGFloat(0.95)
        self.shape.size = CGSize(width: self.shape.size.width * decreasePersentage, height: self.shape.size.height * decreasePersentage)
        self.resetPhysicsBodySize()
    }

    func checkDestroyed() -> Bool {
        if self.timeToLive <= 0 {
            return true
        } else {
            return false
        }
    }

    override func copy() -> Any {
        let copy = Obstacle(obstacle: self)
        return copy
    }
    
    func setupShape(withPhysicsBody: Bool = true) {
        self.shape.size = Constants.obstacleSizeMap[imageName] ?? Constants.obstacleSmallSize
        if withPhysicsBody {
            setupPhysicsProperty()
        }
    }

    private func resetPhysicsBodySize() {
        let currFlyingVelocity = self.shape.physicsBody?.velocity
        let currAngularVelocity = self.shape.physicsBody?.angularVelocity
        let newPhysicsBody = SKPhysicsBody(rectangleOf: self.shape.size)
        newPhysicsBody.isDynamic = true
        newPhysicsBody.categoryBitMask = PhysicsCategory.Obstacle
        newPhysicsBody.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Obstacle | PhysicsCategory.Player | PhysicsCategory.Map | PhysicsCategory.Grenade
        if self.isStatic {
            newPhysicsBody.collisionBitMask = PhysicsCategory.None
        } else {
            newPhysicsBody.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Obstacle | PhysicsCategory.Map | PhysicsCategory.Grenade
        }
        newPhysicsBody.velocity = currFlyingVelocity!
        newPhysicsBody.angularVelocity = currAngularVelocity!
        
        self.shape.physicsBody = newPhysicsBody
    }

    func setupPhysicsProperty() {
        self.shape.physicsBody = SKPhysicsBody(rectangleOf: self.shape.size)
        self.shape.physicsBody?.isDynamic = true
        self.shape.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        self.shape.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Obstacle | PhysicsCategory.Player | PhysicsCategory.Map | PhysicsCategory.Grenade
        if self.isStatic {
            self.shape.physicsBody?.collisionBitMask = PhysicsCategory.None
        } else {
            self.shape.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Obstacle | PhysicsCategory.Map | PhysicsCategory.Grenade
        }
    }

    required convenience init?(coder decoder: NSCoder) {
        guard let imageName = decoder.decodeObject(forKey: Constants.imageNameKey) as? String else {
            return nil
        }
        let initialPosition = decoder.decodeCGPoint(forKey: Constants.initialPositionKey)
        self.init(image: imageName, userSetInitialPosition: initialPosition)
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(imageName, forKey: Constants.imageNameKey)
        aCoder.encode(initialPosition, forKey: Constants.initialPositionKey)
    }
}
