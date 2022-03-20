//
//  LiveVideoDetails.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-20.
//

import Foundation

struct LiveVideoDetails: Decodable {
    var channelId: String?
    var title: String?
    var thumbnails: Thumbnails?
    var channelTitle: String?
    var liveBroadcastContent: String?
    
}
