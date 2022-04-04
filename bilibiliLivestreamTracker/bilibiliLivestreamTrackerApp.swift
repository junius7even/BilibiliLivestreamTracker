//
//  bilibiliLivestreamTrackerApp.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-09.
//

import SwiftUI

@main
struct bilibiliLivestreamTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            // YoutubeTrackerView().environmentObject(ContentModel())
             MainPageView().environmentObject(ContentModel())
        }
    }
}
