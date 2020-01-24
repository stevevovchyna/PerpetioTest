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
        var stringsArray = data.components(separatedBy: "\n")
        name = stringsArray[0]
        var years: [String] = []
        var months: [Int] = []
        if let end = find("Site closed", in: stringsArray) { stringsArray.remove(at: end) }
        guard let index = find("yyyy", in: stringsArray) else { return }
        for i in index + 2..<stringsArray.count {
            var dateEntry = stringsArray[i].components(separatedBy: " ")
            dateEntry = dateEntry.filter { $0 != "" }
            if dateEntry.count > 0 {
                let monthData = MonthData(year: String(dateEntry[0].filter{!"\n\t\r".contains($0)}),
                                          month: String(dateEntry[1].filter{!"\n\t\r".contains($0)}),
                                          tmax: String(dateEntry[2].filter{!"\n\t\r".contains($0)}),
                                          tmin: String(dateEntry[3].filter{!"\n\t\r".contains($0)}),
                                          adDays: String(dateEntry[4].filter{!"\n\t\r".contains($0)}),
                                          rainMM: String(dateEntry[5].filter{!"\n\t\r".contains($0)}),
                                          sunHours: String(dateEntry[6].filter{!"\n\t\r".contains($0)}))
                dates.append(monthData)
                years.append(monthData.year)
                months.append(Int(monthData.month)!)
            }
        }
        let sortedYears = Array(Set(years)).sorted { $1 < $0 }
        let sortedMonths = Array(Set(months)).sorted { $0 < $1 }
        picker.append(sortedYears)
        picker.append(sortedMonths.map { String($0) })
    }
    
    private func find(_ text: String, in array: [String]) -> Int? {
        for i in 0..<array.count {
            if array[i].contains(text) { return i }
        }
        return nil
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
