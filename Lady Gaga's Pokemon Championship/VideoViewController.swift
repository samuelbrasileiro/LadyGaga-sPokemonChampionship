//
//  ViewController.swift
//  Lady Gaga's Pokemon Championship
//
//  Created by Samuel Brasileiro on 26/08/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit
import AVKit

protocol BackgroundViewControllerDelegate{
    func changeViewController()
}

class StartPlayerViewController: AVPlayerViewController{
    
    var backgroundViewControllerDelegate: BackgroundViewControllerDelegate?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        player?.replaceCurrentItem(with: nil)
        player = nil
        
        backgroundViewControllerDelegate?.changeViewController()
        
    }
}

class VideoViewController: UIViewController, BackgroundViewControllerDelegate {
    
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        startVideo()
    }
    
    func startVideo(){
        
        guard let url = Bundle.main.url(forResource: "ladygaganba", withExtension: "mp4") else {
            print("No file with specified name exists")
            return }
        do{
            
            player = AVPlayer(url: url)
            
            player?.allowsExternalPlayback = true
            let playerController = StartPlayerViewController()
            
            playerController.backgroundViewControllerDelegate = self
            playerController.player = player
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
            
            
            navigationController?.present(playerController, animated: true, completion: {
                self.player!.play()
            })
        }
    }
    
    func changeViewController(){
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Menu") as? MenuViewController{
            NotificationCenter.default.removeObserver(self)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(NSNotification.Name.AVPlayerItemDidPlayToEndTime)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        
        navigationController?.topViewController?.dismiss(animated: true)
        
    }
    
}

