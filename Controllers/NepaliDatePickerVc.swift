//
//  NepaliDatePickerVc.swift
//  NepaliIOSSamayaPicker
//
//  Created by swornim-shah on 12/07/2024.
//

import UIKit

public final class NepaliDatePickerViewController: UIViewController {
    
    public typealias Action = (Date) -> Void
    
    fileprivate var action: SelectedDate?
        
    public lazy var datePicker = NepaliDatePickerView()
    
    public required init(date: Date? = nil, minimumDate: Date? = nil, maximumDate: Date? = nil, action: SelectedDate? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        if maximumDate?.isInToday == true { datePicker.disableFutureDate = true }
        
        self.action = action
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = datePicker
    }
}


