//
//  Data.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-10.
//

import Foundation

struct Room: Decodable {
    var room_id: Int?
    var short_id: Int? // Updated api value for shorthand ids
    var uid: Int?
    var live_status: Int?
    var is_portrait: Bool?
    var is_sp: Int?
}

