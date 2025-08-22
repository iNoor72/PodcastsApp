//
//  File.swift
//  Common
//
//  Created by Noor El-Din Walid on 22/08/2025.
//

import Foundation

public extension Int {
    func secondsToHoursAndMinutes() -> String {
        guard self > 0 else {
            return "0M"
        }
        
        let totalMinutes = self / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours)H \(minutes)M"
        } else if hours > 0 {
            return "\(hours)H"
        } else if minutes > 0 {
            return "\(minutes)M"
        } else {
            return "1M" // Less than a minute, show as 1M
        }
    }
}
