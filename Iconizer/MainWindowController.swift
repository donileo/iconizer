//
//  MainWindowController.swift
//  Iconizer
//
//  Created by Raphael Hanneken on 06/05/15.
//  Copyright (c) 2015 Raphael Hanneken. All rights reserved.
//

import Cocoa

enum ViewControllerTag: Int {
    case kAppIconView     = 0
    case kImageSetView    = 1
    case kLaunchImageView = 2
}


class MainWindowController: NSWindowController, NSWindowDelegate {
    
    @IBOutlet weak var mainView: NSView!
    @IBOutlet weak var exportType: NSSegmentedControl!
    
    var currentView: NSViewController?
    
    
    override var windowNibName: String? {
        return "MainWindow"
    }
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        window!.titleVisibility = .Hidden
        self.changeView(ViewControllerTag(rawValue: exportType.selectedSegment))
    }
    
    func changeView(view: ViewControllerTag?) {
        if let currentView = self.currentView {
            currentView.view.removeFromSuperview()
        }
        
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
        
        if let currentView = self.currentView {
            self.mainView.addSubview(currentView.view)
            currentView.view.frame = self.mainView.bounds
            currentView.view.autoresizingMask = .ViewWidthSizable | .ViewHeightSizable
        }
    }
    
    @IBAction func selectView(sender: NSSegmentedControl) {
        changeView(ViewControllerTag(rawValue: sender.selectedSegment))
    }
    
    @IBAction func export(sender: NSButton) {
        
    }
}
