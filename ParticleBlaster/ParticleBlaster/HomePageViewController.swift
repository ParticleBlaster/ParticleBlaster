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
    // Check the default leaderboardID
    var gcDefaultLeaderBoard = String()
    // Check if the user has Game Center enabled
    var gcEnabled: Bool = false {
        didSet {
            guard oldValue != gcEnabled else {
                return
            }
            self.onGCEnableChange()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupSound()
        navigateToHomePage()

        // Call the GC authentication controller
        authenticateLocalPlayer()
        
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
    
    func onGCEnableChange() {
        guard let scene = homePageScene else {
            return
        }
        scene.onGCEnableChange(isEnabled: gcEnabled)
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

     // MARK: - AUTHENTICATE LOCAL PLAYER
    private func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()

        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // Player is already authenticated & logged in, load game center
                self.gcEnabled = true

                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                         print(error ?? "")
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                        print(self.gcDefaultLeaderBoard)
                    }
                })
            } else {
                // Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error ?? "")
            }
        }
    }

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        startHomePageView()
//        //        setupMFiController()
//        
//    }
//        
//    func startHomePageView() {
//        let scene = HomePageScene(size: view.bounds.size)
//        let skView = view as! SKView
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//        skView.ignoresSiblingOrder = true
//        scene.scaleMode = .resizeFill
//        scene.viewController = self
//        skView.presentScene(scene)
//    }

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
        vc.gameMode = GameMode.multiple
        vc.gameLevel = gameLevel
        self.present(vc, animated: true, completion: nil)
    }
//    func navigateToDesignScene(gameMode: GameMode) {
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc: LevelDesignerViewController = storyboard.instantiateViewController(withIdentifier: "LevelDesignerViewController") as! LevelDesignerViewController
//        self.present(vc, animated: true, completion: nil)
//    }
    func navigateToDesignScene(gameLevel: GameLevel) {
        let skView = view as! SKView
        let reveal = SKTransition.crossFade(withDuration: 0.5)
        let scene = LevelDesignerScene(size: skView.frame.size, gameLevel: gameLevel)
        scene.scaleMode = .resizeFill
        scene.navigationDelegate = self
        skView.presentScene(scene, transition: reveal)
    }
    func navigateToLevelSelectScene(gameMode: GameMode) {
        let skView = view as! SKView
        let reveal = SKTransition.crossFade(withDuration: 0.5)
        let scene = LevelSelectScene(size: skView.frame.size, gameMode: gameMode)
        scene.navigationDelegate = self
        skView.presentScene(scene, transition: reveal)
    }
    func navigateToHomePage() {
        let skView = view as! SKView
        let reveal = SKTransition.crossFade(withDuration: 0.5)
        if homePageScene == nil {
            homePageScene = HomePageScene(size: skView.frame.size)
            homePageScene?.navigationDelegate = self
        }
        skView.presentScene(homePageScene!, transition: reveal)
    }

    func navigateToLeaderBoard() {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = Constants.levelLeaderboardID
        present(gcVC, animated: true, completion: nil)
    }
}
