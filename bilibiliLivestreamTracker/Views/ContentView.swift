//
//  ContentView.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-09.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: ContentModel
    static var BluesisIDCollection: [String] = [
        BluesisConstants.Carol_ID,
        BluesisConstants.Jiaran_ID,
        BluesisConstants.Nailin_ID,
        BluesisConstants.Xiangwan_ID,
        BluesisConstants.Bella_ID,
        BluesisConstants.Merry_ID,
        BluesisConstants.Umi_ID,
        BluesisConstants.Shio_ID
    ]
    @State var liveStatus: Int = -1
    @State var liveColor: Color = Color.gray
    
    var body: some View {
        VStack {
            Image("bilibiliLeague")
                .clipShape(Circle())
                .background(Color.black)
                .cornerRadius(10)
                .padding()
            
            HStack {
                Text("\(model.userDetails.data.name ?? "failed"): \(model.roomDetails.data.live_status ?? -1)")
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(liveColor)
            }
            Button("REFRESH") {
                model.getRoomStatus(roomId: "6")
            }
            
        }.onAppear {
            model.getRoomStatus(roomId: "6")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
