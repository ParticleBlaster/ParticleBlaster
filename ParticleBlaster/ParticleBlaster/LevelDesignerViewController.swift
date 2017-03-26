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
    var currentLevel: GameLevel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLevelDesignerView()
    }
    
    func startLevelDesignerView() {
        let scene = LevelDesignerScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        
        scene.scaleMode = .resizeFill
        scene.viewController = self
        scene.returnHomeHandler = self.returnHome
        
        skView.presentScene(scene)
    }
    
    func addNewObstable(_ newObstacle: Obstacle) {
        currentLevel?.obstacles.append(newObstacle)
    }
    
    func removeObstable(_ tag: Int) -> Bool {
        return currentLevel?.obstacles.remove(at: tag) != nil
    }
    
    func updateObstacle(tag: Int, newObstacle: Obstacle) {
        currentLevel?.obstacles[tag] = newObstacle
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
        self.dismiss(animated: true, completion: nil)
    }

}
