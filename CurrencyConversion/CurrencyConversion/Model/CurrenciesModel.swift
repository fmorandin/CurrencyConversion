//
//  CurrenciesModel.swift
//  CurrencyConversion
//
//  Created by Felipe Morandin on 10/08/2024.
//

import Foundation

struct CurrenciesModel: Codable {

    // For the list of the currencies we receive from the API just a dictionary with the name and the code for the currency
    let currencies: [String: String]
}
