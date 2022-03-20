//
//  YoutubeTrackerView.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-20.
//

import SwiftUI

struct YoutubeTrackerView: View {
    @EnvironmentObject var model: ContentModel
    var body: some View {
        
        VStack {
            if model.isFetching {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            } else {
                Text(model.youtubeVideos.items[0].snippet.channelTitle!)
                YoutuberProfileCard(profileImageUrl: (model.youtuberItems.items[0].snippet?.thumbnails?.high?.url)!, streamerName: (model.youtubeVideos.items[0].snippet.channelTitle)!, videoId: (model.youtubeVideos.items[0].id.videoId)!)
            }
        }
        .onAppear {
            model.getYoutubeLivestream(streamerName: "CNN")
        }
    }
}

struct YoutubeTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        YoutubeTrackerView()
    }
}
