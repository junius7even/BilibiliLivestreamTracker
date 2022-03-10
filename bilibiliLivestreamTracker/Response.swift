//
//  Response.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-09.
//

import Foundation

struct Response: Decodable {
    var roomData: LiveRoom?
    
    enum CodingKeys: String, CodingKey {
        case roomData
    }
    
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Parses the json into a liveRoom object
        self.roomData = try container.decode(LiveRoom.self, forKey: .roomData)
    }
}
