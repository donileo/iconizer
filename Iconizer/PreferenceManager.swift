//
//  PreferenceManager.swift
//  Iconizer
//
//  Created by Raphael Hanneken on 06/05/15.
//  Copyright (c) 2015 Raphael Hanneken. All rights reserved.
//

import Cocoa

// Keys to access the userDefaults
private let generateForAppleWatchKey = "generateForAppleWatch"      // Generate icons for Apple Watch?
private let generateForIPhoneKey     = "generateForIPhone"          // Generate icons for iPhone?
private let generateForIPadKey       = "generateForIPad"            // Generate icons for iPad?
private let generateForMacKey        = "generateForMac"             // Generate icons for Mac OS?
private let generateForCarKey        = "generateForCar"             // Generate icons for CarPlay?
private let combinedAssetKey         = "combinedAsset"              // Export selected Platforms into one asset catalog


// Manage the userDefaults
class PreferenceManager {
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var generateForAppleWatch: Int {
        get {
            return userDefaults.integerForKey(generateForAppleWatchKey)
        }
        
        set(newValue) {
            if (newValue == NSOffState) {
                userDefaults.setInteger(newValue, forKey: generateForAppleWatchKey)
            } else {
                userDefaults.setInteger(NSOnState, forKey: generateForAppleWatchKey)
            }
        }
    }
    
    var generateForIPhone: Int {
        get {
            return userDefaults.integerForKey(generateForIPhoneKey)
        }
        
        set(newValue) {
            if newValue == NSOffState {
                userDefaults.setInteger(newValue, forKey: generateForIPhoneKey)
            } else {
                userDefaults.setInteger(NSOnState, forKey: generateForIPhoneKey)
            }
        }
    }
    
    var generateForIPad: Int {
        get {
            return userDefaults.integerForKey(generateForIPadKey)
        }
        
        set(newValue) {
            if newValue == NSOffState {
                userDefaults.setInteger(newValue, forKey: generateForIPadKey)
            } else {
                userDefaults.setInteger(NSOnState, forKey: generateForIPadKey)
            }
        }
    }
    
    var generateForMac: Int {
        get {
            return userDefaults.integerForKey(generateForMacKey)
        }
        
        set(newValue) {
            if newValue == NSOffState {
                userDefaults.setInteger(newValue, forKey: generateForMacKey)
            } else {
                userDefaults.setInteger(NSOnState, forKey: generateForMacKey)
            }
        }
    }
    
    var generateForCar: Int {
        get {
            return userDefaults.integerForKey(generateForCarKey)
        }
        
        set(newValue) {
            if newValue == NSOffState {
                userDefaults.setInteger(newValue, forKey: generateForCarKey)
            } else {
                userDefaults.setInteger(NSOnState, forKey: generateForCarKey)
            }
        }
    }
    
    var combinedAsset: Int {
        get {
            return userDefaults.integerForKey(combinedAssetKey)
        }
        
        set(newValue) {
            if newValue == NSOffState {
                userDefaults.setInteger(newValue, forKey: combinedAssetKey)
            } else {
                userDefaults.setInteger(newValue, forKey: combinedAssetKey)
            }
        }
    }
    
    
    
    init() {
        registerDefaultPreferences()
    }
    
    func registerDefaultPreferences() {
        let defaults = [ generateForMacKey: NSOnState,
                      generateForIPhoneKey: NSOnState,
                        generateForIPadKey: NSOnState,
                  generateForAppleWatchKey: NSOnState,
                         generateForCarKey: NSOnState,
                          combinedAssetKey: NSOffState ]
        
        userDefaults.registerDefaults(defaults)
    }
}