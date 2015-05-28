//
//  AppIcon.swift
//  Iconizer
//
//  Created by Raphael Hanneken on 28/05/15.
//  Copyright (c) 2015 Raphael Hanneken. All rights reserved.
//

import Cocoa

class AppIcon {
    
    /// Holds the resized images.
    var images: [String : Array<[String : NSImage?]>] = [:]
    
    /// Holds the required icon sizes for each platform.
    var sizes: [String : Dictionary<String, Int>]     = [:]
    
    /// Contains data for the json file
    var jsonFile: [String : AnyObject]
    
    
    init() {
        // required icon sizes for OS X
        self.sizes["Mac"] = ["appicon-16@1x": 16, "appicon-16@2x": 32, "appicon-32@1x": 32, "appicon-32@2x": 64, "appicon-128@1x": 128, "appicon-128@2x": 256, "appicon-256@1x": 256, "appicon-256@2x": 512, "appicon-512@1x": 512, "appicon-512@2x": 1024]
        
        // required icon sizes for iPhone
        self.sizes["iPhone"] = ["settings-@1x": 29, "ettings-@2x": 58, "settings-@3x": 87, "spotlight-@2x": 80, "spotlight-@3x": 120, "appicon-@2x": 120, "appicon-@3x": 180, "oldAppicon-@1x": 57, "oldAppicon-@2x": 114]
        
        // required icon sizes for Apple Watch
        self.sizes["Watch"] = ["notificationCenter-38mm@2x": 48, "notificationCenter-42mm@2x": 55, "companionSettings-@2x": 58, "companionSettings-@3x": 87, "appLauncher-38mm@2x": 80, "longLook-42mm@2x": 88, "quickLook-38mm@2x": 172, "quickLook-42mm@2x": 196]
        
        // required icon sizes for iPad
        self.sizes["iPad"] = ["settings-@1x": 29, "settings-@2x": 58, "spotlight-@1x": 40, "spotlight-@2x": 80, "oldSpotlight-@1x": 50, "oldSpotlight-@2x": 100, "appicon-@1x": 76, "appicon-@2x": 152, "oldAppicon-@1x": 72, "oldAppicon-@2x": 144]
        
        // required icon sizes for CarPlay
        self.sizes["Car"] = ["carplay-@1x": 120]
        
        // init jsonFile
        jsonFile = [:]
        
        // Add the default attributes to the json object
        jsonFile["author"]  = "Iconizer"
        jsonFile["version"] = 1
    }
    
    
    /**
    * Generates all necessary images for the given platforms.
    *
    * :param: image     The image to Iconize.
    * :param: platforms The Platforms you want app icons for.
    */
    func generateImagesForPlatforms(platforms: [String], fromImage image: NSImage?) {
        // Unwrap given image
        if let img = image {
            // Loop through selected platforms
            for platform in platforms {
                // Temporary array to hold the generated NSImage objects
                var images: [[String : NSImage?]] = []
                
                // Get the image sizes for the given platforms
                if let platformIconSizes = self.sizes[platform] {
                    // Loop through the image sizes
                    for (name, size) in platformIconSizes {
                        // Kick off actual resizing
                        let resizedImage = img.copyWithSize(NSSize(width: size, height: size))
                        // Append the resized image to the temporary images array.
                        images.append([name : resizedImage])
                    }
                }
                // Write the images back to self.images.
                self.images[platform] = images
            }
        }
    }
    
    /**
     * Writes the given images to the given file url.
     *
     * :param: url           Determines, where to save the asset catalog.
     * :param: images        Array with images that should be saved.
     * :param: combinedAsset Save the given images as combined asset? Default's to false.
     */
    func saveImageAssetToDirectoryURL(url: NSURL?, asCombinedAsset combinedAsset: Bool = false) {
        // Holds icon specific informations (e.g. filename and size), for all generated icons
        var jsonImageDataArray: Array<[String : String]> = []
        
        // Unwrap the given url object
        if let dirURL = url {
            // Loop through the selected platforms
            for (platform, icons) in self.images {
                // Append the correct file structure to the given url
                let iconsetURL: NSURL
                
                if combinedAsset == true {
                    // For a combined asset: Save the xcasset folder under "Iconizer Assets"...
                    iconsetURL = NSURL.fileURLWithPath("\(dirURL.path!)/Iconizer Assets/Images.xcassets/AppIcon.appiconset", isDirectory: true)!
                } else {
                    // ...otherwise save the xcasset folder into a platform specific directory
                    iconsetURL = NSURL.fileURLWithPath("\(dirURL.path!)/Iconizer Assets/\(platform)/Images.xcassets/AppIcon.appiconset", isDirectory: true)!
                }
                
                // Create the required directories
                NSFileManager.defaultManager().createDirectoryAtURL(iconsetURL, withIntermediateDirectories: true, attributes: nil, error: nil)
                
                // Loop through the icons array
                for iconDict in icons {
                    // Unwrap icon name and icon file from the icon dictionary
                    for (name, icon) in iconDict {
                        // Create the correct filename
                        let filename = "\(platform.lowercaseString)-\(name).png"
                        // Append the corresponding icon name to the url
                        let fileURL = iconsetURL.URLByAppendingPathComponent(filename, isDirectory: false)
                        
                        // Unwrap NSImage?
                        if let icn = icon {
                            // Get PNG representation...
                            let pngRep = icn.PNGRepresentation()
                            if let png = pngRep {
                                // ...and write it to the filesystem
                                if png.writeToURL(fileURL, atomically: true) {
                                    println("Successfully wrote file to: \(fileURL.path!).")
                                } else {
                                    println("Writing file \(filename) to \(fileURL.path!) failed!")
                                }
                            }
                        }
                        
                        // Build the icon specific dictionary and append it to the icon data array
                        jsonImageDataArray.append(buildDataObjectForImageNamed(name, forPlatform: platform, sized: icon!.size))
                    }
                }
                
                // Append the informations of all icons, for the current platform, to the json file object...
                jsonFile["images"] = jsonImageDataArray
                // ...and save it to the given url as Contents.json
                writeJSONFileToURL(iconsetURL)
                
                // Unless we're creating an combined asset, reset the icon informations
                if combinedAsset == false {
                    jsonImageDataArray = []
                }
            }
        }
    }
    
    
    /**
     * Builds the icon specific dictionary, based on platform, size and filename. In which
     * the filename has to conform the following pattern: <ROLE>-<SUBTYPE [if any]>@<SCALE>.png.
     *
     * :param: name     Filename with the following pattern: <ROLE>-<SUBTYPE [if any]>@<SCALE>.png.
     * :param: platform Defines which platform this image is for.
     * :param: size     The size of the given image as NSSize.
     *
     * :returns: JSON Data for the given image.
    */
    func buildDataObjectForImageNamed(name: String, forPlatform platform: String, sized size: NSSize) -> [String : String] {
        // Holds the icon information; Gets returned at the very end
        var jsonImageData: [String : String] = [:]
        
        // Set the filename property
        jsonImageData["filename"] = "\(platform.lowercaseString)-\(name).png"
        // Set the idion property
        jsonImageData["idiom"] = platform.lowercaseString
        
        // Special case Apple Watch: Determine which subtype and role the current icon is for
        // Either 42mm or 38mm
        if platform == "Watch" {
            if name.rangeOfString("42mm") != nil {
                jsonImageData["subtype"] = "42mm"
            } else if name.rangeOfString("38mm") != nil{
                jsonImageData["subtype"] = "38mm"
            }
            
            // Set the role (e.g. notificationCenter, appLauncher, ...)
            if let index = name.rangeOfString("-") {
                jsonImageData["role"] = name.substringToIndex(advance(index.endIndex, -1))
            }
        }
        
        // Determine which scale we're having here
        if name.rangeOfString("@2x") != nil {
            jsonImageData["scale"] = "2x"
            
            // And again a special favor for Apple Watch: The icon for the notificationCenter, 42mm needs an image
            // size of 27.5px, the ONLY icon that needs and accepts a floating point number...
            if jsonImageData["subtype"] == "42mm" && jsonImageData["role"] == "notificationCenter" {
                // ...so we don't cast to Int here...
                jsonImageData["size"] = "\(size.width / 2)x\(size.height / 2)"
            } else {
                // ...but for everyone else
                jsonImageData["size"] = "\(Int(size.width / 2))x\(Int(size.height / 2))"
            }
            
        } else if name.rangeOfString("@3x") != nil {
            jsonImageData["scale"] = "3x"
            jsonImageData["size"] = "\(Int(size.width / 3))x\(Int(size.height / 3))"
        } else {
            jsonImageData["scale"] = "1x"
            jsonImageData["size"] = "\(Int(size.width))x\(Int(size.height))"
        }
        
        return jsonImageData
    }
    
    
    /**
     * Writes the jsonData to the given NSURL.
     *
     * :param: url NSURL path to the folder where to save the contents.json file.
     */
    func writeJSONFileToURL(url: NSURL) {
        // Append the file name to the given url
        let completeURL = url.URLByAppendingPathComponent("Contents.json", isDirectory: false)
        // Generate actual json data from the jsonFile object
        let jsonData    = NSJSONSerialization.dataWithJSONObject(jsonFile, options: nil, error: nil)
        
        // Unwrap the data object...
        if let json = jsonData {
            // and write them to the specified location
            json.writeToURL(completeURL, atomically: true)
        }
    }
}