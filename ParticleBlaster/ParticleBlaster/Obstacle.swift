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
        let currentPersentage = 1.0 - (1.0 - self.remainingLifePercentage) * 0.33
        print("curr ttl \(timeToLive)")
        print("curr perc \(currentPersentage)")
        self.shape.size = CGSize(width: Constants.obstacleWidth * currentPersentage, height: Constants.obstacleHeight * currentPersentage)
        self.resetPhysicsBodySize()
    }

    func checkDestroyed() -> Bool {
        if self.timeToLive <= 0 {
            return true
        } else {
            return false
        }
    }
    
    func copy() -> Obstacle {
        let copy = Obstacle(obstacle: self)
        return copy
    }
    
    func copyWithoutPhysicsBody() -> Obstacle {
        let copy = Obstacle(obstacle: self, isPhysicsBody: false)
        return copy
    }
    
    private func resetPhysicsBodySize() {
        let currFlyingVelocity = self.shape.physicsBody?.velocity
        let currAngularVelocity = self.shape.physicsBody?.angularVelocity
        let newPhysicsBody = SKPhysicsBody(rectangleOf: self.shape.size)
        newPhysicsBody.isDynamic = true
        newPhysicsBody.categoryBitMask = PhysicsCategory.Obstacle
        newPhysicsBody.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Obstacle | PhysicsCategory.Player | PhysicsCategory.Map
        if self.isStatic {
            newPhysicsBody.collisionBitMask = PhysicsCategory.None
        } else {
            newPhysicsBody.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Obstacle | PhysicsCategory.Map
        }
        newPhysicsBody.velocity = currFlyingVelocity!
        newPhysicsBody.angularVelocity = currAngularVelocity!
        
        self.shape.physicsBody = newPhysicsBody

    }

    private func setupPhysicsProperty() {
        let computedWidth = Constants.obstacleWidth * self.remainingLifePercentage
        let computedHeight = Constants.obstacleHeight * self.remainingLifePercentage
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
}
