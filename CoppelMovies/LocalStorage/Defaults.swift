//
//  Defaults.swift
//  CoppelMovies
//
//  Created by Aldair Carrillo on 28/12/22.
//

import UIKit

class Defaults
{
    private let defaults = UserDefaults.standard
  
    private let userKey = "user"
    private let accountKey = "account"
    private let avatarKey = "avatar"
    private let nameKey = "name"
  
    var user: String {
        get {
            return defaults.string(forKey: userKey) ?? ""
        }
        
        set {
            defaults.setValue(newValue, forKey: userKey)
        }
    }
    
    var account: Int {
        get {
            return defaults.integer(forKey: accountKey)
        }
        
        set {
            defaults.setValue(newValue, forKey: accountKey)
        }
    }
    
    var avatar: String {
        get {
            return defaults.string(forKey: avatarKey) ?? ""
        }
        
        set {
            defaults.setValue(newValue, forKey: avatarKey)
        }
    }
    
    var name: String {
        get {
            return defaults.string(forKey: nameKey) ?? ""
        }
        
        set {
            defaults.setValue(newValue, forKey: nameKey)
        }
    }
  
    class var shared: Defaults {
        struct Static {
            static let instance = Defaults()
        }
      
        return Static.instance
    }
    
}
