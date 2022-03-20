//
//  ChannelDetails.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-20.
//

import Foundation

struct ChannelDetails: Decodable {
    var title: String?
    var thumbnails: Thumbnails?
    var country: String?
}
