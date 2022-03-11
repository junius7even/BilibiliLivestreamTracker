//
//  ContentModel.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-10.
//

import Foundation
import SwiftUI

class ContentModel: ObservableObject {
    @Published var roomDetails = RoomSearch()
    @Published var userDetails = UserSearch()
    @Published var allRooms: [RoomSearch] = []
    @Published var allUsers: [UserSearch] = []
    
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
                        let result = try decoder.decode(UserSearch.self, from: data!)
                        print(result)
                        // Assign results
                        DispatchQueue.main.async {
                            self.userDetails = result
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
    
    func getRoomStatus (roomId: String) {
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
                        print(result)
                        DispatchQueue.main.async {
                            self.roomDetails = result
                        }
                    } catch {
                        // Error here refers to error from the do block above
                        // There would be a parsing error if its true
                        print (error)
                    }
                    
                }
                
            }
            dataTask.resume()
        }
    }
    func getAllRooomStatus (IdArray: [String]) {
        for id in IdArray {
            getRoomStatus(roomId: id)
            // TODO: put all userNames and profile pictures into an array/dictionary so you can access it in the list with ease
            // MARK: UNFINISHED user pic & name fetching
            //getUserDetails(userId: self.roomDetails.data.uid!)
            // Create copy of roomDetails
            let newRoomDetail = self.roomDetails
            // let newUserDetail = self.userDetails
            self.allRooms.append(newRoomDetail)
           // self.allUsers.append(newUserDetail)
        }
    }
}
