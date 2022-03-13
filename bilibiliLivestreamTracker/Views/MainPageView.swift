//
//  BluesisView.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-10.
//

import SwiftUI

struct MainPageView: View {
    @EnvironmentObject var model: ContentModel
    @State var liveStatus = -1
    var body: some View {
        NavigationView {
            ScrollView {
                if model.isFetching {
                    Text ("I'm fetching!")
                } else {
                    ForEach(model.allStreamers) {liver in
                        ProfileCard(streamingStatus: model.UIDLiveStatus[liver.mid!]!, profileImageUrl: liver.face!, streamerName: liver.name!)
                    }
                }
            }.onAppear {
                model.getAllLiveRoomStatus(IdArray: BluesisConstants.BluesisIDCollection)
        }
            .navigationTitle("哔哩哔哩Tracker v1.0")//.getAllRooomStatus(IdArray: BluesisConstants.BluesisIDCollection)
            .toolbar {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Button("Refresh") {
                        
                    }
                }
                
            }
        }
    }
}

struct BluesisView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}

