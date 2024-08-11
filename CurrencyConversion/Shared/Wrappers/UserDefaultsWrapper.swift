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
    case isCurrencyListFetched
}

struct UserDefaultsWrapper {

    // MARK: - Private Variables
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: UserDefaultsWrapper.self)
    )

    private let defaults = UserDefaults.standard

    // MARK: - Public Methods

    // By creating these functions I can use a descriptive name and create the necessary overloads for
    // helping while saving and reading from UserDefaults

    func save(values: [String: String], for keyName: UserDefaultsKeys) {

        logger.notice("💾 Saving values \(String(describing: values)) for the key \(keyName.rawValue).")
        defaults.set(values, forKey: keyName.rawValue)
    }

    func save(value: Bool, for keyName: UserDefaultsKeys) {

        logger.notice("💾 Saving value \(value) for the key \(keyName.rawValue).")
        defaults.setValue(value, forKey: keyName.rawValue)
    }

    func getValues(for keyName: UserDefaultsKeys) -> [String: String]? {

        let savedDictionary = defaults.object([String: String].self, with: keyName.rawValue)
        logger.notice("📤 Getting value \(String(describing: savedDictionary?.debugDescription)) for the key \(keyName.rawValue).")
        return savedDictionary
    }

    func getValue(for keyName: UserDefaultsKeys) -> Bool {

        let savedBool = defaults.bool(forKey: keyName.rawValue)
        logger.notice("📤 Getting value \(savedBool) for the key \(keyName.rawValue).")
        return savedBool
    }
}

// MARK: - Extension

// This extension allows me to save and read a Dictionary from UserDefaults.
// Since the Dictionary conforms to the codable protocol we can encode them and save it (or read it) to UserDefaults
extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {

        guard let data = self.value(forKey: key) as? Data else { return nil }

        return try? decoder.decode(type.self, from: data)
    }

    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {

        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}
