//
//  ExchangeRateQuotesServiceMock.swift
//  CurrencyConversionTests
//
//  Created by Felipe Morandin on 11/08/2024.
//

import Foundation
import Combine
@testable import CurrencyConversion

struct ExchangeRateQuotesServiceMock: ExchangeRateQuotesServiceProtocol {

    func fetchExchangeRateQuotes() -> AnyPublisher<ExchangeRateQuotesModel, any Error> {

        let rates: [String: Double] = [
            "AUD": 1.6609,
            "BRL": 6.0477,
            "JPY": 160.33,
            "GBP": 0.85708,
            "USD": 1.0917,
            "CAD": 1.5007
        ]

        let exchangeRateQuotesModel = ExchangeRateQuotesModel(base: "EUR", date: "2024-08-11", rates: rates)

        return Just(exchangeRateQuotesModel)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
