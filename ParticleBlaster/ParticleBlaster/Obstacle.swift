//
//  Obstacle.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 22/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/*
 * The `Osbtacle` class is the model for all obstacles the user needs to clear during the game
 * It subclassed the basic GameObject class, and added extra functions for the unique attributes of obs
 *      - It defines its own initial physics properties
 *      - It defines the remaining life percentage of the obstacle, updating it after hit by weapon
 *      - It defines the behavior of the obstacle after being hit by weapon
 *      - It provides the API for checking whether it has been destroyed
 *      - It provides the API for making copy of itself when being added to the design
 */


import SpriteKit

class Obstacle : GameObject {
    
    /* Start of class attributes definition */
    // This position is archived as ratio position, and need to convert to absolute value when displaying
    var initialPosition: CGPoint
    // for support storage purpose
    var imageName: String = "obs"
    
    // Computed property, invoked when the obstacle is hit and its size needs recalculation
    private var remainingLifePercentage: CGFloat {
        get {
            return CGFloat(self.timeToLive) / CGFloat(Constants.defaultTimeToLive)
        }
    }
    /* End of class attributes definition */


    /* Start of initializors and supporting functions */
    // Initialize with the image name provided
    init(image: String, userSetInitialPosition: CGPoint) {
        self.imageName = image
        self.initialPosition = userSetInitialPosition
        super.init(imageName: image)
        self.timeToLive = Constants.defaultTimeToLive
        setupShape()
    }
    
    init(image: String, userSetInitialPosition: CGPoint, timeToLIve: Int) {
        self.imageName = image
        self.initialPosition = userSetInitialPosition
        super.init(imageName: image)
        self.timeToLive = timeToLive
        setupShape()
    }

    // Initialize with the same attributes of an existing obstacle, discarding the original physics body
    init(obstacle: Obstacle) {
        self.imageName = obstacle.imageName
        self.initialPosition = obstacle.initialPosition
        super.init(shape: obstacle.shape.copy() as! SKSpriteNode,
                   timeToLive: obstacle.timeToLive,
                   isStatic: obstacle.isStatic)
        self.shape.position = obstacle.shape.position
        self.shape.physicsBody = nil
    }
    
    // Initializor supporting the storing of Obstacle objects using Object Archive
    required convenience init?(coder decoder: NSCoder) {
        guard let imageName = decoder.decodeObject(forKey: Constants.imageNameKey) as? String else {
            return nil
        }
        let initialPosition = decoder.decodeCGPoint(forKey: Constants.initialPositionKey)
        self.init(image: imageName, userSetInitialPosition: initialPosition)
    }
    
    // Encoding function for supporting Object Archive
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(imageName, forKey: Constants.imageNameKey)
        aCoder.encode(initialPosition, forKey: Constants.initialPositionKey)
    }
    
    // This function returns a copy of itself without the existing physics properties
    override func copy() -> Any {
        let copy = Obstacle(obstacle: self)
        return copy
    }
    /* End of initializors and supporting functions */

    
    /* Start of collision handler functions */
    // This function updates the size of the obstacle once it is hit by weapon
    func hitByBullet() {
        self.timeToLive -= 1
        let decreasePersentage = CGFloat(0.95)
        self.shape.size = CGSize(width: self.shape.size.width * decreasePersentage, height: self.shape.size.height * decreasePersentage)
        self.resetPhysicsBodySize()
    }

    // This function checks if the current obstacle is destroyed
    func checkDestroyed() -> Bool {
        if self.timeToLive <= 0 {
            return true
        } else {
            return false
        }
    }
    /* End of collision handler functions */

    
    /* Start of physics body setup and update functions */
    // This function sets up the initial size of the obstacle according to its image (hence type)
    func setupShape(withPhysicsBody: Bool = true) {
        self.shape.size = Constants.obstacleSizeMap[imageName] ?? Constants.obstacleBasicSize
        if withPhysicsBody {
            setupPhysicsProperty()
        }
    }
    
    // This function sets the physics body of the obstacle from the default size of the obstacle
    func setupPhysicsProperty() {
        let newPhysicsBody = self.generatePhysicsBody()
        self.shape.physicsBody = newPhysicsBody
    }
    
    // This function resets the physics properties of the obstacle once its physics size needs update
    private func resetPhysicsBodySize() {
        let currFlyingVelocity = self.shape.physicsBody?.velocity
        let currAngularVelocity = self.shape.physicsBody?.angularVelocity
        let newPhysicsBody = self.generatePhysicsBody()
        newPhysicsBody.velocity = currFlyingVelocity!
        newPhysicsBody.angularVelocity = currAngularVelocity!
        
        self.shape.physicsBody = newPhysicsBody
    }

    // This function returns a new physics body associated with the size of the obstacle
    private func generatePhysicsBody() -> SKPhysicsBody {
        let newPhysicsBody = SKPhysicsBody(circleOfRadius: self.shape.frame.width / 2)
        //let newPhysicsBody = SKPhysicsBody(texture: self.shape.texture!, size: self.shape.size)
        newPhysicsBody.isDynamic = true
        newPhysicsBody.categoryBitMask = PhysicsCategory.Obstacle
        newPhysicsBody.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Obstacle | PhysicsCategory.Player | PhysicsCategory.Map | PhysicsCategory.Grenade
        if self.isStatic {
            newPhysicsBody.collisionBitMask = PhysicsCategory.None
        } else {
            newPhysicsBody.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Obstacle | PhysicsCategory.Map | PhysicsCategory.Grenade
        }
        
        return newPhysicsBody
    }
    /* End of physics body setup and update functions */
    
}
