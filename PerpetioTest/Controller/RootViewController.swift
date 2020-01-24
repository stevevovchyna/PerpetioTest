//
//  RootViewController.swift
//  PerpetioTest
//
//  Created by Steve Vovchyna on 23.01.2020.
//  Copyright © 2020 Steve Vovchyna. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var cities: [String] = allCities
    var cityToPass: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "cityCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}

extension RootViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        requestCityWeatherData(forCity: cities[indexPath.row]) { result in
            switch result {
            case .failure(let error): DispatchQueue.main.async { presentAlert(text: error, in: self) }
            case .success(let data):
                self.cityToPass = City(data: data)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showWeather", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let city = cityToPass else { return }
        if segue.identifier == "showWeather" {
            let vc = segue.destination as! ViewController
            vc.city = city
        }
    }
}

extension RootViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityTableViewCell
        cell.cityLabel.text = cities[indexPath.row]
        return cell
    }
}

