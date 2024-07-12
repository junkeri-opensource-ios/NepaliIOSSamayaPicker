//
//  NepaliDate.swift
//  NepaliIOSSamayaPicker
//
//  Created by swornim-shah on 12/07/2024.
//

import Foundation

public struct NepaliDateModel {
    public let year: String
    public let month: String
    public let day: String
    
    public init(year: String, month: String, day: String) {
        self.year = year
        self.month = month
        self.day = day
    }
}
