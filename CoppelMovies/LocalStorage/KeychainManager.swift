//
//  KeychainManager.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 28/12/22.
//

import Foundation

class KeychainManager {
    
    enum KeychainError: Error {
        case duplicateError
        case unknown(OSStatus)
    }
    
    static func save(
            service: String,
            account: String,
            key: Data ) throws {
                debugPrint("saving...")
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: key as AnyObject
        ]
                
        let status = SecItemAdd(query as CFDictionary, nil)
                
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateError
        }
                
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
                     
        debugPrint("SAVED")
    }
    
    static func get(
            service: String,
            account: String) -> Data? {
                debugPrint("reading...")
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
                
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        print("Read status: \(status)")
                
        return result as? Data
                
    }
    
    static func remove(
            service: String,
            account: String) throws {
                debugPrint("reading...")
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
                
        let status = SecItemDelete(query as CFDictionary)
        
        print("Read status: \(status)")
                
        debugPrint("REMOVED")
                
    }
}
