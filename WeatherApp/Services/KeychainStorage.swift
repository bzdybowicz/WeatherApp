//
//  KeychainStorage.swift
//  WeatherApp
//
//  Created by Bartlomiej Zdybowicz on 27/10/2023.
//

import Foundation

protocol ApiKeyStorageProtocol {
    func saveApiKey(_ key: String) throws
    func getKey() throws -> String?
    func deleteKey()
}

final class ApiKeyStorage: ApiKeyStorageProtocol {

    func saveApiKey(_ key: String) throws {
        let data = try JSONEncoder().encode(key)
        let query: [CFString: Any] = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: "OpenWeatherKey",
            kSecAttrAccount: "WeatherApp"
        ]
        let saveStatus = SecItemAdd(query as CFDictionary, nil)
        if saveStatus != errSecSuccess {
            print("Error: \(saveStatus)")
        }
    }

    func getKey() throws -> String?  {
        let query: [CFString: Any] = [
            kSecAttrService: "OpenWeatherKey",
            kSecAttrAccount: "WeatherApp",
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ]
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        guard let data = result as? Data else {
            print("Not Data")
            return nil
        }
        do {
            return try JSONDecoder().decode(String.self, from: data)
        } catch {
            assertionFailure("Fail to decode item, error: \(error)")
            return nil
        }
    }

    func deleteKey() {
        let query: [CFString: Any] = [
            kSecAttrService: "OpenWeatherKey",
            kSecAttrAccount: "WeatherApp",
            kSecClass: kSecClassGenericPassword
        ]
        SecItemDelete(query as CFDictionary)
    }
}
