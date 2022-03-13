//
//  DataSearch.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-10.
//

import Foundation

struct RoomSearch: Decodable, Identifiable {
    let id = UUID().uuidString
    var data = Room()
    var code = 0
}
