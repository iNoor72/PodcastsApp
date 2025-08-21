//
//  APIConstants.swift
//  Domain
//
//  Created by Noor El-Din Walid on 20/08/2025.
//

import Foundation
import Common

public enum APIConstants {
    static func getBundleInfo(for key: String) -> String {
        guard let info = Bundle.module.object(forInfoDictionaryKey: key) as? String else {
#if DEBUG
            print("Failed to find value in plist for key: \(key)")
            return ""
#else
            fatalError("No value found in plist for key: \(key)")
#endif
        }
        
        return info
    }
}
