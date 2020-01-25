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
    
    let status = UIActivityIndicatorView()

    // MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CityTableViewCell", bundle: nil), forCellReuseIdentifier: "cityCell")
        addStatusLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}

//MARK:- tableView delegate methods
extension RootViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeTableViewAcessibility(toActive: false, forRowAt: indexPath, in: tableView, in: status)
        tableView.deselectRow(at: indexPath, animated: true)
        requestCityWeatherData(forCity: cities[indexPath.row]) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.changeTableViewAcessibility(toActive: true, forRowAt: indexPath, in: tableView, in: self.status)
                    presentAlert(text: error, in: self)
                }
            case .success(let data):
                let city = City(data: data)
                DispatchQueue.main.async {
                    self.changeTableViewAcessibility(toActive: true, forRowAt: indexPath, in: tableView, in: self.status)
                    if city.dates.count > 0 {
                        self.cityToPass = city
                        self.performSegue(withIdentifier: "showWeather", sender: self)
                    } else { presentAlert(text: "Error getting city data", in: self) }
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


//MARK:- tableView data source methods
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

//MARK:- private methods
extension RootViewController {
    private func addStatusLabel() {
        status.frame = CGRect(x: (view.frame.size.width - 75) / 2, y:  (view.frame.size.height - 75) / 2, width: 75, height: 75)
        status.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 0.3102793237)
        status.layer.cornerRadius = 10
        status.style = .large
        self.view.addSubview(status)
    }
    
    private func changeTableViewAcessibility(toActive trigger: Bool, forRowAt row : IndexPath, in tableView: UITableView, in status: UIActivityIndicatorView) {
        status.isHidden = trigger
        trigger ? status.stopAnimating() : status.startAnimating()
        if trigger { tableView.deselectRow(at: row, animated: true) }
        tableView.isUserInteractionEnabled = trigger
    }
}

