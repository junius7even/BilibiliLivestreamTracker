//
//  StreamerInfo.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-13.
//

import Foundation

struct StreamerInfo: Decodable, Identifiable {
    let id = UUID().uuidString
    var mid: Int
    var live_status: Int
    var name: String
    var face: String
}
