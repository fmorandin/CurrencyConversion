//
//  ExchangeRateQuotesListViewModelTests.swift
//  ExchangeRateQuotesListViewModelTests
//
//  Created by Felipe Morandin on 06/08/2024.
//

import XCTest
import Combine
@testable import CurrencyConversion

final class ExchangeRateQuotesListViewModelTests: XCTestCase {

    // MARK: - Private Variables

    private let viewModel = ExchangeRateQuotesListViewModel(service: ExchangeRateQuotesServiceMock())
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Tests

    func test_fetchExchangeRateQuotes() {

        viewModel.fetchExchangeRateQuotes()

        viewModel.exchangeRateQuotesDataPublisher
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case .failure(_):
                    XCTFail("This should not happen")
                }
            } receiveValue: { result in
                XCTAssertEqual(result.base, "GPB")
                XCTAssertEqual(result.date, "2024-08-11")
                XCTAssertEqual(result.rates.count, 6)
            }
            .store(in: &cancellables)
    }
}
