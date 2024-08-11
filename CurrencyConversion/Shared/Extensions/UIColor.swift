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

// This extension is used in order to make it easier to use colors from the Assets.xcassets and also
// to keep the call site as clean as possible making easier to read the code. The drawback for that is that this
// can grow a lot depending on the size of the app.
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
