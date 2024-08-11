//
//  CurrencyConversionServiceMock.swift
//  CurrencyConversionTests
//
//  Created by Felipe Morandin on 11/08/2024.
//

import Foundation
import Combine
@testable import CurrencyConversion

struct CurrencyConversionServiceMock: CurrencyConversionServiceProtocol {

    func fetchAvailableCurrencyList() -> AnyPublisher<[String : String], any Error> {

        let rates: [String: String] = [
            "AUD": "Australian Dollar",
            "BRL": "Brazilian Real",
            "JPY": "Japanese Yen",
            "GBP": "British Pound",
            "USD": "United States Dollar",
            "CAD": "Canadian Dollar"
        ]

        return Just(rates)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func performCurrencyConversion(amount: String, from: String, to: String) -> AnyPublisher<ExchangeRateQuotesModel, any Error> {


        let model = ExchangeRateQuotesModel(base: from, date: "2024-08-11", rates: [to: 25.72])

        return Just(model)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
