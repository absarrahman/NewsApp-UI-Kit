//
//  ApiHandler.swift
//  News App
//
//  Created by BJIT  on 12/1/23.
//

import Foundation


class ApiHandler {
    static func fetchAllData(completionHandler: @escaping([NewsModel])->()){
        let url = URL(string: "\(Secret.baseUrl)&apiKey=\(Secret.apiKey)")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching news: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let dictionary = json as? [String: Any] else {
                    print("Error casting JSON to dictionary")
                    return
                }
                //print(dictionary["articles"])
                guard let articles = dictionary["articles"] else {
                    print("Articles not found")
                    return
                }
                let jsonData = try JSONSerialization.data(withJSONObject: articles, options: [])
                let newsModels = try JSONDecoder().decode([NewsModel].self, from: jsonData)
                completionHandler(newsModels)
//                DispatchQueue.main.async { [weak self] in
//                    self?.activityIndicator.stopAnimating()
//                    //self?.activityIndicator.hidesWhenStopped
//                    self?.selectedNewsList = newsModels
//                    self?.tableView.reloadData()
//                }
                
            } catch {
                print("Error parsing JSON: \(error)")
            }
            print(data)
            
            //            do {
            //                let users = try JSONDecoder().decode([NewsModel].self, from: data)
            //                print(users)
            //            } catch {
            //                print("Error decoding users: \(error)")
            //            }
        }
        task.resume()
    }
}
