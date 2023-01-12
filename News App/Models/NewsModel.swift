//
//  NewModel.swift
//  News App
//
//  Created by BJIT  on 12/1/23.
//

import Foundation

// MARK: - NewsModel
struct NewsModel: Codable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}

// business entertainment general health science sports technology
enum NewsCategory: String, CaseIterable {
    case all, business, entertainment, general, health, science, sports, technology
}
