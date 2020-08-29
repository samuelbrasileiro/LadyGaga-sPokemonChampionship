//
//  MenuViewController.swift
//  Lady Gaga's Pokemon Championship
//
//  Created by Samuel Brasileiro on 27/08/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import os.log

class MenuViewController: UIViewController {
    var player1: AVAudioPlayer?
    var player2: AVAudioPlayer?
    
    @IBOutlet var AButton: UIButton!
    
    @IBOutlet var startLabel: UILabel!
    
    @IBOutlet var challengeImage: UIImageView!
    
    @IBOutlet var BButton: UIButton!
    
    @IBOutlet var cameraButton: UIButton!
    
    @IBOutlet var photoLibraryButton: UIButton!
    
    @IBOutlet var selectImageSourceView: UIView!
    
    @IBOutlet var upButton: UIButton!
    
    @IBOutlet var downButton: UIButton!
    
    //var pokemonImageView: UIImageView?
    
    let classifier = ImageClassification()
    
    var eggGroupBank: EggGroupBank?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eggGroupBank = EggGroupBank()
        eggGroupBank?.delegate = self
        
        
        
        classifier.delegate = self
        
        
        playSound(name: "applause", withExtension: "mp3", player: &player1)
        
        challengeImage.isHidden = true
        selectImageSourceView.isHidden = true
        
        
        BButton.tag = -1
        AButton.tag = -1
        upButton.tag = -1
        //downButton.tag = -1
        
        cameraButton.isUserInteractionEnabled = false
        photoLibraryButton.isUserInteractionEnabled = false
        
        createAnimations()
        
    }
    
    
    
    
    
    
    
    
    
    
    //MARK:- Botões
    @IBAction func buttonAction(_ sender: UIButton) {
        playSound(name: "button", withExtension: "wav", player: &player2)
        
        //tag -1 = inativo
        if sender.tag == -1{
            return
        }
        
        if sender == AButton{

            //tag 0 = tela normal
            //tag 1 = tela de escolha de camera
            //tag 2 = escolher opcão
            if sender.tag == 0{
                selectImageSourceView.isHidden = false
                challengeImage.isHidden = true
                
                cameraButton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                               photoLibraryButton.backgroundColor = .clear
                               
                               upButton.tag = 0
                               
                               sender.tag = 2
                
                sender.tag = 2
            }
            else if sender.tag == 1{
                challengeImage.image = UIImage(named: "ladygagachallenge")
                selectImageSourceView.isHidden = true
                challengeImage.isHidden = false
                
                sender.tag = 0
            }
            else if sender.tag == 2{
                
                if upButton.tag == 0{
                    selectImageSourceView.isHidden = true
                    self.presentPhotoPicker(sourceType: .camera)
                }
                else if upButton.tag == 1{
                    selectImageSourceView.isHidden = true
                    self.presentPhotoPicker(sourceType: .photoLibrary)
                }
                
            }
            
        }
        else if sender == BButton{
            selectImageSourceView.isHidden = true
            challengeImage.isHidden = false
            upButton.tag = -1
            
            var name = ""
            //tag 0 = tela inicial
            //tag 1 = tela tutorial
            if sender.tag == 1 || AButton.tag != 0{
                name = "ladygagachallenge"
                sender.tag = 0
                AButton.tag = 0
            }
            else if sender.tag == 0{
                name = "tutorial"
                sender.tag = 1
            }
            
            challengeImage.image = UIImage(named: name)
            
        }
        
        else if sender == upButton || sender == downButton{
            if upButton.tag == 0{
                cameraButton.backgroundColor = .clear
                photoLibraryButton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                
                upButton.tag = 1
            }
            else if upButton.tag == 1{
                cameraButton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                photoLibraryButton.backgroundColor = .clear
                
                upButton.tag = 0
            }
        }
        
        else if sender == cameraButton{
            selectImageSourceView.isHidden = true
            self.presentPhotoPicker(sourceType: .camera)
        }
        else if sender == photoLibraryButton{
            selectImageSourceView.isHidden = true
            self.presentPhotoPicker(sourceType: .photoLibrary)
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
                
        self.startLabel.alpha = 0.5
        
        UILabel.animate(withDuration: 1.5, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.startLabel.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            self.startLabel.alpha = 1
        })
                
        let movingImages = (0...74).compactMap { index -> UIImage? in
             let imageNumber = String(format: "%02d", index)
             return UIImage(named: "bouncingBalls/\(imageNumber)")
        }
        
        let ballsImageView = UIImageView(frame: challengeImage.frame)
        self.view.addSubview(ballsImageView)
        
        ballsImageView.animationImages = movingImages
        ballsImageView.animationDuration = 3
        ballsImageView.animationRepeatCount = .max
        ballsImageView.startAnimating()
        
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
        anim.repeatCount = .infinity
        bar.add(anim, forKey: nil)
        lay.instanceDelay = anim.duration / Double(lay.instanceCount)
        // and now just add `lay` to the interface
        self.view.layer.addSublayer(lay)
        
        Timer.scheduledTimer(withTimeInterval: 6, repeats: false) {_ in
            lay.isHidden = true
            ballsImageView.isHidden = true
            
            self.AButton.tag = 0
            self.BButton.tag = 0
            
            self.challengeImage.isHidden = false
        }
    }
}




extension MenuViewController: EggGroupBankDelegate, ImageClassificationDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func updateClassification(text: String) {
        startLabel.text = text
    }
    
    func updateImage(from data: Data) {
        if let image = UIImage(data: data){
            challengeImage.image = image
            challengeImage.isHidden = false
            //pokemonImageView.image = image
        }
    }
    
    // MARK: - Handling Image Picker Selection
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        //startLabel.isHidden = true
        
        
        // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
        let image:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        print(image)
        classifier.updateClassifications(for: image)
        eggGroupBank?.downloadEggGroups()
        
    }
    
    
    
}
