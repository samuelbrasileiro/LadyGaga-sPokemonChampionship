//
//  MenuViewController.swift
//  Lady Gaga's Pokemon Championship
//
//  Created by Samuel Brasileiro on 27/08/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit
import AVKit
class MenuViewController: UIViewController {
    var player: AVPlayer?
    
    @IBOutlet var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startSong()
        
        UIButton.animate(withDuration: 1.5, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.startButton.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
        })
        
    }
    
    func startSong(){
        
        guard let url = Bundle.main.url(forResource: "applause", withExtension: "mp3") else {
            print("No file with specified name exists")
            return }
        do{
            
            player = AVPlayer(url: url)
            player?.volume = 0.1
            player?.allowsExternalPlayback = true
        
            self.player!.play()
        }
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
    }
    
}
