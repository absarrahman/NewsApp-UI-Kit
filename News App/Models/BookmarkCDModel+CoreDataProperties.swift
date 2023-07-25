//
//  BookmarkCDModel+CoreDataProperties.swift
//  News App
//
//  Created by BJIT  on 18/1/23.
//
//

import Foundation
import CoreData


extension BookmarkCDModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkCDModel> {
        return NSFetchRequest<BookmarkCDModel>(entityName: "BookmarkCDModel")
    }

    @NSManaged public var authorName: String?
    @NSManaged public var category: String?
    @NSManaged public var content: String?
    @NSManaged public var newsDescription: String?
    @NSManaged public var newsTitle: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var sourceName: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?

}

extension BookmarkCDModel : Identifiable {

}
