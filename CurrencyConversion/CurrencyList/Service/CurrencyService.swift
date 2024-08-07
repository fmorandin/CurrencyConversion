//
//  CurrencyService.swift
//  CurrencyConversion
//
//  Created by Felipe Morandin on 06/08/2024.
//

import Foundation
import os
import Combine

protocol CurrencyServiceProtocol {
    func fetchCurrency() -> AnyPublisher<CurrencyModel, Error>
}

struct CurrencyService: CurrencyServiceProtocol {

    // MARK: - Private Variables

    private var networkManager: NetworkManagerProtocol

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: CurrencyService.self)
    )

    // MARK: - Init

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {

        self.networkManager = networkManager
    }

    // MARK: - Public Methods

    func fetchCurrency() -> AnyPublisher<CurrencyModel, Error> {

        let stringURL = "https://api.frankfurter.app/latest"

        logger.notice("🛜 Starting to fetch the currency data.")

        return networkManager.getData(for: stringURL, responseModel: CurrencyModel.self)
    }
}
