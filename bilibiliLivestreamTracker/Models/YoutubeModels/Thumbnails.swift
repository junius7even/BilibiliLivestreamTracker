//
//  Thumbnails.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-20.
//

import Foundation

struct Thumbnails: Decodable {
    var `default`: ThumbnailObject?
    var medium: ThumbnailObject?
    var high: ThumbnailObject?
}
