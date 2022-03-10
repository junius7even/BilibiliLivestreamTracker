//
//  liveRoom.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-09.
//

import Foundation

struct LiveRoom: Decodable {
    var room_id = -1
    var uid = -1
    var live_status = -1
    var need_to_pay = -1
    
    // Specify the keys we're interested in
    enum CodingKeys: String, CodingKey {
        case data
        
        case room_id
        case uid
        case live_status
        case need_to_pay = "is_sp"
    }
    
    // Decoder references json decoder
    // JSON is known as a container
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Get data container
        let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        
        // Parse room_id
        self.room_id = try dataContainer.decode(Int.self, forKey: .room_id)
        
        // Parse uid
        self.uid = try dataContainer.decode(Int.self, forKey: .uid)
        
        // Parse live_status
        self.live_status = try dataContainer.decode(Int.self, forKey: .live_status)
        
        // Parse need_to_pay?
        self.need_to_pay = try dataContainer.decode(Int.self, forKey: .need_to_pay)
    }
    
}
