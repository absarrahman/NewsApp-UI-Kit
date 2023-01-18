//
//  Constants.swift
//  News App
//
//  Created by Moh. Absar Rahman on 12/1/23.
//

import Foundation

class Constants {
    private init(){}
    class Routes {
        private init(){}
        static let goToHome = "goToHome"
        static let goToDetailsViewFromNews = "goToDetailsViewFromNews"
        static let goToBrowserView = "goToBrowserView"
    }
    
    class CommonConstants {
        private init() {}
        static let refreshMinuteInterval:Double = 2.0
        static let imageNotFound = "https://www.publicdomainpictures.net/pictures/280000/velka/not-found-image-15383864787lu.jpg"
    }
    
    class ColorConstants {
        private init() {}
        static let selectedCollectionCell = "SelectedCollectionCellColor"
        static let unselectedCollectionCell = "UnselectedCollectionCellColor"
    }
    
    class CoreDataConstants {
        private init() {}
        static let newsEntityName = "NewsCDModel"
        static let bookmarkEntityName = "BookmarkCDModel"
    }
    
    class UserDefaultConstants {
        private init() {}
        static let lastUpdatedTimeInterval = "lastUpdatedTimeInterval"
        static let pageNumber = "pageNumber"
    }
    
}
