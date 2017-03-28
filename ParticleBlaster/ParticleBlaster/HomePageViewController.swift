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
//    var mfi: MFiController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startHomePageView()
//        setupMFiController()
        
    }
    
//    private func setupMFiController() {
//        self.mfi = MFiController()
//        self.mfi.setupConnectionNotificationCenter()
//        
//        print("homapage: finish mfi config")
//    }
    
    func startHomePageView() {
        let scene = HomePageScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        scene.viewController = self
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
