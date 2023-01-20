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
    
    
    static func isInternetCurrentlyAvailable(completionHandler: @escaping(Result<String, Error>)->()) {
        let googleURL = "https://www.google.com/"
        let url = URL(string: googleURL)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                //print("Error fetching news: \(error)")
                completionHandler(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                //errorCompletionHandlerMessage("Data failed to receive")
                //completionHandler([], "Data failed to receive",-1)
                completionHandler(.failure(ApiError.dataFailedToReceive))
                return
            }
            
            print(data)
            completionHandler(.success("INTERNET AVAILABLE"))
        }
        task.resume()
    }

}
