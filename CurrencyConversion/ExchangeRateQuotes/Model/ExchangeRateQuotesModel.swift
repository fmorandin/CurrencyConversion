//
//  ExchangeRateQuotesModel.swift
//  CurrencyConversion
//
//  Created by Felipe Morandin on 06/08/2024.
//

import Foundation

// This model is shared with the currency converter so, ideally, it would be moved to a more generic place
struct ExchangeRateQuotesModel: Codable {

    let base: String
    let date: String
    let rates: [String: Double]
}
