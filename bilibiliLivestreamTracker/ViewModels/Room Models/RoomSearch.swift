//
//  DataSearch.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-10.
//

import Foundation

struct RoomSearch: Decodable, Identifiable {
    var id = UUID()
    var data = Room()
    var code = 0
}
