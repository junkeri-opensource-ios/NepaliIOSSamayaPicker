//
//  ViewController.swift
//  NepaliIOSSamayaPicker
//
//  Created by junkeritechnepal@gmail.com on 07/12/2024.
//  Copyright (c) 2024 junkeritechnepal@gmail.com. All rights reserved.
//

import UIKit
import NepaliIOSSamayaPicker

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let picker = NepaliIOSSamayaVc()
        navigationController?.pushViewController(picker, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

