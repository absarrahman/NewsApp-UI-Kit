//
//  ApiHandler.swift
//  News App
//
//  Created by BJIT  on 12/1/23.
//

import Foundation


class ApiHandler {
    static func fetchAllDataBased(on category: NewsCategory = .all, completionHandler: @escaping([NewsModel], String?)->()){
        var targetUrlString = "\(Secret.baseUrl)&apiKey=\(Secret.apiKey)"
        
        if category != .all {
            targetUrlString = "\(Secret.baseUrl)&apiKey=\(Secret.apiKey)&category=\(category.rawValue)"
        }
        
        //let url = URL(string: "\(Secret.baseUrl)&apiKey=\(Secret.apiKey)")!
        let url = URL(string: targetUrlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching news: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                //errorCompletionHandlerMessage("Data failed to receive")
                completionHandler([], "Data failed to receive")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let dictionary = json as? [String: Any] else {
                    print("Error casting JSON to dictionary")
                    completionHandler([], "Failed to fetch data")
                    return
                }

                guard let articles = dictionary["articles"] else {
                    print("Articles not found")
                    completionHandler([], "Articles not found")
                    return
                }
                let jsonData = try JSONSerialization.data(withJSONObject: articles, options: [])
                let newsModels = try JSONDecoder().decode([NewsModel].self, from: jsonData)
                completionHandler(newsModels, nil)
            } catch {
                print("Error parsing JSON: \(error)")
                completionHandler([], "Error parsing JSON: \(error)")
            }
            print(data)
        }
        task.resume()
    }
}
