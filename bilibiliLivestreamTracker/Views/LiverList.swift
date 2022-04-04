//
//  LiverList.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-04-03.
//

import SwiftUI

struct LiverList: View {
    @EnvironmentObject var viewModel: ContentModel
    var body: some View {
        NavigationView {
            List {
                ForEach(BluesisConstants.BluesisIDCollection, id: \.self) {liver in
                    Text(liver)
                }
                .onDelete { _ in
                    
                }
            }
            .navigationTitle("List Of Livers")
        }
        
    }
}

struct LiverList_Previews: PreviewProvider {
    static var previews: some View {
        LiverList().environmentObject(ContentModel())
    }
}
