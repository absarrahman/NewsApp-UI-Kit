//
//  NewsCDModel+CoreDataProperties.swift
//  News App
//
//  Created by Moh. Absar Rahman on 15/1/23.
//
//

import Foundation
import CoreData


extension NewsCDModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsCDModel> {
        return NSFetchRequest<NewsCDModel>(entityName: "NewsCDModel")
    }

    @NSManaged public var sourceName: String?
    @NSManaged public var authorName: String?
    @NSManaged public var newsTitle: String?
    @NSManaged public var newsDescription: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var content: String?
    @NSManaged public var isBookmarkEnabled: Bool
    @NSManaged public var category: String?

}

extension NewsCDModel : Identifiable {

}
