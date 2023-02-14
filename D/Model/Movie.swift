//
//  Movie.swift
//  D
//
//  Created by Kirti S on 2/10/23.
//

import Foundation

struct PageData: Codable {
    let page: Page
}

struct Page: Codable {
    let title, totalContentItems, pageNum, pageSize: String
    let contentItems: MovieArray

    enum CodingKeys: String, CodingKey {
        case title
        case totalContentItems = "total-content-items"
        case pageNum = "page-num"
        case pageSize = "page-size"
        case contentItems = "content-items"
    }
}

struct MovieArray: Codable {
    let content: [Movie]
}

struct Movie: Codable {
    let name: String
    let posterImage: String

    private enum CodingKeys: String, CodingKey {
        case name
        case posterImage = "poster-image"
    }
}

