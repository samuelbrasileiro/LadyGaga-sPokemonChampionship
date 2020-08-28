//
//  MenuViewController.swift
//  Lady Gaga's Pokemon Championship
//
//  Created by Samuel Brasileiro on 27/08/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit
import AVFoundation


class MenuViewController: UIViewController {
    var player1: AVAudioPlayer?
    var player2: AVAudioPlayer?
    @IBOutlet var AButton: UIButton!
    
    @IBOutlet var startLabel: UILabel!
        
    @IBOutlet var challengeImage: UIImageView!
    
    @IBOutlet var BButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        playSound(name: "applause", withExtension: "mp3", player: &player1)
        challengeImage.isHidden = true
        
        self.startLabel.alpha = 0.5

        BButton.tag = 0
        
        createAnimations()
        
    }
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
        playSound(name: "button", withExtension: "wav", player: &player2)
        
        if sender == AButton{
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Recognition")
        navigationController?.pushViewController(vc, animated: true)
        }
        else if sender == BButton{
            if sender.tag == 0{
                challengeImage.image = UIImage(named: "cursorD")
                sender.tag = 1
            } else{
                challengeImage.image = UIImage(named: "ladygagachallenge")
                sender.tag = 0
                
            }
        }
    }
    
    
    
    
    func playSound(name: String, withExtension ext: String, player: inout AVAudioPlayer?){
        
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("No file with specified name exists")
            return }
        do{
            
            player = try AVAudioPlayer(contentsOf: url)
            player!.volume = 0.07
            
            player!.play()
        } catch{
            print("no song babe")
        }
    }
    
    func createAnimations(){
        UILabel.animate(withDuration: 1.5, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.startLabel.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            self.startLabel.alpha = 1
        })
        
        let lay = CAReplicatorLayer()
        lay.frame = CGRect(x: 157,y: 232,width: 100,height: 10)
        let bar = CALayer()
        bar.frame = CGRect(x: 0,y: 0,width: 10,height: 10)
        bar.backgroundColor = UIColor.systemYellow.cgColor
        lay.addSublayer(bar)
        lay.instanceCount = 5
        lay.instanceTransform = CATransform3DMakeTranslation(20, 0, 0)
        let anim = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        anim.fromValue = 1.0
        anim.toValue = 0.1
        anim.duration = 1
        anim.repeatCount = 4
        bar.add(anim, forKey: nil)
        lay.instanceDelay = anim.duration / Double(lay.instanceCount)
        // and now just add `lay` to the interface
        self.view.layer.addSublayer(lay)
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) {_ in
            lay.isHidden = true
            self.challengeImage.isHidden = false
        }
    }
    
}
