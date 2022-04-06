//
//  BluesisView.swift
//  bilibiliLivestreamTracker
//
//  Created by junius7even on 2022-03-10.
//

import SwiftUI

struct MainPageView: View {
    @StateObject var model = ContentModel()
    @State private var addedLiveroomNumber = ""
    @State private var hasAppearedOnce = false
    @State private var showSheet = false
    @State private var showAlert = false
    
    private func refreshScreen() -> Void {
        // Removes everything from the array to clear the original screen
        model.allStreamerInfo.removeAll()
        // If the array doesn't have any streamers then don't fetch anything
        if BluesisConstants.BluesisIDCollection.count != 0 {
            model.isFetching = true
            model.getAllLiveRoomStatus(IdArray: BluesisConstants.BluesisIDCollection)
        }
    }
    
    var body: some View {
        TabView {
            // MARK: Bilibili tracker tab
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
                            // The menu when you use a force touch on the profileCard
                                .contextMenu(menuItems: {
                                    Button(role: .destructive, // makes the button red
                                        action: {
                                        BluesisConstants.BluesisIDCollection = BluesisConstants.BluesisIDCollection.filter(){$0 != String(model.UIDLiveRoomNumber[liver.mid]!).trimmingCharacters(in: .whitespacesAndNewlines)}
                                        let something = print(BluesisConstants.BluesisIDCollection)
                                        let something2 = print("\(model.UIDLiveRoomNumber)")
                                        // Always refresh screen when user deletes a streamer
                                        // to ensure display is up to date (not displaying something that isn't
                                        // supposed to be there
                                        refreshScreen()
                                    }, label: {
                                        HStack {
                                            Text("从监视列表删除")
                                            Spacer()
                                            Image(systemName: "trash")
                                        }
                                    })
                                })
                        }
                    }
                }
                .navigationBarTitle("哔哩哔哩Tracker v1.0", displayMode: .inline)
                .toolbar {
                    HStack {
                        // MARK: Refresh button
                        Button {
                            refreshScreen()
                        } label: {
                            HStack {
                                Text("刷新")
                                Image(systemName: "arrow.clockwise")
                            }
                            .foregroundColor(Color(UIColor.systemGray6))
                            .padding(4)
                            .background(Color.primary)
                            .cornerRadius(15)
                        }
                        // MARK: dd more livers button
                        Button {
                            showSheet.toggle()
                        } label: {
                            HStack {
                                Text("添加")
                                    .foregroundColor(Color.primary)
                                Image(systemName: "plus.diamond")
                                    .foregroundColor(Color.primary)
                            }
                            .padding(4)
                            .background(Color(uiColor: .systemGray3))
                            .cornerRadius(15)
                        }
                    }
                }
            }
            .sheet(isPresented: $showSheet, onDismiss: {
                addedLiveroomNumber = ""
            }, content: {
                VStack(alignment: .center) {
                    Text("请输入直播间号")
                    TextField("", text: $addedLiveroomNumber)
                        .submitLabel(.done)
                        .onSubmit {
                            // Checks if the submitted text is fully integer
                            if let submittedText: Int = Int(addedLiveroomNumber.trimmingCharacters(in: .whitespacesAndNewlines)) {
                                BluesisConstants.BluesisIDCollection.append(addedLiveroomNumber.trimmingCharacters(in: .whitespacesAndNewlines))
                                showSheet = false
                                refreshScreen()
                            } else {
                                showAlert = true
                            }
                        }
                        .foregroundColor(Color(UIColor.systemGray2))
                        .padding()
                        .background(Color.primary)
                        .cornerRadius(15)
                    Button {
                        // Checks if the submitted text is fully integer
                        if let submittedText: Int = Int(addedLiveroomNumber.trimmingCharacters(in: .whitespacesAndNewlines)) {
                            BluesisConstants.BluesisIDCollection.append(addedLiveroomNumber.trimmingCharacters(in: .whitespacesAndNewlines))
                            showSheet = false
                            refreshScreen()
                        } else {
                            showAlert = true
                        }
                    } label: {
                        Text("添加")
                            .foregroundColor(Color(uiColor: .systemBlue))
                            .padding(4)
                            .background(Color.primary)
                            .cornerRadius(15)
                            .shadow(color: Color.gray, radius: 15)
                    }

                }
                .alert("请输入正确的直播间号! \n纯数字!", isPresented: $showAlert, actions: {
                    Button("Ok", role: .cancel) {
                        showAlert = false
                    }
                })
                .multilineTextAlignment(.center)
                .padding()
            })
            .tabItem({
                Image("biliTele2")
                    .foregroundColor(Color(uiColor: .systemGray6))
                Text("Bilibili")
            })
            .onAppear {
                // Prevent tab swapping to cause reloading of the page and refetching every single time
                if !hasAppearedOnce {
                    model.getAllLiveRoomStatus(IdArray: BluesisConstants.BluesisIDCollection)
                    hasAppearedOnce = true
                }
            }
            
            // MARK: Settings tab
            Text("设置")
                .tabItem {
                    Image(systemName: "gear")
                    Text("设置")
                }
        }
    }
}
