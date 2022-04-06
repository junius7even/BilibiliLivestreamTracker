//
//  EmptyStateView.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-04-06.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("目前您还没有\n任何关注的阿婆主")
                .font(.largeTitle)
                .bold()
                .foregroundColor(Color(uiColor: .systemGray))
                .multilineTextAlignment(.center)
            HStack(spacing: 0) {
                Image(systemName: "hand.raised.slash")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .padding(3)
                Image("biliTele2")
                    .resizable()
                    .frame(width: 60, height: 60, alignment: .center)
            }
        }
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView()
    }
}
