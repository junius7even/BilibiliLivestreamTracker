//
//  ContentModel.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-10.
//

import Foundation
import SwiftUI

class ContentModel: ObservableObject {
    @Published var liveRoomDetails = RoomSearch()
    @Published var streamerDetails = StreamerSearch()
    @Published var allLiveRooms: [RoomSearch] = []
    @Published var allStreamers: [Streamer] = []
    @Published var UIDLiveStatus = [Int: Int]()
    @Published var isFetching = true
    
    func getUserDetails (userId: Int) {
        // Create URL
        let urlString = Constants.USERSEARCH_API_RUL + String(userId)
        let url = URL(string: urlString)
        
        // Check nil
        if let url = url {
            // Create url request
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            
            // Get URLSession
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: request) { data, response, error in
                // Check there isn't any error
                if error == nil {
                    do {
                        // Parse JSON
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(StreamerSearch.self, from: data!)
                        
                        //print(result)
                        // Assign results
                        DispatchQueue.main.async {
                            self.streamerDetails = result
                            // Add streamer data to array that contains all streamers
                            self.allStreamers.append(self.streamerDetails.data)
                            // Add streamer live status to dictinoary [uid: livestatus]
                            print(self.liveRoomDetails.data.live_status!)
                            self.UIDLiveStatus.updateValue(self.liveRoomDetails.data.live_status!, forKey: self.streamerDetails.data.mid!)
                        }
                    } catch {
                        // JSON parsing error
                        print(error)
                    }
                    
                }
            }
            dataTask.resume()
            
        }
    }
    
    func getLiveRoomStatus (roomId: String) {
        // Create URL
        let urlString = Constants.ROOMSEARCH_API_URL + roomId
        let url = URL(string: urlString)
        
        if let url = url {
            // Create url request
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            // Get URLSession
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                // Check there isn't an error
                if error == nil {
                    do {
                        // Parse JSON
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(RoomSearch.self, from: data!)
                        // Assign results to appropriate property
                        //print(result)
                        DispatchQueue.main.async {
                            self.liveRoomDetails = result
                            self.allLiveRooms.append(self.liveRoomDetails)
                            self.getUserDetails(userId: self.liveRoomDetails.data.uid!)
                            print("RoomDetails: \(self.liveRoomDetails)")
                        }
                    } catch DecodingError.dataCorrupted(let context) {
                        print(context)
                    } catch DecodingError.keyNotFound(let key, let context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch DecodingError.valueNotFound(let value, let context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch DecodingError.typeMismatch(let type, let context) {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                    }
                }
                
            }
            dataTask.resume()
        }
    }
    func getAllLiveRoomStatus (IdArray: [String]) {
        for id in IdArray {
            getLiveRoomStatus(roomId: id)
        }
        self.isFetching = false
    }
}
