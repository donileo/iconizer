//
// MainWindowController.swift
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

/**
 * Nicely wraps up the integers from NSSegmented Control.
 *
 * - kAppIconView:     Represents the AppIconViewController
 * - kImageSetView:    Represents the ImageSetViewController
 * - kLaunchImageView: Represents the LaunchImageViewController
 */
enum ViewControllerTag: Int {
    case kAppIconView      = 0
    case kImageSetView     = 1
    case kLaunchImageView  = 2
}


class MainWindowController: NSWindowController, NSWindowDelegate {
    
     /// Holds the main view of MainWindow.
    @IBOutlet weak var mainView: NSView!
     /// Holds a pointer for the segmentedControl, which determines which view is currently displayed.
    @IBOutlet weak var exportType: NSSegmentedControl!
     /// Represents the currently activated view.
    var currentView: IconizerExportTypeViewController?
    
    override var windowNibName: String? {
        return "MainWindow"
    }
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Hide the window title, to display the unified toolbar
        window!.titleVisibility = .Hidden
        
        // Select the default ViewController
        self.changeView(ViewControllerTag(rawValue: exportType.selectedSegment))
    }
    
    /**
     * Swaps the current ViewController with a new one.
     *
     * :param: view Takes a ViewControllerTag.
     */
    func changeView(view: ViewControllerTag?) {
        // Unwrap the current view, if any...
        if let currentView = self.currentView {
            // ...and remove it from the superview.
            currentView.view.removeFromSuperview()
        }
        
        // Check which ViewControllerTag is given.
        if let view = view {
            switch view {
            case .kAppIconView:
                self.currentView = AppIconViewController()
                
            case .kImageSetView:
                self.currentView = ImageSetViewController()
                
            case .kLaunchImageView:
                self.currentView = LaunchImageViewController()
                
            default:
                return
            }
        }
        
        // Add the selected view to the mainView of MainWindow.
        if let currentView = self.currentView {
            self.mainView.addSubview(currentView.view)
            currentView.view.frame = self.mainView.bounds
            currentView.view.autoresizingMask = .ViewWidthSizable | .ViewHeightSizable
        }
    }
    
    /**
     * Lets the user choose a ViewController from an NSSegmentedControl.
     *
     * :param: sender NSSegmentedControl, with 'Mode' set to 'Select One'.
     */
    @IBAction func selectView(sender: NSSegmentedControl) {
        changeView(ViewControllerTag(rawValue: sender.selectedSegment))
    }
    
    /**
     * Gets called, everytime the user clicks 'Export'. Kicks off the asset
     * generation for the currently selected type.
     *
     * :param: sender NSButton, that should start the generation process.
     */
    @IBAction func export(sender: NSButton) {
        // Unwrap currentView...
        if let currentView = self.currentView {
            // ...and start export process.
            if currentView.export() {
                // Create a new NSOpenPanel, to export the generated asset catalogs.
                let exportSheet = NSOpenPanel()
                
                // Configure the NSOpenPanel.
                exportSheet.canChooseDirectories = true
                exportSheet.canChooseFiles       = false
                exportSheet.prompt               = "Export"
                
                // Open NSOpenPanel ontop of self.window.
                exportSheet.beginSheetModalForWindow(self.window!) { (result: Int) -> Void in
                    if result == NSFileHandlingPanelOKButton {
                        if let url = exportSheet.URL {
                            if currentView.saveToURL(url) {
                                NSWorkspace.sharedWorkspace().openURL(url.URLByAppendingPathComponent("Iconizer Assets/"))
                            }
                        }
                    }
                }
            }
        }
    }
}
