//
//  ExchangeRateQuotesModel.swift
//  CurrencyConversion
//
//  Created by Felipe Morandin on 06/08/2024.
//

import Foundation

struct ExchangeRateQuotesModel: Codable {

    let base: String
    let date: String
    let rates: [String: Double]
}
