//
//  ApiHandler.swift
//  News App
//
//  Created by BJIT  on 12/1/23.
//

import Foundation


enum ApiError : Error {
    case dataFailedToReceive, failedToCastDict, articlesNotFound
}

class ApiHandler {
    static func fetchAllDataBased(on category: NewsCategory = .all,pageNumber: Int = 1, completionHandler: @escaping(Result<[NewsModel], Error>, Int)->()){
        var targetUrlString = "\(Secret.baseUrl)&apiKey=\(Secret.apiKey)&page=\(pageNumber)"
        
        if category != .all {
            //targetUrlString = "\(Secret.baseUrl)&apiKey=\(Secret.apiKey)&category=\(category.rawValue)"
            targetUrlString.append("&category=\(category.rawValue)")
        }
        
        //let url = URL(string: "\(Secret.baseUrl)&apiKey=\(Secret.apiKey)")!
        let url = URL(string: targetUrlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                //print("Error fetching news: \(error)")
                completionHandler(.failure(error), -1)
                return
            }
            
            guard let data = data else {
                print("No data received")
                //errorCompletionHandlerMessage("Data failed to receive")
                //completionHandler([], "Data failed to receive",-1)
                completionHandler(.failure(ApiError.dataFailedToReceive), -1)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let dictionary = json as? [String: Any] else {
                    print("Error casting JSON to dictionary")
                    //completionHandler([], "Failed to fetch data",-1)
                    completionHandler(.failure(ApiError.failedToCastDict), -1)
                    return
                }
                
                guard let articles = dictionary["articles"], let totalResults = dictionary["totalResults"] as? Int else {
                    print("Articles not found")
                    //completionHandler([], "Articles not found",0)
                    completionHandler(.failure(ApiError.articlesNotFound),0)
                    return
                }
                //                print(dictionary["articles"])
                //                print(targetUrlString)
                let jsonData = try JSONSerialization.data(withJSONObject: articles, options: [])
                let newsModels = try JSONDecoder().decode([NewsModel].self, from: jsonData)
                //completionHandler(newsModels, nil, totalResults)
                completionHandler(.success(newsModels), totalResults)
            } catch {
                print("Error parsing JSON: \(error)")
                completionHandler(.failure(error), -1)
            }
            print(data)
        }
        task.resume()
    }
}
