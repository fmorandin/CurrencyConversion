//
//  CurrencyConversionViewModel.swift
//  CurrencyConversion
//
//  Created by Felipe Morandin on 10/08/2024.
//

import Foundation
import os
import Combine

protocol CurrencyConversionViewModelProtocol {

    func fetchCurrencyList()
    var currencyListDataPublisher: PassthroughSubject<[String: String], Error> { get }
    func performConversion(amount: String, from: String, to: String)
    var currencyConversionDataPublisher: PassthroughSubject<ExchangeRateQuotesModel, Error> { get }
}

final class CurrencyConversionViewModel: CurrencyConversionViewModelProtocol {

    // MARK: - Private Variables

    private let service: CurrencyConversionServiceProtocol

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: CurrencyConversionViewModel.self)
    )

    private var cancellable = Set<AnyCancellable>()

    // MARK: - Public Variables

    var currencyListDataPublisher = PassthroughSubject<[String: String], Error>()
    var currencyConversionDataPublisher = PassthroughSubject<ExchangeRateQuotesModel, Error>()

    // MARK: - Init

    init(service: CurrencyConversionServiceProtocol = CurrencyConversionService()) {

        self.service = service
    }

    // MARK: - Public Methods

    func fetchCurrencyList() {

        service.fetchAvailableCurrencyList()
            .sink { [ weak self ] completion in
                switch completion {
                case .failure(let error):
                    self?.logger.error("\(error)")
                case .finished:
                    self?.logger.info("💶 List of available currencies received correctly")
                }
            } receiveValue: { [weak self] currencyList in
                self?.currencyListDataPublisher.send(currencyList)
            }
            .store(in: &cancellable)
    }

    func performConversion(amount: String, from: String, to: String) {

        service.performCurrencyConversion(amount: amount, from: from, to: to)
            .sink { [ weak self ] completion in
                switch completion {
                case .failure(let error):
                    self?.logger.error("\(error)")
                case .finished:
                    self?.logger.info("💶 Currency converted information received correctly")
                }
            } receiveValue: { [weak self] currencyConverted in
                self?.currencyConversionDataPublisher.send(currencyConverted)
            }
            .store(in: &cancellable)
    }
}
