//
//  LiveVideo.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-20.
//

import Foundation

struct LiveVideo: Decodable {
    var id = VideoIdDetails()
    var snippet = LiveVideoDetails()
}
