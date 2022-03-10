//
//  Model.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-09.
//

import Foundation

protocol ModelDelegate {
    func roomFetched(_ room: LiveRoom)
}

class Model: ObservableObject {
    @Published var someRoom: LiveRoom?
    var delegate: ModelDelegate?
    
    func getRoomStatus() {
        // Create url object
        let url = URL(string: Constants.ROOMSEARCH_API_URL)
        // Could be nil for some reason
        guard url != nil else {
            return
        }
        // Get url session
        let session = URLSession.shared
        
        // Get a datatask (single call to api)
        let dataTask = session.dataTask(with: url!) { data, response, error in
            // Check if there's errors
            if error != nil || data == nil {
                return
            }
            do {
                // Parsing the data into LiveRoom objects
                let decoder = JSONDecoder()
                let response = try decoder.decode(Response.self, from: data!)
                
                // Set the status of things
                DispatchQueue.main.async {
                    self.someRoom = response.roomData
                }
                dump(response)
                
            } catch {
                
            }
        }
        dataTask.resume()
    }
    
}
