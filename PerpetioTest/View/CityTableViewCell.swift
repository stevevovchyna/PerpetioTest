//
//  CityTableViewCell.swift
//  PerpetioTest
//
//  Created by Steve Vovchyna on 23.01.2020.
//  Copyright © 2020 Steve Vovchyna. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cityView.layer.cornerRadius = 10
        cityView.layer.shadowColor = UIColor.black.cgColor
        cityView.layer.shadowRadius = 2.0
        cityView.layer.shadowOpacity = 0.5
        cityView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cityView.backgroundColor = UIColor(red: 0.125, green: 0.388, blue: 0.607, alpha: 0.6)
    }
    
}
