//
//  UserDefaultsWrapper.swift
//  CurrencyConversion
//
//  Created by Felipe Morandin on 10/08/2024.
//

import Foundation
import os

enum UserDefaultsKeys: String {

    case availableCurrencies
}

struct UserDefaultsWrapper {

    // MARK: - Private Variables
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: UserDefaultsWrapper.self)
    )

    private let defaults = UserDefaults.standard

    // MARK: - Public Methods

    func save(values: [String], for keyName: UserDefaultsKeys) {

        var stringToBeSaved = ""
        var savedValues = getValues(for: keyName) ?? [String]()

        for value in values {
            if savedValues.contains(where: { $0 == value }) {
                logger.notice("💾 Value \(String(describing: value)) was already saved. Nothing will be saved.")
            } else {
                savedValues.append(value)
                stringToBeSaved = savedValues.joined(separator: ",")
            }
        }

        if stringToBeSaved != "" {
            logger.notice("💾 Saving value \(String(describing: stringToBeSaved)) for the key \(keyName.rawValue).")
            defaults.setValue(stringToBeSaved, forKey: keyName.rawValue)
        } else {
            logger.notice("The string was empty, not saving.")
        }
    }

    func getValues(for keyName: UserDefaultsKeys) -> [String]? {

        let savedString = defaults.string(forKey: keyName.rawValue) ?? ""

        logger.notice("📤 Getting value \(savedString) for the key \(keyName.rawValue).")

        let savedValues = savedString
            .split(separator: ",")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }

        return savedValues.sorted()
    }
}
