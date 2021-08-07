//
//  KeyChainModel.swift
//  Picme
//
//  Created by taeuk on 2021/08/07.
//

import Foundation

struct KeychainUserInfo: Codable {
    var userIdentifier: String?
    var userEmail: String?
}

final class KeyChainModel {
    
    static let shared = KeyChainModel()
    
    private init() {}
    
    private let account = "Picme"
    private let service = Bundle.main.bundleIdentifier
    
    private lazy var query: [CFString: Any]? = {
        guard let service = self.service else { return nil }
        return [kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: account,
                kSecAttrService: service]
      }()
    
    /// KeyChain 저장
    func createUserInfo(with: KeychainUserInfo) -> Bool {
        guard let userInfo = try? JSONEncoder().encode(with),
              let service = service else { return false }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecAttrGeneric: userInfo
        ]
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    /// KeyChain 정보 읽기
    func readUserInfo() -> KeychainUserInfo? {
        guard let service = service else { return nil }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess {
            return nil
        }
        
        guard let existingItem = item as? [String: Any],
              let data = existingItem[kSecAttrGeneric as String] as? Data,
              let user = try? JSONDecoder().decode(KeychainUserInfo.self, from: data) else { return nil }
        
        return user
    }
    
    /// KeyChain 제거
    func deleteUserinfo() -> Bool {
        guard let query = self.query else { return false }
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
