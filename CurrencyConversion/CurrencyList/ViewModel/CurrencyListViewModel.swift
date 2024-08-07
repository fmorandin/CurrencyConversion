//
//  CurrencyListViewModel.swift
//  CurrencyConversion
//
//  Created by Felipe Morandin on 06/08/2024.
//

import Foundation
import os
import Combine

protocol CurrencyListViewModelProtocol {

    func fetchCurrencies()
    var currencyDataPublisher: PassthroughSubject<CurrencyModel, Error> { get }
}

final class CurrencyListViewModel: CurrencyListViewModelProtocol {

    // MARK: - Private Variables

    private let service: CurrencyServiceProtocol

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: CurrencyListViewModel.self)
    )

    private var cancellable = Set<AnyCancellable>()

    // MARK: - Public Variables

    var currencyDataPublisher = PassthroughSubject<CurrencyModel, Error>()

    // MARK: - Init

    init(service: CurrencyServiceProtocol = CurrencyService()) {

        self.service = service
    }

    // MARK: - Public Methods

    func fetchCurrencies() {

        service.fetchCurrency()
            .sink { [ weak self ] completion in
                switch completion {
                case .failure(let error):
                    self?.logger.error("\(error)")
                case .finished:
                    self?.logger.info("💶 Currency info received correctly")
                }
            } receiveValue: { [weak self] currency in
                self?.currencyDataPublisher.send(currency)
            }
            .store(in: &cancellable)
    }
}
