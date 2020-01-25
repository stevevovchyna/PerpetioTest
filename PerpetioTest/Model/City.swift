//
//  City.swift
//  PerpetioTest
//
//  Created by Steve Vovchyna on 23.01.2020.
//  Copyright © 2020 Steve Vovchyna. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct City {
    let name: String
    var dates: [MonthData] = []
    var picker: [[String]] = []
    var info: [String] = []
    var location: Location?
    
    init(data: String) {
        var stringsArray = data.components(separatedBy: "\n")
        name = stringsArray[0]
        var years: [String] = []
        var months: [Int] = []
        
        if let end = findInArray("Site closed", in: stringsArray) { stringsArray.remove(at: end) }
        guard let index = findInArray("yyyy", in: stringsArray) else { return }
        for i in 1..<index { info.append(String(stringsArray[i].filter{!"\n\t\r".contains($0)})) }

        if let coordinates = findLocation(in: stringsArray, with: index) {
            location = Location(title: name, subtitle: "", coordinate: coordinates)
        }
        
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
    
    private func findLocation(in stringsArray: [String], with index: Int) -> CLLocationCoordinate2D? {
        var infoArray: [String] = []
        for i in 1..<index {
            let elements = String(stringsArray[i].filter{!"\n\t\r".contains($0)}).components(separatedBy: " ")
            for el in elements { infoArray.append(el) }
        }
        if let latStringIndex = findInArray("Lat", in: infoArray),
            let lonStringIndex = findInArray("Lon", in: infoArray),
            let lon = Double(String(infoArray[lonStringIndex + 1].filter{!",".contains($0)})),
            let lat = Double(String(infoArray[latStringIndex + 1].filter{!",".contains($0)})) {
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        } else { return nil }
    }
    
    private func findInArray(_ text: String, in array: [String]) -> Int? {
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

class Location: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title : String?
    var subtitle : String?
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
