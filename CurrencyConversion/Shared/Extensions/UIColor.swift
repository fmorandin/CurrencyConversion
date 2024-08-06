//
//  UIColor.swift
//  CurrencyConversion
//
//  Created by Felipe Morandin on 06/08/2024.
//

import UIKit

enum CustomColors {

    case backgroundColor
    case accentColor
}

extension UIColor {

    static func appColor(_ name: CustomColors) -> UIColor {

        switch name {
        case .backgroundColor:
            return UIColor(named: "BackgroundColor") ?? .white
        case .accentColor:
            return UIColor(named: "AccentColor") ?? .black
        }
    }
}
