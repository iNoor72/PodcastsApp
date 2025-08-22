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
            return "0m"
        }
        
        let totalMinutes = self / 60
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours)h \(minutes)m"
        } else if hours > 0 {
            return "\(hours)h"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "1m" // Less than a minute, show as 1M
        }
    }
}
