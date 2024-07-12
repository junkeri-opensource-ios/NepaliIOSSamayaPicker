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
       
        let pickerView = NepaliDatePickerView()
        pickerView.backgroundColor = .white
        view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pickerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }
}
