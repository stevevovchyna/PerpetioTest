//
//  ViewController.swift
//  PerpetioTest
//
//  Created by Steve Vovchyna on 23.01.2020.
//  Copyright © 2020 Steve Vovchyna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var cityNameView: UIView!
    @IBOutlet weak var maxTView: UIView!
    @IBOutlet weak var minTView: UIView!
    @IBOutlet weak var rainView: UIView!
    @IBOutlet weak var sunView: UIView!
    @IBOutlet weak var afView: UIView!
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var maxTLabel: UILabel!
    @IBOutlet weak var minTLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var sunLabel: UILabel!
    @IBOutlet weak var afLabel: UILabel!

    var pickerData: [[String]] = [[String]]()
    var city: City?
    let blurEffect = UIBlurEffect(style: .regular)
    let blurEffectView = UIVisualEffectView()
  
    // MARK:- view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        self.picker.delegate = self
        self.picker.dataSource = self
        
        guard let city = city else { return }
        pickerData = city.picker
        
        cityNameLabel.text = city.name
        
        let views: [UIView] = [cityNameView, maxTView, minTView, rainView, sunView, afView]
        for view in views { view.layer.cornerRadius = 10 }
        
        blurEffectView.effect = blurEffect
        blurEffectView.frame = blurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.addSubview(blurEffectView)
        blurView.addSubview(infoLabel)
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}

// MARK:- pickerView delegate methods
extension ViewController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
}

// MARK:- pickerView data source methods
extension ViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let city = city else { return }
        let result = findEntry(in: city,
                               year: pickerData[0][pickerView.selectedRow(inComponent: 0)],
                               month: pickerData[1][pickerView.selectedRow(inComponent: 1)])
        setLabels(with: result)
        if blurEffectView.effect != nil {
            UIView.animate(withDuration: 1) {
                self.blurEffectView.effect = nil
                self.infoLabel.removeFromSuperview()
            }
        }
    }
}

// MARK:- private methods
extension ViewController {    
    func setLabels(with data: MonthData) {
        let month = DateFormatter().monthSymbols[Int(data.month)! - 1]
        dateLabel.animateTextChange(with: "\(month) \(data.year)")
        maxTLabel.animateTextChange(with: data.tmax)
        minTLabel.animateTextChange(with: data.tmin)
        rainLabel.animateTextChange(with: data.rainMM)
        sunLabel.animateTextChange(with: data.sunHours)
        afLabel.animateTextChange(with: data.adDays)
    }
    
    func findEntry(in city: City, year: String, month: String) -> MonthData {
        let result = city.dates.filter { $0.year == year && $0.month == month }
        return result[0]
    }
}

