//
//  CurrencyListViewModel.swift
//  CurrencyConversion
//
//  Created by Felipe Morandin on 06/08/2024.
//

import Foundation
import os
import Combine

protocol ExchangeRateQuotesViewModelProtocol {

    func fetchExchangeRateQuotes()
    var exchangeRateQuotesDataPublisher: PassthroughSubject<ExchangeRateQuotesModel, Error> { get }
}

final class ExchangeRateQuotesListViewModel: ExchangeRateQuotesViewModelProtocol {

    // MARK: - Private Variables

    private let service: ExchangeRateQuotesServiceProtocol

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: ExchangeRateQuotesListViewModel.self)
    )

    private var cancellable = Set<AnyCancellable>()

    // MARK: - Public Variables

    var exchangeRateQuotesDataPublisher = PassthroughSubject<ExchangeRateQuotesModel, Error>()

    // MARK: - Init

    init(service: ExchangeRateQuotesServiceProtocol = ExchangeRateQuotesService()) {

        self.service = service
    }

    // MARK: - Public Methods

    func fetchExchangeRateQuotes() {

        service.fetchExchangeRateQuotes()
            .sink { [ weak self ] completion in
                switch completion {
                case .failure(let error):
                    self?.logger.error("\(error)")
                case .finished:
                    self?.logger.info("💶 Currency info received correctly")
                }
            } receiveValue: { [weak self] currency in
                UserDefaultsWrapper().save(values: Array(currency.rates.keys), for: .availableCurrencies)
                self?.exchangeRateQuotesDataPublisher.send(currency)
            }
            .store(in: &cancellable)
    }
}
