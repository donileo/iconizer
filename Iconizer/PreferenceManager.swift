//
// PreferenceManager.swift
// Iconizer
// https://github.com/behoernchen/Iconizer
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Raphael Hanneken
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


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