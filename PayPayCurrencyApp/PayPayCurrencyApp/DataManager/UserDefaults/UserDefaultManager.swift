//
//  UserDefaultManager.swift
//  PayPayCurrencyApp
//
//  Created by Kimchheang on 7/3/21.
//

import Foundation

protocol SavableType: class {
    var userDefault: UserDefaults { get }
    var lastUpdatedTime: Date? { get set }
    var shouldRefreshDataAfter30Minute: Bool { get }
        
    func setObject<Object: Encodable>(_ object: Object, forKey: String) throws
    func getObject<Object: Decodable>(forKey: String, castTo type: Object.Type) throws -> Object
}

enum SavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}

class UserDefaultManager: SavableType {
    
    var userDefault = UserDefaults.standard
    
    func setObject<Object: Encodable>(_ object: Object, forKey: String) throws {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            userDefault.set(data, forKey: forKey)
            userDefault.synchronize()
        } catch {
            throw SavableError.unableToEncode
        }
    }
    
    func getObject<Object: Decodable>(forKey: String, castTo type: Object.Type) throws -> Object {
        guard let data = userDefault.data(forKey: forKey) else {
            throw SavableError.noValue
        }
        
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw SavableError.unableToDecode
        }
    }
    
    var lastUpdatedTime: Date? {
        set {
            userDefault.set(newValue, forKey: "kLastUpdatedTime")
        }
        
        get {
            userDefault.value(forKey: "kLastUpdatedTime") as? Date
        }
    }
    
    var shouldRefreshDataAfter30Minute: Bool {
        guard let lastUpdatedTime = self.lastUpdatedTime else {
            self.lastUpdatedTime = Date()
            return true
        }
        
        let currentDate = Calendar.current.dateComponents([.minute], from: lastUpdatedTime, to: Date())
        return currentDate.minute ?? 0 > 30
    }
}
