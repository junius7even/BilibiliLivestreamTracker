//
//  User.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-10.
//

import Foundation

struct Streamer: Decodable, Identifiable {
    let id = UUID().uuidString
    var mid: Int?
    var name: String?
    var face: String?
}
