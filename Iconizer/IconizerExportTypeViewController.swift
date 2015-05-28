//
//  IconizerExportTypeViewController.swift
//  Iconizer
//
//  Created by Raphael Hanneken on 28/05/15.
//  Copyright (c) 2015 Raphael Hanneken. All rights reserved.
//

import Cocoa

/**
 * Superclass for AppIconViewController, LaunchImageViewController, ImageSetViewController. 
 * Adds the export method.
 */
class IconizerExportTypeViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
     * Base class export. Does literally nothing.
     *
     * :returns: Returns always false.
     */
    func export() -> Bool {
        return false
    }
    
}
