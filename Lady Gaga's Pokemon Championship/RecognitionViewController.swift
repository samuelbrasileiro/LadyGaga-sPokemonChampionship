//
//  RecognitionViewController.swift
//  Lady Gaga's Pokemon Championship
//
//  Created by Samuel Brasileiro on 27/08/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit

class RecognitionViewController: UIViewController {
    
    @IBOutlet var pokeName: UILabel!
    
    var eggGroupBank: EggGroupBank?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eggGroupBank = EggGroupBank()
        load()
        
    }
    
    func load(){
        
    }
    
    
}
