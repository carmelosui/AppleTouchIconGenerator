//
//  main.swift
//  AppleTouchIconGenerator
//
//  Created by Carmelo Sui on 5/8/15.
//  Copyright (c) 2015 Carmelo Sui. All rights reserved.
//

import Foundation
import AppKit

//MARK: configurations
let sourceImagePath = "~/Downloads/favicon.png".stringByExpandingTildeInPath
let outputFolder = "~/Downloads/".stringByExpandingTildeInPath
let outputHTMLFileName = "HTML.txt"
let linkPathPrefix = "/"

let sizes = [
    CGSize(width: 57, height: 57),
    CGSize(width: 114, height: 114),
    CGSize(width: 72, height: 72),
    CGSize(width: 144, height: 144),
    CGSize(width: 60, height: 60),
    CGSize(width: 120, height: 120),
    CGSize(width: 152, height: 152),
    CGSize(width: 180, height: 180)]
let iconSizes = [
    CGSize(width: 16, height: 16),
    CGSize(width: 32, height: 32),
    CGSize(width: 96, height: 96),
    CGSize(width: 160, height: 160),
    CGSize(width: 192, height: 192),
]

//MARK: implementation code
let sourceImage = NSImage(contentsOfFile: sourceImagePath)!
var imageRect = NSMakeRect(0, 0, sourceImage.size.width, sourceImage.size.height)
let sourceImageCGImageUnmanaged = sourceImage.CGImageForProposedRect(&imageRect, context: nil, hints: nil)
let sourceCGImage = sourceImageCGImageUnmanaged?.takeRetainedValue()

func imageDataWithSize(size: CGSize) -> NSData
{
    let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
    let context = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), 8, 0, colorSpace, bitmapInfo)
    
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), sourceCGImage)
    let cgImage = CGBitmapContextCreateImage(context)
    let bitmapImageRep = NSBitmapImageRep(CGImage: cgImage)
    let imageData = bitmapImageRep.representationUsingType(NSBitmapImageFileType.NSPNGFileType, properties: [:])
    return imageData!
}

for size in sizes {
    let data = imageDataWithSize(size)
    let outputPath = outputFolder.stringByAppendingPathComponent("apple_touch_icon_\(UInt(size.width))_\(UInt(size.height)).png")
    data.writeToFile(outputPath, atomically: true)
}

for size in iconSizes {
    let data = imageDataWithSize(size)
    let outputPath = outputFolder.stringByAppendingPathComponent("favicon_\(UInt(size.width))_\(UInt(size.height)).png")
    data.writeToFile(outputPath, atomically: true)
}

var linkString = ""
for size in sizes {
    let link = "<link rel=\"apple-touch-icon\" sizes=\"\(Int(size.width))x\(Int(size.height))\" href=\"\(linkPathPrefix)apple_touch_icon_\(UInt(size.width))_\(UInt(size.height)).png\" />"
    linkString = linkString.stringByAppendingString(link)
    linkString = linkString.stringByAppendingString("\n")
}
for size in iconSizes
{
    let link = "<link rel=\"icon\" type=\"image/png\" sizes=\"\(Int(size.width))x\(Int(size.height))\" href=\"\(linkPathPrefix)favicon_\(UInt(size.width))_\(UInt(size.height)).png\" />"
    linkString = linkString.stringByAppendingString(link)
    linkString = linkString.stringByAppendingString("\n")
}

linkString.writeToFile(outputFolder.stringByAppendingPathComponent(outputHTMLFileName), atomically: true, encoding: NSUTF8StringEncoding, error: nil)