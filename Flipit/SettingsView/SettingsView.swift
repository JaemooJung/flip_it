//
//  SettingsView.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/21.
//

import SwiftUI


struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var mailData = ComposeMailData(subject: "About Flipit :",
                                                  recipients: ["dbdbwer@naver.com"],
                                                  message: "",
                                                  attachments: nil)
    @State private var showMailView = false
    
    let blogURL: URL = URL(string: "https://foufou.tistory.com/")!
    let githubURL: URL = URL(string: "https://github.com/JaemooJung")!
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            
            //Setting List
            settingsViewList
            //Header
                .safeAreaInset(edge: .top) {
                    SettingsViewHeader
                }
                .background(Color.f_navy)
                .navigationBarHidden(true)
        }
    }
}

extension SettingsView {
    
    private var SettingsViewHeader: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Label("", systemImage: "xmark")
                    .font(.system(size: 30,
                                  weight: .thin,
                                  design: .default))
                    .foregroundColor(.f_orange)
                    .padding(.bottom)
            }
            
            HStack() {
                Text("Settings")
                    .foregroundColor(Color.f_orange)
                    .font(.custom("Montserrat-Light", size: 36))
                Spacer()
                
            }
            Rectangle().frame(width: 100, height: secondaryBorderWidth, alignment: .leading)
                .foregroundColor(.f_orange)
                .padding(.top)
        }
        .padding()
        .background(Color.f_navy.opacity(0.9))
    }
    
    private var settingsViewList: some View {
        List {
            Section {
                Link("Change Language", destination: URL(string: UIApplication.openSettingsURLString)!)
            } header: {
                Text("Language").font(.custom("Montserrat-Light", size: 16))
            }
            .listRowBackground(Color.f_navy)
            .listRowSeparatorTint(.f_orange)
            
            Section {
                HStack {
                    Link("Blog", destination: blogURL)
                    Spacer()
                    Text(blogURL.absoluteString).font(.caption2).opacity(0.7)
                }
                
                HStack {
                    Link("Github", destination: githubURL)
                    Spacer()
                    Text(githubURL.absoluteString).font(.caption2).opacity(0.7)
                }
                
                HStack {
                    Button(action: {
                        showMailView.toggle()
                    }) {
                        Text("E-mail")
                    }.disabled(!MailView.canSendMail)
                        .sheet(isPresented: $showMailView) {
                            MailView(data: $mailData) { result in
                                print(result)
                            }
                        }
                    Spacer()
                    Text(mailData.recipients?.first ?? "noEmail").font(.caption2).opacity(0.7)
                }
                
                
            } header: {
                Text("Developer's info").font(.custom("Montserrat-Light", size: 16))
            } footer: {
                Text("Made by jeamjung of 42 Seoul").font(.custom("Montserrat-Light", size: 16)).padding(.top, 4)
            }
            .listRowBackground(Color.f_navy)
            .listRowSeparatorTint(.f_orange)
            
        }
        .foregroundColor(.f_orange)
        .listStyle(.grouped)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
