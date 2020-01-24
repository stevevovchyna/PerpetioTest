//
//  Extensions.swift
//  PerpetioTest
//
//  Created by Steve Vovchyna on 24.01.2020.
//  Copyright © 2020 Steve Vovchyna. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func animateTextChange(with text: String) {
        let animation: CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type = .moveIn
        self.text = text
        animation.duration = 0.5
        self.layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
}

extension UIView {
    func shakeView() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.04
        animation.repeatCount = Float.random(in: 2...5)
        animation.autoreverses = true
        let inset = CGFloat.random(in: 2...5)
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - inset, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + inset, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
