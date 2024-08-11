//
//  CurrencyConversionService.swift.swift
//  CurrencyConversion
//
//  Created by Felipe Morandin on 10/08/2024.
//

import Foundation
import Combine
import os

protocol CurrencyConversionServiceProtocol {

    func fetchAvailableCurrencyList() -> AnyPublisher<[String: String], Error>
    func performCurrencyConversion(amount: String, from: String, to: String) -> AnyPublisher<ExchangeRateQuotesModel, Error>
}

struct CurrencyConversionService: CurrencyConversionServiceProtocol {

    // MARK: - Private Variables

    private var networkManager: NetworkManagerProtocol

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: ExchangeRateQuotesService.self)
    )

    // MARK: - Init

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {

        self.networkManager = networkManager
    }

    // MARK: - Public Methods

    func fetchAvailableCurrencyList() -> AnyPublisher<[String: String], Error> {

        logger.notice("🛜 Starting to fetch the list currencies data.")

        return networkManager.getData(for: Endpoints.currencies.rawValue, responseModel: [String: String].self)
    }

    func performCurrencyConversion(amount: String, from: String, to: String) -> AnyPublisher<ExchangeRateQuotesModel, Error> {

        logger.notice("🛜 Starting to perform the currency conversion.")

        let stringURL = "\(Endpoints.latest.rawValue)?amount=\(amount)&from=\(from)&to=\(to)"

        return networkManager.getData(for: stringURL, responseModel: ExchangeRateQuotesModel.self)
    }
}
