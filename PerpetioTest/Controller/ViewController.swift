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
        setLabelsToDefault(for: city)
        
        blurSetUp()
        hideHint()
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
        blurOff()
        guard let city = city else { return }
        let year = pickerData[0][pickerView.selectedRow(inComponent: 0)]
        let month = pickerData[1][pickerView.selectedRow(inComponent: 1)]
        if let chosenDate = findEntry(in: city, year: year, month: month) {
            setLabels(with: chosenDate)
        } else {
            presentAlert(text: "Sorry, there's no data for the set date", in: self)
            setLabelsToDefault(for: city)
            pickerView.selectRow(0, inComponent: 0, animated: true)
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }
    }
}

// MARK:- private methods
extension ViewController {
    private func setLabelsToDefault(for city: City) {
        guard let chosenDate = findEntry(in: city, year: pickerData[0][0], month: pickerData[1][0]) else { return }
        setLabels(with: chosenDate)
    }
    
    private func setLabels(with data: MonthData) {
        let month = DateFormatter().monthSymbols[Int(data.month)! - 1]
        dateLabel.animateTextChange(with: "\(month) \(data.year)")
        maxTLabel.animateTextChange(with: "\(data.tmax) ℃")
        minTLabel.animateTextChange(with: "\(data.tmin) ℃")
        rainLabel.animateTextChange(with: "\(data.rainMM) mm")
        sunLabel.animateTextChange(with: "\(data.sunHours) hrs")
        afLabel.animateTextChange(with: "\(data.adDays) days")
    }
    
    private func findEntry(in city: City, year: String, month: String) -> MonthData? {
        let result = city.dates.filter { $0.year == year && $0.month == month }
        guard result.count > 0 else { return nil }
        return result[0]
    }
    
    private func blurSetUp() {
        blurEffectView.effect = UIBlurEffect(style: .regular)
        blurEffectView.frame = blurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.addSubview(blurEffectView)
        blurView.addSubview(infoLabel)
    }
    
    private func blurOff() {
        if self.blurEffectView.effect != nil {
            UIView.animate(withDuration: 1) {
                self.blurEffectView.effect = nil
                self.infoLabel.removeFromSuperview()
            }
        }
    }
    
    private func hideHint() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.blurOff()
        }
    }
}

