//
//  Networking.swift
//  PerpetioTest
//
//  Created by Steve Vovchyna on 23.01.2020.
//  Copyright © 2020 Steve Vovchyna. All rights reserved.
//

import Foundation
import UIKit

let allCities = ["Aberporth", "Armagh", "Ballypatrick Forest", "Bradford", "Braemar", "Camborne", "Cambridge", "Cardiff Bute Park", "Chivenor", "Cwmystwyth", "Dunstaffnage", "Durham", "Eastbourne", "Eskdalemuir", "Heathrow", "Hurn", "Lerwick", "Leuchars", "Lowestoft", "Manston", "Nairn", "Newton Rigg", "Oxford", "Paisley", "Ringway", "Ross-on-Wye", "Shawbury", "Sheffield", "Southampton", "Stornoway Airport", "Sutton Bonington", "Tiree", "Valley", "Waddington", "Whitby", "Wick Airport", "Yeovilton"]

enum Result<T> {
    case success(T)
    case failure(String)
}

func requestCityWeatherData(forCity cityName: String, completion: @escaping (Result<String>) -> Void) {
    let city = cityNameCleanUp(cityName)
    let urlBase = "https://www.metoffice.gov.uk/pub/data/weather/uk/climate/stationdata/\(city)data.txt"
    let url = URL(string: urlBase)!
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            return completion(.failure(error.localizedDescription))
        }
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            return completion(.failure("Server error"))
        }
        guard let data = data, let resultString = String(data: data, encoding: .utf8) else { return completion(.failure("There was an issue with the returned data")) }
        completion(.success(resultString))
    }.resume()
}
