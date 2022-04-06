//
//  MainPageView.swift
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
    @State private var disableButton = false
    
    @AppStorage("idCollection") var idCollection: [String] = []
    
    private func refreshScreen() -> Void {
        disableButton = true
        // Removes everything from the array to clear the original screen
        model.allStreamerInfo.removeAll()
        // If the array doesn't have any streamers then don't fetch anything
        if !idCollection.isEmpty {
            model.isFetching = true
            model.getAllLiveRoomStatus(IdArray: idCollection)
        }
        // Disable button for 1.5 seconds to avoid excessive refreshing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if !model.isFetching {
                disableButton = false
            }
        }
    }
    
    var body: some View {
        TabView {
            // MARK: Bilibili tracker tab
            NavigationView {
                ScrollView {
                    if idCollection.isEmpty {
                        EmptyStateView()
                    }
                    else if model.isFetching {
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
                                        
                                        idCollection = idCollection.filter(){
                                            $0 != String(
                                                model.UIDLiveRoomNumber[liver.mid]!
                                            ).trimmingCharacters(
                                                in: .whitespacesAndNewlines
                                            )
                                        }
                                        let something2 = print (model.UIDLiveRoomNumber)
                                        let something = print (idCollection)
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
                            .foregroundColor(disableButton ? Color(uiColor: .systemGray2) : Color(UIColor.systemGray6))
                            .padding(4)
                            .background(Color.primary)
                            .cornerRadius(15)
                        }
                        .disabled(disableButton)
                        // MARK: dd more livers button
                        Button {
                            showSheet.toggle()
                        } label: {
                            HStack {
                                Text("添加")
                                    .foregroundColor(disableButton ? Color(uiColor: .systemGray) : Color.primary)
                                Image(systemName: "plus.diamond")
                                    .foregroundColor(disableButton ? Color(uiColor: .systemGray) : Color.primary)
                            }
                            .padding(4)
                            .background(Color(uiColor: .systemGray3))
                            .cornerRadius(15)
                        }
                        .disabled(disableButton)
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
                                idCollection.append(addedLiveroomNumber.trimmingCharacters(in: .whitespacesAndNewlines))
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
                            idCollection.append(addedLiveroomNumber.trimmingCharacters(in: .whitespacesAndNewlines))
                            showSheet = false
                            refreshScreen()
                        } else {
                            showAlert = true
                        }
                    } label: {
                        Text("添加")
                            .foregroundColor(Color(uiColor: .systemGray6))
                            .padding()
                            .background(Color.primary)
                            .cornerRadius(15)
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
            .alert("未找到此房间号！", isPresented: $model.roomNotFound, actions: {
                Button("好的陈sir", role: .cancel) {
                    model.roomNotFound = false
                }
            })
            .tabItem({
                Image("biliTele2")
                    .foregroundColor(Color(uiColor: .systemGray6))
                Text("Bilibili")
            })
            .onAppear {
                // Prevent tab swapping to cause reloading of the page and refetching every single time
                if !hasAppearedOnce && !idCollection.isEmpty {
                    model.getAllLiveRoomStatus(IdArray: idCollection)
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

// MARK: AppStorage extension
// Used to make arrays storable in @AppStorage --> @UserDefaults
// Credit: https://stackoverflow.com/questions/62562534/swiftui-what-is-appstorage-property-wrapper
extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
