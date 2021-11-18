//
//  MediaListingBO.swift
//  LlaBankDemoP
//
//  Created by Niraj Paul on 16/11/21.
//

import Foundation

struct MediaListingBO: Decodable {
    let page: Page
}

// MARK: - Page
struct Page: Decodable {
    let title, totalContentItems, pageNum, pageSize: String
    let contentItems: ContentItems

    enum CodingKeys: String, CodingKey {
        case title
        case totalContentItems = "total-content-items"
        case pageNum = "page-num"
        case pageSize = "page-size"
        case contentItems = "content-items"
    }
}

// MARK: - ContentItems
struct ContentItems: Decodable {
    let content: [Content]

}

// MARK: - Content
struct Content: Decodable {
    let name,posterImage : String
    enum CodingKeys: String, CodingKey {
        case name
        case posterImage = "poster-image"
    }

}
