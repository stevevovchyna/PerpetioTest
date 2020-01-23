//
//  Utils.swift
//  PerpetioTest
//
//  Created by Steve Vovchyna on 23.01.2020.
//  Copyright © 2020 Steve Vovchyna. All rights reserved.
//

import Foundation
import UIKit

func presentAlert(text: String, in view: UIViewController) {
    let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
    view.present(alert, animated: true, completion: nil)
}

func cityNameCleanUp(_ city: String) -> String {
    let occurences = [" ", "-", "Forest", "ButePark", "Airport"]
    var result = city
    for occ in occurences {
        result = result.replacingOccurrences(of: occ, with: "")
    }
    result = result.lowercased() == "wick" ? "wickairport" : result.lowercased()
    return result
}
