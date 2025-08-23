//
//  CustomFonts.swift
//  Common
//
//  Created by Noor El-Din Walid on 23/08/2025.
//

import Foundation
import SwiftUI

/// Enum representing all custom fonts available in the app
public enum CustomFonts: String, CaseIterable {
  case ibmPlexSansArabicRegular = "IBMPlexSansArabic-Regular"
  case ibmPlexSansArabicLight = "IBMPlexSansArabic-Light"
  case ibmPlexSansArabicBold = "IBMPlexSansArabic-Bold"
  case ibmPlexSansArabicSemiBold = "IBMPlexSansArabic-SemiBold"
  case ibmPlexSansArabicText = "IBMPlexSansArabic-Text"
  case ibmPlexSansArabicThin = "IBMPlexSansArabic-Thin"
  case ibmPlexSansArabicExtraLight = "IBMPlexSansArabic-ExtraLight"
  
  public var fontName: String {
      return self.rawValue
  }
  
  public var fileName: String {
      return self.rawValue
  }
}

// MARK: - Font Helper Methods

public extension CustomFonts {
  func customFont(size: CGFloat) -> Font {
      return Font.customFont(self.fontName, size: size)
  }
  
  func customFont(size: CGFloat, relativeTo textStyle: Font.TextStyle) -> Font {
      return Font.customFont(self.fontName, size: size, relativeTo: textStyle)
  }
  
  func uiFont(size: CGFloat) -> UIFont {
      return UIFont.customFont(name: self.fontName, size: size)
  }
}

public extension CustomFonts {
    // MARK: - SwiftUI Font Properties
    
    // Title styles
    static var largeTitle: Font { CustomFonts.ibmPlexSansArabicBold.customFont(size: 34, relativeTo: .largeTitle) }
    static var title: Font { CustomFonts.ibmPlexSansArabicBold.customFont(size: 28, relativeTo: .title) }
    static var title2: Font { CustomFonts.ibmPlexSansArabicBold.customFont(size: 22, relativeTo: .title2) }
    static var title3: Font { CustomFonts.ibmPlexSansArabicSemiBold.customFont(size: 20, relativeTo: .title3) }
    
    // Headline styles
    static var headline: Font { CustomFonts.ibmPlexSansArabicSemiBold.customFont(size: 17, relativeTo: .headline) }
    static var subheadline: Font { CustomFonts.ibmPlexSansArabicRegular.customFont(size: 15, relativeTo: .subheadline) }
    
    // Body styles
    static var body: Font { CustomFonts.ibmPlexSansArabicRegular.customFont(size: 17, relativeTo: .body) }
    static var bodyLight: Font { CustomFonts.ibmPlexSansArabicLight.customFont(size: 17, relativeTo: .body) }
    static var bodyText: Font { CustomFonts.ibmPlexSansArabicText.customFont(size: 17, relativeTo: .body) }
    static var callout: Font { CustomFonts.ibmPlexSansArabicRegular.customFont(size: 16, relativeTo: .callout) }
    
    // Small text styles
    static var footnote: Font { CustomFonts.ibmPlexSansArabicRegular.customFont(size: 13, relativeTo: .footnote) }
    static var caption: Font { CustomFonts.ibmPlexSansArabicRegular.customFont(size: 12, relativeTo: .caption) }
    static var caption2: Font { CustomFonts.ibmPlexSansArabicLight.customFont(size: 11, relativeTo: .caption2) }
    
    // Custom semantic styles
    static var navigationTitle: Font { CustomFonts.ibmPlexSansArabicBold.customFont(size: 20, relativeTo: .headline) }
    static var sectionHeader: Font { CustomFonts.ibmPlexSansArabicSemiBold.customFont(size: 16, relativeTo: .subheadline) }
    static var buttonText: Font { CustomFonts.ibmPlexSansArabicSemiBold.customFont(size: 16, relativeTo: .body) }
    static var smallButton: Font { CustomFonts.ibmPlexSansArabicSemiBold.customFont(size: 14, relativeTo: .callout) }
    static var label: Font { CustomFonts.ibmPlexSansArabicRegular.customFont(size: 14, relativeTo: .callout) }
    static var smallLabel: Font { CustomFonts.ibmPlexSansArabicLight.customFont(size: 12, relativeTo: .caption) }
    static var placeholder: Font { CustomFonts.ibmPlexSansArabicLight.customFont(size: 16, relativeTo: .body) }
    
    // Thin and ExtraLight variations
    static var thinTitle: Font { CustomFonts.ibmPlexSansArabicThin.customFont(size: 28, relativeTo: .title) }
    static var extraLightSubheadline: Font { CustomFonts.ibmPlexSansArabicExtraLight.customFont(size: 15, relativeTo: .subheadline) }
    static var thinCaption: Font { CustomFonts.ibmPlexSansArabicThin.customFont(size: 12, relativeTo: .caption) }
    
    // MARK: - UIFont Properties
    
    // Title styles
    static var largeTitleUI: UIFont { CustomFonts.ibmPlexSansArabicBold.uiFont(size: 34) }
    static var titleUI: UIFont { CustomFonts.ibmPlexSansArabicBold.uiFont(size: 28) }
    static var title2UI: UIFont { CustomFonts.ibmPlexSansArabicBold.uiFont(size: 22) }
    static var title3UI: UIFont { CustomFonts.ibmPlexSansArabicSemiBold.uiFont(size: 20) }
    static var headerTitle: UIFont { CustomFonts.ibmPlexSansArabicBold.uiFont(size: 24) }
    
    // Headline styles
    static var headlineUI: UIFont { CustomFonts.ibmPlexSansArabicSemiBold.uiFont(size: 17) }
    static var subheadlineUI: UIFont { CustomFonts.ibmPlexSansArabicRegular.uiFont(size: 15) }
    
    // Body styles
    static var bodyUI: UIFont { CustomFonts.ibmPlexSansArabicRegular.uiFont(size: 17) }
    static var bodyLightUI: UIFont { CustomFonts.ibmPlexSansArabicLight.uiFont(size: 17) }
    static var bodyTextUI: UIFont { CustomFonts.ibmPlexSansArabicText.uiFont(size: 17) }
    static var calloutUI: UIFont { CustomFonts.ibmPlexSansArabicRegular.uiFont(size: 16) }
    
    // Small text styles
    static var footnoteUI: UIFont { CustomFonts.ibmPlexSansArabicRegular.uiFont(size: 13) }
    static var captionUI: UIFont { CustomFonts.ibmPlexSansArabicRegular.uiFont(size: 12) }
    static var caption2UI: UIFont { CustomFonts.ibmPlexSansArabicLight.uiFont(size: 11) }
    
    // Custom semantic styles
    static var navigationTitleUI: UIFont { CustomFonts.ibmPlexSansArabicBold.uiFont(size: 20) }
    static var sectionHeaderUI: UIFont { CustomFonts.ibmPlexSansArabicSemiBold.uiFont(size: 16) }
    static var buttonTextUI: UIFont { CustomFonts.ibmPlexSansArabicSemiBold.uiFont(size: 16) }
    static var smallButtonUI: UIFont { CustomFonts.ibmPlexSansArabicSemiBold.uiFont(size: 14) }
    static var labelUI: UIFont { CustomFonts.ibmPlexSansArabicRegular.uiFont(size: 14) }
    static var smallLabelUI: UIFont { CustomFonts.ibmPlexSansArabicLight.uiFont(size: 12) }
    static var placeholderUI: UIFont { CustomFonts.ibmPlexSansArabicLight.uiFont(size: 16) }
    
    // Thin and ExtraLight variations
    static var thinTitleUI: UIFont { CustomFonts.ibmPlexSansArabicThin.uiFont(size: 28) }
    static var extraLightSubheadlineUI: UIFont { CustomFonts.ibmPlexSansArabicExtraLight.uiFont(size: 15) }
    static var thinCaptionUI: UIFont { CustomFonts.ibmPlexSansArabicThin.uiFont(size: 12) }
    
    // MARK: - Utility Methods for All Font Weights
    
    static func regular(size: CGFloat, relativeTo textStyle: Font.TextStyle? = nil) -> Font {
        if let textStyle = textStyle {
            return CustomFonts.ibmPlexSansArabicRegular.customFont(size: size, relativeTo: textStyle)
        }
        return CustomFonts.ibmPlexSansArabicRegular.customFont(size: size)
    }
    
    static func light(size: CGFloat, relativeTo textStyle: Font.TextStyle? = nil) -> Font {
        if let textStyle = textStyle {
            return CustomFonts.ibmPlexSansArabicLight.customFont(size: size, relativeTo: textStyle)
        }
        return CustomFonts.ibmPlexSansArabicLight.customFont(size: size)
    }
    
    static func bold(size: CGFloat, relativeTo textStyle: Font.TextStyle? = nil) -> Font {
        if let textStyle = textStyle {
            return CustomFonts.ibmPlexSansArabicBold.customFont(size: size, relativeTo: textStyle)
        }
        return CustomFonts.ibmPlexSansArabicBold.customFont(size: size)
    }
    
    static func semiBold(size: CGFloat, relativeTo textStyle: Font.TextStyle? = nil) -> Font {
        if let textStyle = textStyle {
            return CustomFonts.ibmPlexSansArabicSemiBold.customFont(size: size, relativeTo: textStyle)
        }
        return CustomFonts.ibmPlexSansArabicSemiBold.customFont(size: size)
    }
    
    static func text(size: CGFloat, relativeTo textStyle: Font.TextStyle? = nil) -> Font {
        if let textStyle = textStyle {
            return CustomFonts.ibmPlexSansArabicText.customFont(size: size, relativeTo: textStyle)
        }
        return CustomFonts.ibmPlexSansArabicText.customFont(size: size)
    }
    
    static func thin(size: CGFloat, relativeTo textStyle: Font.TextStyle? = nil) -> Font {
        if let textStyle = textStyle {
            return CustomFonts.ibmPlexSansArabicThin.customFont(size: size, relativeTo: textStyle)
        }
        return CustomFonts.ibmPlexSansArabicThin.customFont(size: size)
    }
    
    static func extraLight(size: CGFloat, relativeTo textStyle: Font.TextStyle? = nil) -> Font {
        if let textStyle = textStyle {
            return CustomFonts.ibmPlexSansArabicExtraLight.customFont(size: size, relativeTo: textStyle)
        }
        return CustomFonts.ibmPlexSansArabicExtraLight.customFont(size: size)
    }
    
    // UIFont utility methods
    static func regularUI(size: CGFloat) -> UIFont {
        return CustomFonts.ibmPlexSansArabicRegular.uiFont(size: size)
    }
    
    static func lightUI(size: CGFloat) -> UIFont {
        return CustomFonts.ibmPlexSansArabicLight.uiFont(size: size)
    }
    
    static func boldUI(size: CGFloat) -> UIFont {
        return CustomFonts.ibmPlexSansArabicBold.uiFont(size: size)
    }
    
    static func semiBoldUI(size: CGFloat) -> UIFont {
        return CustomFonts.ibmPlexSansArabicSemiBold.uiFont(size: size)
    }
    
    static func textUI(size: CGFloat) -> UIFont {
        return CustomFonts.ibmPlexSansArabicText.uiFont(size: size)
    }
    
    static func thinUI(size: CGFloat) -> UIFont {
        return CustomFonts.ibmPlexSansArabicThin.uiFont(size: size)
    }
    
    static func extraLightUI(size: CGFloat) -> UIFont {
        return CustomFonts.ibmPlexSansArabicExtraLight.uiFont(size: size)
    }
}
