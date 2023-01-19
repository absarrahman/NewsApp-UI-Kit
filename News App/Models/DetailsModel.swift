//
//  DetailsModel.swift
//  News App
//
//  Created by BJIT  on 19/1/23.
//

import Foundation

class DetailsModel {
//    newsTitleLabel.text = newsModel.newsTitle
//    dateLabel.text = newsModel.publishedAt
//    sourceLabel.text = newsModel.sourceName
//    contentDetailsLabel.text = newsModel.content
//    descriptionLabel.text = newsModel.newsDescription
    let newsTitle: String?
    let publishedAt: String?
    let sourceName: String?
    let content: String?
    let newsDescription: String?
    let url: String?
    let isBookmark: Bool
    let urlToImage: String?
    
    init(newsTitle: String?, publishedAt: String?, sourceName: String?, content: String?, newsDescription: String?, url: String?, isBookmark: Bool, urlToImage: String?) {
        self.newsTitle = newsTitle
        self.publishedAt = publishedAt
        self.sourceName = sourceName
        self.content = content
        self.newsDescription = newsDescription
        self.url = url
        self.isBookmark = isBookmark
        self.urlToImage = urlToImage
    }
}
