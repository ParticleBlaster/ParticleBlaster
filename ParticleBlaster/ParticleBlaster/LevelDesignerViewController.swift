//
//  LevelDesignerViewController.swift
//  ParticleBlaster
//
//  Created by Richthofen on 26/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

class LevelDesignerViewController: UIViewController {
    var currentLevel: GameLevel = GameLevel()
    var loadedLevel: GameLevel?
    var skView: SKView!
//    var currentObstacle: Obstacle?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLevelDesignerView()
    }
    
    func startLevelDesignerView() {
        skView = view as! SKView
        let scene = LevelDesignerScene(size: view.bounds.size)
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        
        scene.scaleMode = .resizeFill
        scene.viewController = self
        scene.returnHomeHandler = self.returnHome
        scene.addNewObstacleHandler = self.addNewObstacle
        scene.removeObstacleHandler = self.removeObstacle
        scene.updateObstacleHandler = self.updateObstacle
        
        skView.presentScene(scene)
    }
    
    private func addNewObstacle(_ newObstacle: Obstacle) {
        print("in LevelDesignerViewController addNewObstacle")
        currentLevel.obstacles.append(newObstacle)
        print("currentLevel has \(currentLevel.obstacles.count) obstacles")
    }
    
    private func removeObstacle(_ tag: Int) -> Obstacle {
        return currentLevel.obstacles.remove(at: tag)
    }
    
    private func updateObstacle(tag: Int, newObstacle: Obstacle) {
        currentLevel.obstacles[tag] = newObstacle
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func returnHome() {
        self.skView.presentScene(nil)
        self.dismiss(animated: true, completion: nil)
    }

}
