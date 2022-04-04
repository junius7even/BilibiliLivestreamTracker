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
    @State var hasAppeared = false
    var body: some View {
        TabView {
            NavigationView {
                ScrollView {
                    if model.isFetching {
                        Text ("I'm fetching!")
                    } else {
                        ForEach($model.allStreamerInfo) { $liver in
                            ProfileCard(streamingStatus: model.UIDLiveStatus[liver.mid]!, profileImageUrl: $liver.face, streamerName: $liver.name, liveRoomId: model.UIDLiveRoomNumber[liver.mid]!)
                        }
                    }
                }
                .navigationTitle("哔哩哔哩Tracker v1.0")//.getAllRooomStatus(IdArray: BluesisConstants.BluesisIDCollection)
                .toolbar(content: {
                    NavigationLink {
                        LiverList()
                    } label: {
                        Image(systemName: "list.star")
                    }


                })
            }
            .tabItem({
                Image("biliTele2")
                Text("Bilibili")
            })
            .onAppear {
                // Prevent tab swapping to cause reloading of the page every single time
                if !hasAppeared {
                    model.getAllLiveRoomStatus(IdArray: BluesisConstants.BluesisIDCollection)
                    hasAppeared = true
                }
            }
            
//            NavigationView {
//                ScrollView {
//                    if model.isFetching {
//                        Text ("I'm fetching!")
//                    } else {
//                        YoutuberProfileCard(profileImageUrl: (model.youtuberItems.items[0].snippet?.thumbnails?.high?.url)!, streamerName: (model.youtubeVideos.items[0].snippet.channelTitle)!, videoId: (model.youtubeVideos.items[0].id.videoId)!)
////                        YoutuberProfileCard(profileImageUrl: , streamerName: <#T##Binding<String>#>, videoId: $model.youtubeVideos.items[0].id.videoId)
//                    }
//                }
//                .navigationTitle("YouTub Tracker v1.0")//.getAllRooomStatus(IdArray: BluesisConstants.BluesisIDCollection)
//            }
//                .tabItem {
//                    Image(systemName: "play.tv.fill")
//                    Text("YouTube")
//                }
        }
    }
}

struct BluesisView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
    }
}

