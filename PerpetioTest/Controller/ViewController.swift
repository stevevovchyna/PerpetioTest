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
    var pickerData: [[String]] = [[String]]()
    var city: City?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        self.picker.delegate = self
        self.picker.dataSource = self
        guard let city = city else { return }
        pickerData = city.picker
        // Do any additional setup after loading the view.
    }


}

extension ViewController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
}

extension ViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let city = city else { return }
        let year = pickerData[0][pickerView.selectedRow(inComponent: 0)]
        let month = pickerData[1][pickerView.selectedRow(inComponent: 1)]
        let result = city.dates.filter { $0.year == year && $0.month == month }
        print(year, month, result)
    }
}

