//
//  City.swift
//  PerpetioTest
//
//  Created by Steve Vovchyna on 23.01.2020.
//  Copyright © 2020 Steve Vovchyna. All rights reserved.
//

import Foundation
import UIKit

struct City {
    let name: String
    var dates: [[String]] = []
    var picker: [[String]] = []
    
    init(data: String) {
        let stringsArray = data.components(separatedBy: "\n")
        name = stringsArray[0]
        var years: [String] = []
        var months: [Int] = []
        for i in 7..<stringsArray.count {
            var dateEntry = stringsArray[i].components(separatedBy: " ")
            dateEntry = dateEntry.filter { $0 != "" }
            dates.append(dateEntry)
            years.append(dateEntry[0])
            months.append(Int(dateEntry[1])!)
           
        }
        let sortedYears = Array(Set(years)).sorted { $1 < $0 }
        let sortedMonths = Array(Set(months)).sorted { $0 < $1 }
        picker.append(sortedYears)
        picker.append(sortedMonths.map { String($0) })
    }
}
