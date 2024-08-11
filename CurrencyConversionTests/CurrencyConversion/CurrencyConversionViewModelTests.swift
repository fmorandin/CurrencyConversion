//
//  CurrencyConversionViewModelTests.swift
//  CurrencyConversionTests
//
//  Created by Felipe Morandin on 11/08/2024.
//

import XCTest
import Combine
@testable import CurrencyConversion

final class CurrencyConversionViewModelTests: XCTestCase {

    // MARK: - Private Variables

    private let viewModel = CurrencyConversionViewModel(service: CurrencyConversionServiceMock())
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Tests

    func test_fetchCurrencyList() {

        viewModel.fetchCurrencyList()

        viewModel.currencyListDataPublisher
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case .failure(_):
                    XCTFail("This should not happen")
                }
            } receiveValue: { currencyList in
                XCTAssertEqual(currencyList.count, 6)
            }
            .store(in: &cancellables)
    }

    func test_performConversion() {

        viewModel.performConversion(amount: "20", from: "GPB", to: "USD")

        viewModel.currencyConversionDataPublisher
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case .failure(_):
                    XCTFail("This should not happen")
                }
            } receiveValue: { converted in
                XCTAssertEqual(converted.base, "GPB")
                XCTAssertEqual(converted.date, "2024-08-11")
                XCTAssertEqual(converted.rates.count, 5)
                XCTAssertEqual(converted.rates["USD"], 25.72)
            }
            .store(in: &cancellables)
    }
}
