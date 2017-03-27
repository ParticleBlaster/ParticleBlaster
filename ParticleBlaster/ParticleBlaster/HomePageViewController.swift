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

//    override func viewDidLoad() {
////        super.viewDidLoad()
////        
////        let backgroundImageView = UIImageView(image: Constants.backgroundImage)
////        let backgroundView = UIView()
////        backgroundView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: view.bounds.size)
////        backgroundView.addSubview(backgroundImageView)
////        
////        let gameTitle = UILabel(frame: CGRect(x: 200, y: 100, width: 500, height: 100))
////        gameTitle.text = "Tri Adventure"
////        gameTitle.font = UIFont(name: Constants.TITLE_FONT, size: 120)
////        
////        setupButtons()
//        setupBGM()
//    }
//    
//    func setupBGM() {
//        let path = Bundle.main.path(forResource: "background-music-aac.caf", ofType:nil)!
//        let url = URL(fileURLWithPath: path)
//        
//        do {
//            let backgroundMusic = try AVAudioPlayer(contentsOf: url)
//            backgroundMusic.play()
//        } catch {
//            print("BGM unable to load")
//        }
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */

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
