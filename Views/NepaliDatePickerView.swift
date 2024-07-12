//
//  NepaliDatePickerView.swift
//  NepaliIOSSamayaPicker
//
//  Created by swornim-shah on 12/07/2024.
//

import UIKit
import Foundation

public typealias SelectedDate = (NepaliDateModel, Date?) -> Void

public class NepaliDatePickerView: UIView {
    
    fileprivate lazy var datePicker: UIPickerView = { [unowned self] in
        return $0
    }(UIPickerView())
    
    fileprivate var action: SelectedDate?
    
    fileprivate lazy var nepaliDataSource = getDateDataSource()
    fileprivate final lazy var monthsInYearDict = nepaliDataSource.monthsInYearDict()

    fileprivate final let currentYearInEnglish = Calendar.current.component(.year, from: Date())
    fileprivate final lazy var yearMonthsData: [Int] = Array(nepaliDataSource.monthsInYearDict().keys).sorted()
    fileprivate final let daysData: [Int] = Array(1...32)
    fileprivate final var nepaliDaysData: [String] {
        return Array(1...32).map({ (value) -> String in
            getNumber(number: value)
        })
    }
    
    fileprivate final var nepaliYearData: [String] {
        return Array(nepaliDataSource.monthsInYearDict().keys).sorted().map({ (value) -> String in
            getNumber(number: value)
        })
    }
        
    fileprivate var selectedYear: Int?
    fileprivate var selectedMonth: Int?
    fileprivate var selectedDay: Int?
    
    fileprivate var startingNepaliYear = 2000
    fileprivate var startingNepaliMonth = 1
    fileprivate var startingNepaliDay = 1
    
    fileprivate var currentNepaliDate: DateModel?
    
    public var setDefaultDateSelection = false {
        didSet {
            if isDateChanged { return }
            guard let selectedYear = selectedYear, let selectedMonth = selectedMonth, let selectedDay = selectedDay else { return }
            
            let state = fetchCurrentSelectedDateState(selectedYear: selectedYear, selectedMonth: selectedMonth, selectedDay: selectedDay)
            action?(state.0, state.1)
        }
    }
    
    public var isDateChanged: Bool = false
    fileprivate lazy var monthSource = nepaliDataSource.getMonths()
    
    public var disableFutureDate: Bool = false
    
    private var daysInMonth = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    private var daysInMonthOfLeapYear = [0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func setupViews() {
        self.addSubview(self.datePicker)
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.datePicker.dataSource = self
        self.datePicker.delegate = self
        
        NSLayoutConstraint.activate([
            self.datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.datePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.datePicker.heightAnchor.constraint(equalToConstant: 216)
        ])
        
        let currentEnglishDate = Date()
        currentNepaliDate = DateConverter().getNepaliDate(englishDate: DateModel(year: currentEnglishDate.year, month: currentEnglishDate.month, day: currentEnglishDate.day))
        
        print("Current nepali date \(currentNepaliDate?.year ?? 0), \(currentNepaliDate?.month ?? 0), \(currentNepaliDate?.day ?? 0)")
        
        if let currentNepaliDate = currentNepaliDate {
            self.datePicker.selectRow(currentNepaliDate.year % 100, inComponent: 0, animated: false)
            self.datePicker.selectRow(currentNepaliDate.month - 1, inComponent: 1, animated: false)
            self.datePicker.selectRow(currentNepaliDate.day - 1, inComponent: 2, animated: false)
        }
        
        //setup initially selected date
        let selectedYearRow = self.datePicker.selectedRow(inComponent: 0)
        let selectedMonthRow = self.datePicker.selectedRow(inComponent: 1)
        let selectedDayRow = self.datePicker.selectedRow(inComponent: 2)
        
        self.selectedYear = self.yearMonthsData[selectedYearRow]
        self.selectedMonth = (selectedMonthRow + 1)
        self.selectedDay = self.daysData[selectedDayRow]
    }

}

extension NepaliDatePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return monthsInYearDict.count
        } else if component == 1 {
            return 12
        } else {
            guard let selectedYear = selectedYear, let selectedMonth = selectedMonth, let selectedMonths = monthsInYearDict.first(where: { $0.key == selectedYear })?.value as? [Int], selectedMonth < selectedMonths.count else { return 32 }
            
            return selectedMonths[selectedMonth]
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return nepaliYearData[row]
        } else if component == 1 {
            return monthSource[row]
        } else {
            return self.nepaliDaysData[row]
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.isDateChanged = true
        
        switch component {
        case 0:
            self.selectedYear = self.yearMonthsData[row]
        case 1:
            self.selectedMonth = (row + 1)
        case 2:
            self.selectedDay = self.daysData[row]
        default:
            break
        }
        
        guard let selectedYear = self.selectedYear, let selectedMonth = self.selectedMonth, let selectedDay = self.selectedDay else { return }
        
        // MARK: refresh days
        if component != 2 { datePicker.reloadComponent(2) }
        
        let selectedDateState = fetchCurrentSelectedDateState(selectedYear: selectedYear, selectedMonth: selectedMonth, selectedDay: selectedDay)
        self.action?(selectedDateState.0, selectedDateState.1)
    }
    
    public func getNumber(number: Int) -> String {
        
        let numberStr = "\(number)"
        
        let nepaliStrArr = numberStr.map { (char) -> String in
            
            let charStr = "\(char)"
            if let index = Int(charStr) {
                return nepaliDataSource.digits[index]
            } else {
                return charStr
            }
        }
        
        return nepaliStrArr.joined()
    }
    
    func fetchCurrentSelectedDateState(selectedYear: Int, selectedMonth: Int, selectedDay: Int) -> (NepaliDateModel, Date?) {
        let correspondingEnglishDate = DateConverter().getEnglishDate(nepaliDate: DateModel(year: selectedYear, month: selectedMonth, day: selectedDay))
        
        return (NepaliDateModel(year: selectedYear.description, month: String(format: "%02d", selectedMonth), day: String(format: "%02d", selectedDay)), correspondingEnglishDate)
    }
}

// MARK: Date data source
extension NepaliDatePickerView {
    private func getDateDataSource() -> DateDataSource {
        return DateDataSource.init()
    }
}
