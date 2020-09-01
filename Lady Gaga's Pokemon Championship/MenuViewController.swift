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
import CropViewController


class MenuViewController: UIViewController {
    
    //MARK:- Variables
    var player1: AVAudioPlayer?
    var player2: AVAudioPlayer?
    
    @IBOutlet var AButton: UIButton!
    
    @IBOutlet var instructionLabel: UILabel!
    
    @IBOutlet var challengeImage: UIImageView!
    
    @IBOutlet var BButton: UIButton!
    
    @IBOutlet var cameraButton: UIButton!
    
    @IBOutlet var photoLibraryButton: UIButton!
    
    @IBOutlet var selectImageSourceView: UIView!
    
    @IBOutlet var upButton: UIButton!
    
    @IBOutlet var downButton: UIButton!
        
    
    var detector: ObjectDetector?
    var eggGroupBank: EggGroupBank?
    
    var animationsView: UIView?
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var cameraView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        eggGroupBank = EggGroupBank()
        eggGroupBank?.delegate = self
        
        
        playSound(name: "applause", withExtension: "mp3", player: &player1)
        
        challengeImage.isHidden = true
        selectImageSourceView.isHidden = true
        
        animationsView = UIView(frame: challengeImage.frame)
        animationsView?.backgroundColor = .clear
        animationsView?.isHidden = false
        self.view.addSubview(animationsView!)
        
        BButton.tag = -1
        AButton.tag = -1
        upButton.tag = -1
        //downButton.tag = -1
        
        cameraButton.isUserInteractionEnabled = false
        photoLibraryButton.isUserInteractionEnabled = false
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(createAnimations),
        name: UIApplication.didBecomeActiveNotification,
        object: nil)
        
        Timer.scheduledTimer(withTimeInterval: 6.5, repeats: false) {_ in
            self.animationsView?.isHidden = true
            
            self.AButton.tag = 0
            self.BButton.tag = 0
            
            self.challengeImage.isHidden = false
        }
        
    }

    //MARK:- Buttons
    @IBAction func buttonAction(_ sender: UIButton) {
        playSound(name: "button", withExtension: "wav", player: &player2)
        
        //tag -1 = inativo
        if sender.tag == -1{
            return
        }
        
        self.animationsView?.isHidden = true
        
        if sender == AButton{

            //tag 0 = tela normal -> ir pra 2
            //tag 1 = tela de escolha de camera -> ir pra 0
            //tag 2 = escolher opcão -> ir pra 3
            //tag 3 = tirar foto -> se clicar de novo realiza ação 1
            BButton.tag = 1
            
            if sender.tag == 0{
                selectImageSourceView.isHidden = false
                challengeImage.isHidden = true
                
                instructionLabel.text = "Press 'A' to select!"
                
                cameraButton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                photoLibraryButton.backgroundColor = .clear
                
                upButton.tag = 0
                                
                sender.tag = 2
            }
            else if sender.tag == 1{
                instructionLabel.text = "Press 'A' to start!"
                challengeImage.image = UIImage(named: "ladygagachallenge")
                selectImageSourceView.isHidden = true
                challengeImage.isHidden = false
                
                sender.tag = 0
                
                
            }
            else if sender.tag == 2{
                self.animationsView!.isHidden = false
                selectImageSourceView.isHidden = true
                
                instructionLabel.text = "Press 'A' to shoot!"
                
                animationsView?.isHidden = false
                
                detector = ObjectDetector()
                detector?.delegate = self
                
                if upButton.tag == 0{
                    configureCamera()
                    BButton.tag = -1
                    sender.tag = 3
                    
                }
                else if upButton.tag == 1{
                    self.presentPhotoPicker(sourceType: .photoLibrary)
                }
            }
            else if sender.tag == 3{
                AButton.tag = -1
                animationsView?.isHidden = false
                DispatchQueue.global(qos: .userInitiated).async {
                    let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
                    self.stillImageOutput!.capturePhoto(with: settings, delegate: self)
                }
                //sender.tag = 1
                
            }
            
        }
        
        else if sender == BButton{
            selectImageSourceView.isHidden = true
            challengeImage.isHidden = false
            upButton.tag = -1
            instructionLabel.text = "Press 'A' to start!"

            var name = ""
            //tag 0 = tela inicial
            //tag 1 = tela tutorial
            if sender.tag == 1{
                name = "ladygagachallenge"
                sender.tag = 0
                if AButton.tag != 3{
                    AButton.tag = 0
                }
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
        
        
    }
    //MARK:- Camera
    func configureCamera(){
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = .medium
        
        
        guard let frontCamera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: AVMediaType.video,
        position: .front)
            else { fatalError("no front camera. but don't all iOS 10 devices have them?")}
        
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            //Step 9
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession!.canAddInput(input) && captureSession!.canAddOutput(stillImageOutput!) {
                captureSession!.addInput(input)
                captureSession!.addOutput(stillImageOutput!)
                setupLivePreview()
            }
            
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        
    }
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        
        videoPreviewLayer!.videoGravity = .resizeAspectFill
        videoPreviewLayer!.connection?.videoOrientation = .portrait
        
        cameraView = UIView(frame: challengeImage.frame)
        
        cameraView?.backgroundColor = .clear
        self.view.addSubview(cameraView!)
        
        cameraView!.layer.addSublayer(videoPreviewLayer!)
        
        //Step12
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession!.startRunning()
            //Step 13
            
            DispatchQueue.main.async {
                self.videoPreviewLayer!.frame = self.cameraView!.bounds
            }
        }
    }
    
    //MARK:- Som e animações
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
    
    override func viewDidAppear(_ animated: Bool) {
        createAnimations()
    }

    @objc func createAnimations(){
                
        self.instructionLabel.alpha = 0.5
        
        UILabel.animate(withDuration: 1.5, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.instructionLabel.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            self.instructionLabel.alpha = 1
        })
        
        
        
        let movingImages = (0...74).compactMap { index -> UIImage? in
             let imageNumber = String(format: "%02d", index)
             return UIImage(named: "bouncingBalls/\(imageNumber)")
        }
        
        let ballsImageView = UIImageView(frame: animationsView!.bounds)
        self.animationsView?.addSubview(ballsImageView)
        
        ballsImageView.animationImages = movingImages
        ballsImageView.animationDuration = 3
        ballsImageView.animationRepeatCount = .max
        ballsImageView.startAnimating()
        
        let lay = CAReplicatorLayer()
        
        lay.frame = CGRect(x: animationsView!.frame.width/2 - 50,y: animationsView!.frame.height/2 - 5,width: 100,height: 10)
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
        self.animationsView?.layer.addSublayer(lay)
        
        
    }
}

//MARK:- Camera extenison
extension MenuViewController: AVCapturePhotoCaptureDelegate{

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        let image = UIImage(data: imageData)
        
        let flippedImage = UIImage(cgImage: image!.cgImage!, scale: image!.scale, orientation: .leftMirrored)
        
        challengeImage.image = flippedImage
        challengeImage.contentMode = .scaleAspectFill
        
        let croppedImage = cropImageFromAspectFill(imageView: challengeImage)
        
        challengeImage.image = croppedImage
        
        
        let foregroundView = UIView(frame: challengeImage.bounds)
        foregroundView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        challengeImage.addSubview(foregroundView)
        
        challengeImage.contentMode = .scaleAspectFit
        challengeImage.isHidden = false
        cameraView?.isHidden = true
        
        
        //classifier?.updateClassifications(for: croppedImage)
        detector?.updateDetections(for: croppedImage)
        //eggGroupBank?.downloadEggGroups()
        
    }
    func cropImageFromAspectFill(imageView: UIImageView) -> UIImage{
        let imsize = imageView.image!.size
        let ivsize = imageView.bounds.size

        var scale : CGFloat = ivsize.width / imsize.width
        if imsize.height * scale < ivsize.height {
            scale = ivsize.height / imsize.height
        }

        let croppedImsize = CGSize(width:ivsize.width/scale, height:ivsize.height/scale)
        let croppedImrect =
            CGRect(origin: CGPoint(x: (imsize.width-croppedImsize.width)/2.0,
                                   y: (imsize.height-croppedImsize.height)/2.0),
                   size: croppedImsize)
        
        let r = UIGraphicsImageRenderer(size:croppedImsize)
        let croppedImage = r.image { _ in
            imageView.image!.draw(at: CGPoint(x:-croppedImrect.origin.x, y:-croppedImrect.origin.y))
        }
        return croppedImage
    }
}


//MARK:- Created Classes Extensions
extension MenuViewController: EggGroupBankDelegate, ObjectDetectorDelegate{
    
    func updateImage(with image: UIImage?) {
        for subview in challengeImage.subviews{
            subview.removeFromSuperview()
        }
        challengeImage.image = image
        challengeImage.isHidden = false
        //pokemonImageView.image = image
        
        AButton.tag = 1
        BButton.tag = 0
        
        self.animationsView?.isHidden = true
    }
    
    func getImage() -> UIImage {
        return challengeImage.image!
    }
    
    func updateImage(from data: Data) {
        if let image = UIImage(data: data){
            
            for subview in challengeImage.subviews{
                subview.removeFromSuperview()
            }
            challengeImage.image = image
            challengeImage.isHidden = false
            //pokemonImageView.image = image
            
            AButton.tag = 1
            BButton.tag = 0
            
            self.animationsView?.isHidden = true
        }
    }
    
    
}

//MARK:- Photo Library extension
extension MenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        
        challengeImage.isHidden = false
        animationsView?.isHidden = true
        BButton.tag = 0
        AButton.tag = 0
        
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        //OBS.: O UIImagePickerController descende do UINavigationController!
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        
        present(picker, animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.navigationController?.dismiss(animated: true)
        // 'image' is the newly cropped version of the original image
        challengeImage.image = image
        challengeImage.contentMode = .scaleAspectFill
        
        let croppedImage = cropImageFromAspectFill(imageView: challengeImage)
        
        challengeImage.image = croppedImage
        
        let foregroundView = UIView(frame: challengeImage.bounds)
        foregroundView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        challengeImage.addSubview(foregroundView)
        
        challengeImage.contentMode = .scaleAspectFit
        challengeImage.isHidden = false
        cameraView?.isHidden = true
        
        //classifier?.updateClassifications(for: image)
        detector?.updateDetections(for: image)
        //eggGroupBank?.downloadEggGroups()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
        let image:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        
        let cropVC = CropViewController(image: image)
        cropVC.delegate = self
        cropVC.doneButtonTitle = "Recortar"
        cropVC.cancelButtonTitle = "Cancelar"
        
        cropVC.setAspectRatioPreset(.preset4x3, animated: true)
        cropVC.aspectRatioLockEnabled = true
        cropVC.resetAspectRatioEnabled = false
        cropVC.aspectRatioPickerButtonHidden = true
        
        picker.pushViewController(cropVC, animated: true)
        
        
        
        
    }
    
    
    
}
