//
//  DateFormatterHelper.swift
//  Common
//
//  Created by Noor El-Din Walid on 22/08/2025.
//

import Foundation

public final class DateFormatterHelper {
    public static func formatDate(_ dateString: String?) -> String {
        guard let dateString else { return "" }
        
        // Create ISO8601 date formatter
        let isoFormatter = ISO8601DateFormatter()
        
        // Parse the input date
        guard let inputDate = isoFormatter.date(from: dateString) else {
            return ""
        }
        
        // Get calendar for date comparisons
        let calendar = Calendar.current
        
        // Get today's date
        let today = Date()
        
        // Check if the input date is today
        if calendar.isDate(inputDate, inSameDayAs: today) {
            return "Today"
        }
        
        // Check if the input date is yesterday
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
           calendar.isDate(inputDate, inSameDayAs: yesterday) {
            return "Yesterday"
        }
        
        // Format as dd-mm-yyyy
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: inputDate)
    }
}
