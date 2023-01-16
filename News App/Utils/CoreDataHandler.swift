//
//  CoreDataHandler.swift
//  News App
//
//  Created by Moh. Absar Rahman on 15/1/23.
//


import UIKit
import CoreData

class CoreDataHandler {
    static let shared = CoreDataHandler()
    
    static private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var isEmpty: Bool {
        do {
            let request = NSFetchRequest<NewsCDModel>(entityName: Constants.CoreDataConstants.newsEntityName)
            let count  = try CoreDataHandler.context.count(for: request)
            return count == 0
        } catch {
            return true
        }
    }
    
    private init() {}
    
    func addDataToCoreDataFrom(apiModels models: [NewsModel], category: NewsCategory, isBookmark: Bool = false) -> [NewsCDModel]{
        var listModel: [NewsCDModel] = []
        for model in models {
            let newsItem = NewsCDModel(context: CoreDataHandler.context)
            newsItem.sourceName = model.source.name
            newsItem.urlToImage = model.urlToImage
            newsItem.url = model.url
            newsItem.authorName = model.author
            newsItem.newsTitle = model.title
            newsItem.publishedAt = model.publishedAt
            newsItem.newsDescription = model.description
            newsItem.content = model.content
            newsItem.isBookmarkEnabled = isBookmark
            newsItem.category = category.rawValue
            
            do {
                try CoreDataHandler.context.save()
                listModel.append(newsItem)
            } catch {
                print("ERROR OCCURRED WHILE ADDING \(error)")
            }
        }
        return listModel
        
    }
    
    func fetchAllDataFrom(categoryField: NewsCategory = .all, queryField: String) -> [NewsCDModel] {
        var dataModel: [NewsCDModel] = []
        do {
            let fetchRequest = NSFetchRequest<NewsCDModel>(entityName: Constants.CoreDataConstants.newsEntityName)
            
            var categoryPredicate = NSPredicate(format: "category == %@", categoryField.rawValue)
            //            let newsTitlePredicate = NSPredicate(format: "newsTitle contains[cd] %@ or newsTitle == %@", newsTitle,"")
            //            let sourceNamePredicate = NSPredicate(format: "sourceName contains[cd] %@ or sourceName == %@", sourceName, "")
            //
            //            let finalPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,newsTitlePredicate,sourceNamePredicate])
            
            if !queryField.isEmpty {
                let newsTitlePredicate = NSPredicate(format: "newsTitle contains[cd] %@", queryField)
                let sourceNamePredicate = NSPredicate(format: "sourceName contains[cd] %@",queryField)
                let queryPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [newsTitlePredicate,sourceNamePredicate])
                categoryPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,queryPredicate])
            }
            
            fetchRequest.predicate = categoryPredicate
            
            dataModel = try CoreDataHandler.context.fetch(fetchRequest)
        } catch {
            print("Error occurred while fetching \(error)")
        }
        return dataModel
    }
    
    func removeAllData(completion: ()->()) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.CoreDataConstants.newsEntityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try CoreDataHandler.context.execute(deleteRequest)
            try CoreDataHandler.context.save()
            completion()
        } catch {
            print("Error deleting data: \(error)")
        }
    }
}
