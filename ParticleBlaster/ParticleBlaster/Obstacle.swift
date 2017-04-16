//
//  Obstacle.swift
//  ParticleBlaster
//
//  Created by Richard Jiang on 22/03/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

/*
 * The `Obstacle` class is the model for all obstacles the user needs to clear during the game
 * It subclassed the basic GameObject class, and added extra functions for the unique attributes of obs
 *      - It defines its own initial physics properties
 *      - It defines the remaining life percentage of the obstacle, updating it after hit by weapon
 *      - It defines the behavior of the obstacle after being hit by weapon
 *      - It provides the API for checking whether it has been destroyed
 *      - It provides the API for making copy of itself when being added to the design
 *
 * The representation invariants:
 *      - It should be a non static game object
 *      - The timeToLive value is non-negative
 */


import SpriteKit

class Obstacle : GameObject {
    
    /* Start of class attributes definition */
    // This position is archived as ratio position, and need to convert to absolute value when displaying
    var initialPosition: CGPoint
    // To support storage purpose
    var imageName: String = "obs"

    /* End of class attributes definition */

    /* Start of initializors and supporting functions */
    // Initialize with the image name, initial position and time-to-live value provided
    init(image: String, userSetInitialPosition: CGPoint, timeToLive: Int) {
        self.imageName = image
        self.initialPosition = userSetInitialPosition
        super.init(imageName: image, timeToLive: Constants.defaultTimeToLive)
        self.timeToLive = timeToLive
        setupShape()
        _checkRep()
    }
    
    convenience init(image: String, userSetInitialPosition: CGPoint) {
        self.init(image: image, userSetInitialPosition: userSetInitialPosition, timeToLive: Constants.defaultTimeToLive)
        _checkRep()
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
        _checkRep()
    }
    
    // Initializor supporting the storing of Obstacle objects using Object Archive
    required convenience init?(coder decoder: NSCoder) {
        guard let imageName = decoder.decodeObject(forKey: Constants.imageNameKey) as? String else {
            return nil
        }
        let initialPosition = decoder.decodeCGPoint(forKey: Constants.initialPositionKey)
        self.init(image: imageName, userSetInitialPosition: initialPosition)
        _checkRep()
    }
    
    // Encoding function for supporting Object Archive
    override func encode(with aCoder: NSCoder) {
        _checkRep()
        aCoder.encode(imageName, forKey: Constants.imageNameKey)
        aCoder.encode(initialPosition, forKey: Constants.initialPositionKey)
        _checkRep()
    }
    
    // This function returns a copy of itself without the existing physics properties
    override func copy() -> Any {
        _checkRep()
        let copy = Obstacle(obstacle: self)
        _checkRep()
        return copy
    }
    /* End of initializors and supporting functions */

    
    /* Start of collision handler functions */
    // This function updates the size of the obstacle once it is hit by weapon
    func hitByBullet() {
        _checkRep()
        if self.timeToLive > 0 {
            self.timeToLive -= 1
            let originalSize = SpriteUtils.getObstacleOriginalSize(self)
            let minWidth = Constants.obstacleMinimumWidth
            let minHeight = minWidth * originalSize.height / originalSize.width
            let remainingPercentage = CGFloat(timeToLive) / CGFloat(SpriteUtils.getObstacleTimeToLive(self))
            self.shape.size = CGSize(width: minWidth + (originalSize.width - minWidth) * remainingPercentage,
                                     height: minHeight + (originalSize.height - minHeight) * remainingPercentage)
            self.resetPhysicsBodySize()
        }
        _checkRep()
    }

    // This function checks if the current obstacle is destroyed
    func checkDestroyed() -> Bool {
        _checkRep()
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
        _checkRep()
        self.shape.size = Constants.obstacleSizeMap[imageName] ?? CGSize(width: Constants.obstacleBasicWidth,
                                                                         height: Constants.getHeightWithSameRatio(withWidth:  Constants.obstacleBasicWidth, forShape: self.shape))
        if withPhysicsBody {
            setupPhysicsProperty()
        }
        _checkRep()
    }
    
    // This function sets the physics body of the obstacle from the default size of the obstacle
    func setupPhysicsProperty() {
        _checkRep()
        let newPhysicsBody = self.generatePhysicsBody()
        self.shape.physicsBody = newPhysicsBody
        _checkRep()
    }
    
    // This function resets the physics properties of the obstacle once its physics size needs update
    private func resetPhysicsBodySize() {
        _checkRep()
        let currFlyingVelocity = self.shape.physicsBody?.velocity
        let currAngularVelocity = self.shape.physicsBody?.angularVelocity
        let newPhysicsBody = self.generatePhysicsBody()
        newPhysicsBody.velocity = currFlyingVelocity!
        newPhysicsBody.angularVelocity = currAngularVelocity!
        
        self.shape.physicsBody = newPhysicsBody
        _checkRep()
    }

    // This function returns a new physics body associated with the size of the obstacle
    private func generatePhysicsBody() -> SKPhysicsBody {
        _checkRep()
        let newPhysicsBody = SKPhysicsBody(circleOfRadius: self.shape.size.width / 2)
        newPhysicsBody.isDynamic = true
        newPhysicsBody.categoryBitMask = PhysicsCategory.Obstacle
        newPhysicsBody.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Obstacle | PhysicsCategory.Player | PhysicsCategory.Map | PhysicsCategory.Grenade
        if self.isStatic {
            newPhysicsBody.collisionBitMask = PhysicsCategory.None
        } else {
            newPhysicsBody.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Obstacle | PhysicsCategory.Map | PhysicsCategory.Grenade
        }
        _checkRep()
        return newPhysicsBody
    }
    
    // A valid Obstacle should be a non-static game object with timeToLive value >= 0
    private func _checkRep() {
        assert(self.isStatic == false, "Should be a non-static game object.")
        assert(self.timeToLive >= 0, "Invalid time to live value.")
    }
    /* End of physics body setup and update functions */
    
}
