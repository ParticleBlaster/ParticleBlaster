//
//  HomePageViewController.swift
//  ParticleBlaster
//
//  Created by Richthofen on 26/03/2017.
//  Copyright © 2017 ParticleBlaster. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class HomePageViewController: UIViewController {

    // Stored scenes
    var homePageScene: HomePageScene?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupSound()
        navigateToHomePage()

        // Call the GC authentication controller
        GameCenterUtils.authenticateLocalPlayer(in: self) { (isSuccess) in
            self.onGCEnableChange(isEnabled: isSuccess)
        }
        
        setupThemes()
        
        setupMFiControllers()
        MFiControllerConfig.startNextMFiConnectionNotificationCenter()
     }
    
    private func setupMFiControllers() {
        for _ in 0 ..< MFiControllerConfig.maxMFi {
            let mfi = MFiController()
            MFiControllerConfig.mfis.append(mfi)
            print("\(MFiControllerConfig.mfis.count) added")
        }
    }
    
    private func setupThemes() {
        ThemeConfig.setThemes()
    }

    
    func onGCEnableChange(isEnabled: Bool) {
        guard let scene = homePageScene else {
            return
        }
        scene.onGCEnableChange(isEnabled: isEnabled)
    }
    
    func setupSound() {
        if GameSetting.getInstance().isMusicEnabled {
            AudioUtils.playBackgroundMusic()
        }
    }
    
    func setupView() {
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
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

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension HomePageViewController: GKGameCenterControllerDelegate {
    // Delegate to dismiss the GC controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}

extension HomePageViewController: NavigationDelegate {
    func navigateToPlayScene(gameLevel: GameLevel) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: GameViewController = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        vc.gameLevel = gameLevel
        self.present(vc, animated: true, completion: nil)
    }

    func navigateToDesignScene(gameLevel: GameLevel) {
        let skView = view as! SKView
        let reveal = SKTransition.crossFade(withDuration: Constants.sceneAnimationTime)
        let scene = LevelDesignerScene(size: skView.frame.size, gameLevel: gameLevel)
        scene.scaleMode = .resizeFill
        scene.navigationDelegate = self
        skView.presentScene(scene, transition: reveal)
    }

    func navigateToLevelSelectScene(gameMode: GameMode) {
        let skView = view as! SKView
        let reveal = SKTransition.crossFade(withDuration: Constants.sceneAnimationTime)
        let scene = LevelSelectScene(size: skView.frame.size, gameMode: gameMode)
        scene.navigationDelegate = self
        skView.presentScene(scene, transition: reveal)
    }

    func navigateToHomePage() {
        let skView = view as! SKView
        let reveal = SKTransition.crossFade(withDuration: Constants.sceneAnimationTime)
        if homePageScene == nil {
            homePageScene = HomePageScene(size: skView.frame.size)
            homePageScene?.navigationDelegate = self
        }
        skView.presentScene(homePageScene!, transition: reveal)
    }

    func navigateToLeaderBoard() {
        GameCenterUtils.openLevelLeaderboard(in: self)
    }
}
