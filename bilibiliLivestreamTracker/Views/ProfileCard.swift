//
//  ProfileCard.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-13.
//

import SwiftUI
import URLImage

struct ProfileCard: View {
    var streamingStatus: Int // -1: fetching, 0: not streaming, 1: streaming, 2: replaying
    var profileImageUrl: String
    var streamerName: String
    var liveRoomId: Int
    let screenSize: CGRect = UIScreen.main.bounds
    var body: some View {
        let imageUrl = URL(string: profileImageUrl)
        let liveRoomUrl = URL(string: Constants.LIVEROOM_URL + String(liveRoomId))
        Button {
            // Open liveRoomURL upon button press
            UIApplication.shared.open(liveRoomUrl!, options: [:], completionHandler: nil)
        } label: {
            HStack(spacing: 0) {
                URLImage(imageUrl!) {
                    // This view is displayed before download starts
                    EmptyView()
                } inProgress: { progress in
                    // Display progress
                    Text("Loading...")
                } failure: { error, retry in
                    // Display error and retry button
                    VStack {
                        Text(error.localizedDescription)
                        Button("Retry", action: retry)
                    }
                } content: { image in
                    // Downloaded image
                    image
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .cornerRadius(7) // Inner corner radius
                            .padding(5) // Width of the border
                            .background(Color.indigo) // Color of the border
                            .cornerRadius(10) // Outer corner radius
                        .padding(.horizontal, 7)
                        .cornerRadius(10)
                }
                
                Text (streamerName)
                    .foregroundColor(Color.white)
                    .font(.system(size: 20))
                Spacer()
                switch streamingStatus {
                case 0:
                    ZStack {
                        Circle()
                            .fill(Color.red)
                        Circle()
                            .strokeBorder(Color.black, lineWidth: 2)
                    }.frame(width: 35, height: 35, alignment: .trailing)
                        .padding(.trailing, 5)
                case 1:
                    Text("Live")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.green)
                        .fixedSize(horizontal: true, vertical: true)
                        .frame(alignment: .trailing)
                        .padding(.trailing, 5)
                case 2:
                    Text("轮播")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.yellow)
                        .fixedSize(horizontal: true, vertical: true)
                        .frame(alignment: .trailing)
                        .padding(.trailing, 5)
                default:
                    Circle()
                        .strokeBorder(Color.black, lineWidth: 2)
                        .background(Circle().fill(Color.gray))
                        .frame(width: 35, height: 35, alignment: .trailing)
                            .padding(.trailing, 5)
                }
                
            }
            .frame(width: screenSize.width * 9/10, height: 120)
            .background(Color.secondary)
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding(10)
        }
    }
}

//struct ProfileCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileCard(profileImageUrl: "http://i1.hdslb.com/bfs/face/a7fea00016a8d3ffb015b6ed8647cc3ed89cbc63.jpg", streamerName: "Something", streamingStatus: 1)
//    }
//}
