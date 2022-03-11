//
//  BluesisView.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-10.
//

import SwiftUI

struct BluesisView: View {
    @EnvironmentObject var model: ContentModel
    @State var liveStatus = -1
    var body: some View {
        NavigationView {
            List {
                ForEach (model.allRooms) {tuberRoom in
                    Text ("Hi")
                }
            }
            .navigationTitle("Overview")
        }.onAppear {
            model.getAllRooomStatus(IdArray: BluesisConstants.BluesisIDCollection)
        }
}

    struct BluesisView_Previews: PreviewProvider {
        static var previews: some View {
            BluesisView()
        }
    }
}
