//
//  ContentModel.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-10.
//

import Foundation
import SwiftUI

class ContentModel: ObservableObject {
    @AppStorage("idCollection") var idCollection: [String] = []
    
    @Published var liveRoomDetails = RoomSearch()
    @Published var streamerDetails = StreamerSearch()
    
    @Published var allLiveRooms: [RoomSearch] = []
    @Published var allStreamers: [Streamer] = []
    
    @Published var allStreamerInfo: [StreamerInfo] = []
    
    @Published var UIDLiveStatus = [Int: Int]()
    @Published var UIDLiveRoomNumber = [Int: Int]()
    
    @Published var isFetching = false
    
    @Published var roomNotFound = false
    
    func getUserDetails (userId: Int) {
        // Make sure the state "fetching" is true
        self.isFetching = true
        // Create URL
        let urlString = Constants.USERSEARCH_API_URL + String(userId)
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
                        
                        // Assign results
                        DispatchQueue.main.async {
                            self.streamerDetails = result
                            
                            // Add streamer data to allStreamerInfoArray
                            self.allStreamerInfo.append(StreamerInfo(mid: self.streamerDetails.data.mid!, live_status: self.liveRoomDetails.data.live_status!, name: self.streamerDetails.data.name!, face: self.streamerDetails.data.face!))
                            // Add streamer data to array that contains all streamers
                            self.allStreamers.append(self.streamerDetails.data)
                            // print(self.liveRoomDetails.data.live_status)
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
                        DispatchQueue.main.async {
                            self.liveRoomDetails = result
                            self.allLiveRooms.append(self.liveRoomDetails)
                            
                            // Checks if there's a short_id, if so, use it; if not, use the long id
                            if self.liveRoomDetails.data.short_id != 0 {
                                self.UIDLiveRoomNumber.updateValue(self.liveRoomDetails.data.short_id!, forKey: self.liveRoomDetails.data.uid!)
                            } else {
                                self.UIDLiveRoomNumber.updateValue(self.liveRoomDetails.data.room_id!, forKey: self.liveRoomDetails.data.uid!)
                            }
                            
                            self.UIDLiveStatus.updateValue(self.liveRoomDetails.data.live_status!, forKey: self.liveRoomDetails.data.uid!)
                            self.getUserDetails(userId: self.liveRoomDetails.data.uid!)
                            self.isFetching = false
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
                        // Try the short_id
                        // Remove not found room numbers from list
                        self.idCollection = self.idCollection.filter() {$0 != roomId}
                        self.roomNotFound = true
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
        // Make sure the state "fetching" is true
        self.isFetching = true
        for id in IdArray {
            getLiveRoomStatus(roomId: id)
        }
    }
}
