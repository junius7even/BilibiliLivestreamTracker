//
//  BluesisView.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-10.
//

import SwiftUI

struct MainPageView: View {
    @StateObject var model = ContentModel()
    @State var liveStatus = -1
    @State var hasAppearedOnce = false
    var body: some View {
        TabView {
            // Bilibili tracker tab
            NavigationView {
                ScrollView {
                    if model.isFetching {
                        ProgressView()
                    } else {
                        ForEach(model.allStreamerInfo) { liver in
                            ProfileCard(
                                streamingStatus: model.UIDLiveStatus[liver.mid]!,
                                profileImageUrl: liver.face,
                                streamerName: liver.name,
                                liveRoomId: model.UIDLiveRoomNumber[liver.mid]!)
                        }
                    }
                }
                .navigationTitle("哔哩哔哩Tracker v1.0")
                .toolbar {
                    // Refresh button
                    Button {
                        model.isFetching = true
                        // Removes everything from the array to clear the original screen
                        model.allStreamerInfo.removeAll()
                        model.getAllLiveRoomStatus(IdArray: BluesisConstants.BluesisIDCollection)
                    } label: {
                        HStack {
                            Text("Refresh")
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }
            .tabItem({
                Image("biliTele2")
                Text("Bilibili")
            })
            .onAppear {
                // Prevent tab swapping to cause reloading of the page and refetching every single time
                if !hasAppearedOnce {
                    model.getAllLiveRoomStatus(IdArray: BluesisConstants.BluesisIDCollection)
                    hasAppearedOnce = true
                }
            }
            
            // Second tab
            Text("Youtube placeholder")
                .tabItem {
                    Image(systemName: "play.tv.fill")
                    Text("YouTube")
                }
        }
    }
}
