//
//  FontManager.swift
//  Common
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import Foundation
import SwiftUI
import CoreGraphics
import CoreText

public struct FontManager {
    
    // MARK: - Font Registration
    
    /// Registers all custom fonts in the Common package
    public static func registerFonts() {
        // Register all custom fonts defined in CustomFonts enum
        CustomFonts.allCases.forEach { font in
            registerFont(bundle: .module, fontName: font.fileName, fontExtension: "ttf")
        }
        
        print("FontManager: Custom fonts registration completed for \(CustomFonts.allCases.count) fonts")
    }
    
    /// Registers a single font file
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            print("FontManager: Font file not found: \(fontName).\(fontExtension)")
            return
        }
        
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            print("FontManager: Could not create data provider for font: \(fontName)")
            return
        }
        
        guard let font = CGFont(fontDataProvider) else {
            print("FontManager: Could not create font from data provider: \(fontName)")
            return
        }
        
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        
        if success {
            print("FontManager: Successfully registered font: \(fontName)")
        } else if let error = error?.takeRetainedValue() {
            print("FontManager: Failed to register font \(fontName): \(CFErrorCopyDescription(error))")
        }
    }
}

// MARK: - Font Extensions

public extension Font {
    /// Creates a custom font with the given name and size
    static func customFont(_ name: String, size: CGFloat) -> Font {
        return Font.custom(name, size: size)
    }
    
    /// Creates a custom font with dynamic type support
    static func customFont(_ name: String, size: CGFloat, relativeTo textStyle: Font.TextStyle) -> Font {
        return Font.custom(name, size: size, relativeTo: textStyle)
    }
}

// MARK: - UIFont Extensions

public extension UIFont {
    /// Creates a custom UIFont with the given name and size
    static func customFont(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
