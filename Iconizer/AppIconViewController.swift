//
// AppIconViewController.swift
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


private let kAppleWatchPlatformName = "Watch"
private let kIPadPlatformName       = "iPad"
private let kIPhonePlatformName     = "iPhone"
private let kOSXPlatformName        = "Mac"
private let kCarPlayPlatformName    = "Car"


class AppIconViewController: IconizerExportTypeViewController {
    
     /// Export asset catalog for OS X?
    @IBOutlet weak var osx: NSButton!
     /// Export asset catalog for iPhone?
    @IBOutlet weak var iphone: NSButton!
     /// Export asset catalog for iPad?
    @IBOutlet weak var ipad: NSButton!
     /// Export asset catalog for Apple Watch?
    @IBOutlet weak var watch: NSButton!
     /// Export asset catalog for CarPlay?
    @IBOutlet weak var carPlay: NSButton!
     /// Export selected platforms as combined appiconset?
    @IBOutlet weak var combined: NSButton!
     /// Progress indicator; Spins while building asset catalog(s)
    @IBOutlet weak var progress: NSProgressIndicator!
     /// Image view
    @IBOutlet weak var imageView: NSImageView!
    
     /// Which platforms are actually choosen?
    var enabledPlatforms: [String] {
        get {
            var tmp: [String] = []
            if watch.state   == NSOnState { tmp.append(kAppleWatchPlatformName) }
            if ipad.state    == NSOnState { tmp.append(kIPadPlatformName) }
            if iphone.state  == NSOnState { tmp.append(kIPhonePlatformName) }
            if osx.state     == NSOnState { tmp.append(kOSXPlatformName) }
            if carPlay.state == NSOnState { tmp.append(kCarPlayPlatformName) }
            
            return tmp
        }
    }
    
     /// Holds the AppIcon object with all images in the appropriate size
    var appIcon = AppIcon()
    
    // Return nib name for the associated view
    override var nibName: String {
        return "AppIconView"
    }
    
    
    
    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a new instance of the PreferenceManager
        let prefManager = PreferenceManager()
        
        // Get the user defaults.
        self.combined.state = prefManager.combinedAsset
        self.watch.state    = prefManager.generateForAppleWatch
        self.carPlay.state  = prefManager.generateForCar
        self.ipad.state     = prefManager.generateForIPad
        self.iphone.state   = prefManager.generateForIPhone
        self.osx.state      = prefManager.generateForMac
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        // Create a new instance of PreferenceManager
        let prefManager = PreferenceManager()
        
        // Write back the user defaults.
        prefManager.combinedAsset         = self.combined.state
        prefManager.generateForAppleWatch = self.watch.state
        prefManager.generateForCar        = self.carPlay.state
        prefManager.generateForIPad       = self.ipad.state
        prefManager.generateForIPhone     = self.iphone.state
        prefManager.generateForMac        = self.osx.state
    }
    
    /**
     * Generates the images for the selected platforms.
     *
     * :returns: true if generation was succesful, false otherwise
     */
    override func export() -> Bool {
        // Do we have an image?
        if let img = self.imageView.image {
            // Is at least one platform selected?
            if self.enabledPlatforms.count > 0 {
                // Start progress indicator.
                self.toggleProgressIndicator()
                
                // Generate images.
                self.appIcon.generateImagesForPlatforms(self.enabledPlatforms, fromImage: self.imageView.image)
                
                // Stop progress indicator.
                self.toggleProgressIndicator()
                
                // We're alright here!
                return true
            } else {
                self.beginSheetModalWithMessage("No platform selected!", andText: "You have to select at least one platform.")
                return false
            }
        } else {
            self.beginSheetModalWithMessage("No Image provided!", andText: "You haven't provided any images to convert.")
            return false
        }
    }
    
    /**
     * Tells the model object to save itself as asset catalog.
     *
     * :param: url Path url, where to save the asset catalog.
     *
     * :returns: Return true on success, false otherwise
     */
    override func saveToURL(url: NSURL) -> Bool {
        // Save the asset catalog(s) either combined or seperated.
        if self.combined.state == NSOnState {
            self.appIcon.saveImageAssetToDirectoryURL(url, asCombinedAsset: true)
        } else {
            self.appIcon.saveImageAssetToDirectoryURL(url)
        }
        
        return true
    }
    
    /**
     * Toggles the visibility and the animation status of the NSProgressIndicator
     */
    func toggleProgressIndicator() {
        // Is the progressIndicator visible?
        if self.progress.hidden == false {
            // Yes: Hide it and stop the animation.
            self.progress.hidden = true
            self.progress.stopAnimation(self)
        } else {
            // Nope: Otherwise start the animation and display it on screen.
            self.progress.startAnimation(self)
            self.progress.hidden = false
        }
    }
    
    /**
     * Opens a sheet modal with the given message and text.
     *
     * :param: message messageText for the alert.
     * :param: text    informativeText for the alert
     */
    func beginSheetModalWithMessage(message: String, andText text: String) {
        // Create a new NSAlert object.
        let alert = NSAlert()
        
        // Configure message and text.
        alert.messageText     = message
        alert.informativeText = text
        
        // Display sheet modal.
        alert.beginSheetModalForWindow(self.view.window!, completionHandler: nil)
    }
}
