//
//  MainWindowController.swift
//  Iconizer
//
//  Created by Raphael Hanneken on 06/05/15.
//  Copyright (c) 2015 Raphael Hanneken. All rights reserved.
//

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
