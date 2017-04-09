//
//  LevelDesignerViewController.swift
//  ParticleBlaster
//
//  Created by Richthofen on 26/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

class LevelDesignerViewController: UIViewController, SKPhysicsContactDelegate {
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
        scene.addNewPlayerHandler = self.addNewPlayer
        scene.removePlayerHandler = self.removePlayer
        scene.updateBackgroundImageNameHandler = self.updateBackgroundImage
        scene.saveGameLevelHandler = self.saveGameLevel
        scene.previewHandler = self.navigateToPreviewScene
        
        skView.presentScene(scene)
    }
    
    // For obstacles
    private func addNewObstacle(_ newObstacle: Obstacle) {
        print("in LevelDesignerViewController addNewObstacle")
        newObstacle.setupPhysicsPropertyWithoutSize()
        currentLevel.obstacles.append(newObstacle)
        print("currentLevel has \(currentLevel.obstacles.count) obstacles")
    }
    
    private func removeObstacle(_ tag: Int) -> Obstacle {
        return currentLevel.obstacles.remove(at: tag)
    }
    
    // For players
    private func addNewPlayer(_ newPlayer: Player) {
        currentLevel.players.append(newPlayer)
    }
    
    private func removePlayer(_ tag: Int) -> Player {
        return currentLevel.players.remove(at: tag)
    }
    
    // For background
    private func updateBackgroundImage(_ newBackGroundImageName: String) {
        currentLevel.backgroundImageName = newBackGroundImageName
    }
    
    private func saveGameLevel() -> Bool {
        return FileUtils.saveGameLevel(currentLevel)
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
    
    func navigateToPreviewScene() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: GameViewController = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
//        vc.gameMode = GameMode.multiple
        vc.gameLevel = currentLevel
        self.present(vc, animated: true, completion: nil)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Arranges two colliding bodies so they are sorted by their category bit masks
        
    }


}
