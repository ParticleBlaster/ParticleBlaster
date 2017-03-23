//
//  GameViewController.swift
//  ParticleBlaster
//
//  Created by Bohan Huang on 12/3/17.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startHomePageView()
    }
    
    func startHomePageView() {
        let scene = HomePageScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        scene.navigationDelegate = self
        skView.presentScene(scene)
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
}

extension GameViewController: NavigationDelegate {
    func navigateToHomePage() {
        let skView = view as! SKView
        let reveal = SKTransition.crossFade(withDuration: 0.5)
        let scene = HomePageScene(size: skView.frame.size)
        scene.navigationDelegate = self
        skView.presentScene(scene, transition: reveal)
    }

    func navigateToDesignScene() {
        // TODO: implement this
    }

    func navigateToPlayScene() {
        let skView = view as! SKView
        let reveal = SKTransition.crossFade(withDuration: 0.5)
        let scene = GameScene(size: skView.frame.size)
        skView.presentScene(scene, transition: reveal)
    }

    func navigateToLevelSelectScene(isSingleMode: Bool = true) {
        let skView = view as! SKView
        let reveal = SKTransition.crossFade(withDuration: 0.5)
        let scene = LevelSelectScene(size: skView.frame.size)
        scene.navigationDelegate = self
        skView.presentScene(scene, transition: reveal)
    }
}
