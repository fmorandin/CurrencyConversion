//
//  NetworkManager.swift
//  CurrencyConversion
//
//  Created by Felipe Morandin on 06/08/2024.
//

import Foundation
import os
import Combine

// Protocol to make it easier to test
protocol NetworkManagerProtocol {
    func getData<T: Decodable>(for urlString: String, responseModel: T.Type) -> AnyPublisher<T, Error>
}

// Enum that will hold the possible error cases
enum ErrorCases: Error {

    case invalidUrl, genericError, unauthorized, decode, requestError, forbidden
}

struct NetworkManager: NetworkManagerProtocol {

    // MARK: - Private Variables

    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: NetworkManager.self)
    )

    // MARK: - Public Methods

    func getData<T: Decodable>(for urlString: String, responseModel: T.Type) -> AnyPublisher<T, Error> {

        logger.notice("🛜 Starting the request.")

        guard let url = URL(string: urlString) else { return Fail(error: ErrorCases.invalidUrl).eraseToAnyPublisher() }

        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { error in
                Fail(error: error).eraseToAnyPublisher()
            }
            .map { $0.data }
            .decode(type: responseModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
