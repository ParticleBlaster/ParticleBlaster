//
//  HomePageViewController.swift
//  ParticleBlaster
//
//  Created by Richthofen on 26/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit

class HomePageViewController: UIViewController {

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

extension HomePageViewController: NavigationDelegate {
    func navigateToPlayScene(isSingleMode: Bool = true) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: GameViewController = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        self.present(vc, animated: true, completion: nil)
    }
    func navigateToDesignScene() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: LevelDesignerViewController = storyboard.instantiateViewController(withIdentifier: "LevelDesignerViewController") as! LevelDesignerViewController
        self.present(vc, animated: true, completion: nil)
    }
    func navigateToLevelSelectScene(isSingleMode: Bool) {
        let skView = view as! SKView
        let reveal = SKTransition.crossFade(withDuration: 0.5)
        let scene = LevelSelectScene(size: skView.frame.size)
        scene.navigationDelegate = self
        skView.presentScene(scene, transition: reveal)
    }
    func navigateToHomePage() {
        let skView = view as! SKView
        let reveal = SKTransition.crossFade(withDuration: 0.5)
        let scene = HomePageScene(size: skView.frame.size)
        scene.navigationDelegate = self
        skView.presentScene(scene, transition: reveal)
    }
}
