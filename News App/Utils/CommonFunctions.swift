//
//  CommonFunctions.swift
//  News App
//
//  Created by BJIT  on 19/1/23.
//

import Foundation

class CommonFunctions {
    static func postedBefore(date: String?) -> String {
        
        guard let date = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let parsedDate = formatter.date(from: date)
        
        let currentDate = Date.now
        
        let difference = Calendar.current.dateComponents([.second], from: parsedDate!, to: currentDate)
        
        let totalSeconds = difference.second!
        
        let hour =  totalSeconds / 3600
        let minute = (totalSeconds % 3600) / 60
        
        return "\(hour == 0 ? "" : "\(hour) h") \(minute) m"
    }

}
