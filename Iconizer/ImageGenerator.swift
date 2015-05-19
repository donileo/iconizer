//
//  IconizerModel.swift
//  Iconizer
//
//  Created by Raphael Hanneken on 06/05/15.
//  Copyright (c) 2015 Raphael Hanneken. All rights reserved.
//

import Cocoa

class ImageGenerator {
    
    var icnImages: [String : Array<[String : NSImage?]>]                  // Contains NSImage objects
    var icnSizes: [String : Dictionary<String, Int>]                      // Holds the required image sizes for each platform
    
    
    
    init() {
        icnImages = [:]
        icnSizes  = [:]
        
        // required icon sizes for mac
        icnSizes["Mac"] = ["appicon-16@1x": 16, "appicon-16@2x": 32, "appicon-32@1x": 32, "appicon-32@2x": 64, "appicon-128@1x": 128, "appicon-128@2x": 256, "appicon-256@1x": 256, "appicon-256@2x": 512, "appicon-512@1x": 512, "appicon-512@2x": 1024]
        
        // required icon sizes for iphone
        icnSizes["iPhone"] = ["settings-@1x": 29, "ettings-@2x": 58, "settings-@3x": 87, "spotlight-@2x": 80, "spotlight-@3x": 120, "appicon-@2x": 120, "appicon-@3x": 180, "oldAppicon-@1x": 57, "oldAppicon-@2x": 114]
        
        // required icon sizes for apple watch
        icnSizes["Watch"] = ["notificationCenter-38mm@2x": 48, "notificationCenter-42mm@2x": 55, "companionSettings-@2x": 58, "companionSettings-@3x": 87, "appLauncher-38mm@2x": 80, "longLook-42mm@2x": 88, "quickLook-38mm@2x": 172, "quickLook-42mm@2x": 196]
        
        // required icon sizes for ipad
        icnSizes["iPad"] = ["settings-@1x": 29, "settings-@2x": 58, "spotlight-@1x": 40, "spotlight-@2x": 80, "oldSpotlight-@1x": 50, "oldSpotlight-@2x": 100, "appicon-@1x": 76, "appicon-@2x": 152, "oldAppicon-@1x": 72, "oldAppicon-@2x": 144]
        
        // required icon sizes for car play
        icnSizes["car"] = ["carplay-@1x": 120]
    }
    
    
    // Generates the necessary images, to create the image assets for the selected platforms
    func generateImagesFrom(image: NSImage?, forPlatforms platforms: [String]) {
        // Unwrap given image
        if let img = image {
            // Loop through selected platforms
            for platform in platforms {
                // Temporary array to hold the generated NSImage objects
                var images: [[String : NSImage?]] = []
                
                // Get the image sizes for the given platforms
                if let platformIconSizes = icnSizes[platform] {
                    // Loop through the image sizes
                    for (name, size) in platformIconSizes {
                        // Kick off actual resizing
                        let resizedImage = resizeImage(img, toSize: NSSize(width: size, height: size))
                        // Append the resized image to the temporary image array
                        images.append([name : resizedImage])
                    }
                }
                // Write back the images to the icnImages property
                icnImages[platform] = images
            }
        }
    }
    
    
    // Resizes a given NSImage to the given NSSize. And returns the resized
    // NSImage as optional
    func resizeImage(image: NSImage, toSize size: NSSize) -> NSImage? {
        // Create a new rect with given width and height
        let frame    = NSMakeRect(0, 0, size.width, size.height)
        // Extract an image representation for the frame rect
        let imageRep = image.bestRepresentationForRect(frame, context: nil, hints: nil)
        // Create an empty NSImage with the given size
        let newImage = NSImage(size: size)
        
        // Draw the newly sized image
        newImage.lockFocus()
        imageRep?.drawInRect(frame)
        newImage.unlockFocus()
        
        // Return the resized image
        return newImage
    }
}