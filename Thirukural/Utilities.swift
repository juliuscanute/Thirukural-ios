//
//  Utilities.swift
//  Thirukural
//
//  Created by Julius Canute on 2/2/2025.
//

import SwiftUI
import ImageIO
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

func getImageResourceName(kuralNumber: Int) -> String? {
    return "kural\(kuralNumber)"
}

func loadKuralImage(kuralNumber: Int, bundle: Bundle = .main) -> Image? {
    guard let resourceName = getImageResourceName(kuralNumber: kuralNumber) else {
        return nil
    }
    
    if let webPImage = loadWebPImage(named: resourceName, bundle: bundle) {
        return webPImage
    }
    
    return Image(resourceName)
}

private func loadWebPImage(named name: String, bundle: Bundle) -> Image? {
    guard let url = bundle.url(forResource: name, withExtension: "webp"),
          let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil),
          let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
        return nil
    }
    
#if canImport(UIKit)
    return Image(uiImage: UIImage(cgImage: cgImage))
#elseif canImport(AppKit)
    return Image(nsImage: NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height)))
#else
    return nil
#endif
}
