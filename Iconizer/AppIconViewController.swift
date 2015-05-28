//
//  AppIconViewController.swift
//  Iconizer
//
//  Created by Raphael Hanneken on 27/05/15.
//  Copyright (c) 2015 Raphael Hanneken. All rights reserved.
//

import Cocoa

class AppIconViewController: IconizerExportTypeViewController {
    
    @IBOutlet weak var osx: NSButton!
    
    override var nibName: String {
        return "AppIconView"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
