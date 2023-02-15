//
//  CommonHelper.swift
//  iOS-AsteroidNeo
//
//  Created by Deep Baath on 12/02/23.
//

import UIKit

enum AsteroidSpeed {
    case none
    case Fastest
    case Closest
    case Average
}

extension UIColor {
    static let chartBarColour = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    static let chartLineColour = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    static let chartReplacementColour = #colorLiteral(red: 0.9284809232, green: 0, blue: 0, alpha: 1)
    static let chartAverageColour = #colorLiteral(red: 0, green: 0.5830174685, blue: 0, alpha: 1)
    static let chartBarValueColour = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
    static let chartHightlightColour = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
}

extension UIView {
    func setCornerRadius(radius: CGFloat, borderColor: UIColor) {
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }
}


struct FilterdAsteroidModel {
    var asteroidID: String
    var speed: Double?
    var distance: Double?
    var type: AsteroidSpeed
}


