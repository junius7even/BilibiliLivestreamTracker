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
        TabView {
            NavigationView {
                ScrollView {
                    if model.isFetching {
                        Text ("I'm fetching!")
                    } else {
                        ForEach(model.allStreamerInfo) {liver in
                            ProfileCard(streamingStatus: model.UIDLiveStatus[liver.mid]!, profileImageUrl: liver.face, streamerName: liver.name)
                        }
                    }
                }
                .navigationTitle("哔哩哔哩Tracker v1.0")//.getAllRooomStatus(IdArray: BluesisConstants.BluesisIDCollection)
            }
            .tabItem({
                Image("biliTele2")
                Text("Bilibili")
            })
            .onAppear {
                model.getAllLiveRoomStatus(IdArray: BluesisConstants.BluesisIDCollection)
            }
            
            Text("Youtube placeholder")
                .tabItem {
                    Image(systemName: "play.tv.fill")
                    Text("YouTube")
                }
        }
    }
}

struct BluesisView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}

