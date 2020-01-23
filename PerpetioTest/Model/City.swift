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
    var dates: [MonthData] = []
    var picker: [[String]] = []
    
    init(data: String) {
        let stringsArray = data.components(separatedBy: "\n")
        name = stringsArray[0]
        var years: [String] = []
        var months: [Int] = []
        for i in 7..<stringsArray.count {
            var dateEntry = stringsArray[i].components(separatedBy: " ")
            dateEntry = dateEntry.filter { $0 != "" }
            let monthData = MonthData(year: dateEntry[0],
                                      month: dateEntry[1],
                                      tmax: dateEntry[2],
                                      tmin: dateEntry[3],
                                      adDays: dateEntry[4],
                                      rainMM: dateEntry[5],
                                      sunHours: dateEntry[6])
            dates.append(monthData)
            years.append(monthData.year)
            months.append(Int(monthData.month)!)
           
        }
        let sortedYears = Array(Set(years)).sorted { $1 < $0 }
        let sortedMonths = Array(Set(months)).sorted { $0 < $1 }
        picker.append(sortedYears)
        picker.append(sortedMonths.map { String($0) })
    }
}

struct MonthData {
    let year: String
    let month: String
    let tmax: String
    let tmin: String
    let adDays: String
    let rainMM: String
    let sunHours: String
}
