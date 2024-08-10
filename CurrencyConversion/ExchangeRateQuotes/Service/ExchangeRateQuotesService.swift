//
//  ExchangeRateQuotesService.swift
//  CurrencyConversion
//
//  Created by Felipe Morandin on 06/08/2024.
//

import Foundation
import os
import Combine

protocol ExchangeRateQuotesServiceProtocol {
    func fetchExchangeRateQuotes() -> AnyPublisher<ExchangeRateQuotesModel, Error>
}

struct ExchangeRateQuotesService: ExchangeRateQuotesServiceProtocol {

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

    func fetchExchangeRateQuotes() -> AnyPublisher<ExchangeRateQuotesModel, Error> {

        logger.notice("🛜 Starting to fetch the currency data.")

        return networkManager.getData(for: Endpoints.latest.rawValue, responseModel: ExchangeRateQuotesModel.self)
    }
}
