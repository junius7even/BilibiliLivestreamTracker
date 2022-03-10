//
//  ContentView.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-09.
//

import SwiftUI

struct ContentView: View {
    @State var room: LiveRoom?
    @State var liveColor: Color = Color.gray
    @StateObject var viewModel = Model()
    
    var body: some View {
        VStack {
            Image("bilibiliLeague")
                .clipShape(Circle())
                .background(Color.black)
                .cornerRadius(10)
                .padding()
            
            HStack {
                Text("Live status: ")
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(liveColor)
            }
            Button("REFRESH") {
                viewModel.getRoomStatus()
                if room?.live_status == 1 {
                    liveColor = Color.green
                } else if room?.live_status == 0 {
                    liveColor = Color.red
                } else {
                    liveColor = Color.gray
                }
            }
            
        }.onAppear {
            viewModel.getRoomStatus()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
