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
    
    @IBOutlet var AButton: UIButton!
    
    @IBOutlet var startLabel: UILabel!
    
    @IBOutlet var attentionLabel: UILabel!
    
    @IBOutlet var challengeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startSong()
        
        challengeImage.isHidden = true
        
        self.startLabel.alpha = 0.5
        self.attentionLabel.alpha = 0
        self.attentionLabel.text = ""
        UILabel.animate(withDuration: 1.5, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.startLabel.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            self.startLabel.alpha = 1
        })
        
        UILabel.animate(withDuration: 0.3, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.attentionLabel.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            self.attentionLabel.text = "..."
            self.attentionLabel.alpha = 1
        })
        
        
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) {_ in
            self.attentionLabel.isHidden = true
            self.challengeImage.isHidden = false
        }
        
    }
    
    func startSong(){
        
        guard let url = Bundle.main.url(forResource: "applause", withExtension: "mp3") else {
            print("No file with specified name exists")
            return }
        do{
            
            player = AVPlayer(url: url)
            player?.volume = 0.07
            player?.allowsExternalPlayback = true
        
            self.player!.play()
        }
    }
    
    @IBAction func AButtonAction(_ sender: Any) {
        print("alo")
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Recognition")
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
