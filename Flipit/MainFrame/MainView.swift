//
//  MainView.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/05.
//

import SwiftUI
import RealmSwift

struct MainView: View {
    
    @State var isWordGroupListViewPresented: Bool
    @State var currentWordGroupId: String
    @State var backFrameOffsetX: CGFloat = 8
    @State var backFrameOffsetY: CGFloat = 8
    
    init() {
        if let lastWordGroupID = UserDefaults.standard.string(forKey: keyForWordGroupID) {
            print(lastWordGroupID)
            self.currentWordGroupId = lastWordGroupID
            backFrameOffsetX = 0
            backFrameOffsetY = 0
            self.isWordGroupListViewPresented = false
        } else {
            self.currentWordGroupId = ""
            isWordGroupListViewPresented = true
        }
    }
    
    var body: some View {
        
        ZStack {
            Color.f_navy.ignoresSafeArea()
            ZStack {
                
                ZStack {
                    
                    Color.f_navy
                        .border(Color.f_ivory, width: primaryBorderWidth)
                        .offset(x: backFrameOffsetX, y: backFrameOffsetY)
                    Color.f_navy
                    
                }
                
                if (self.isWordGroupListViewPresented == false) {
                    WordListView(viewModel: WordListViewModel(wordGroupId: currentWordGroupId),
                                 isWordGroupListViewPresented: $isWordGroupListViewPresented)
                        .disabled(isWordGroupListViewPresented)
                        .transition(.opacity)
                        .allowsHitTesting(!isWordGroupListViewPresented)
                        .zIndex(1)
                } else {
                    ZStack {
                        Color.f_navy
                        WordGroupListView(viewModel: WordGroupListViewModel(),
                                          isWordGroupListViewPresented: $isWordGroupListViewPresented,
                                          currentWordGroupId: $currentWordGroupId)
                        
                    }.transition(.move(edge: .leading))
                        .allowsHitTesting(isWordGroupListViewPresented)
                        .zIndex(2)
                }
                
            }.padding(25)
            
            Color.f_navy.ignoresSafeArea()
                .reverseMask {
                    Rectangle().padding([.top, .leading], 25)
                }
                .allowsHitTesting(false)
            
            Color.f_navy
                .opacity(0)
                .border(Color.f_orange, width: primaryBorderWidth)
                .padding(25)
                .allowsHitTesting(false)
            
        }
        .onChange(of: isWordGroupListViewPresented) { newValue in
            shiftWordGroupListFrame()
        }
    }
    
    func shiftWordGroupListFrame() {
        withAnimation(.spring().delay(0.3)) {
            if (isWordGroupListViewPresented == true) {
                backFrameOffsetX = 8
                backFrameOffsetY = 8
            } else {
                backFrameOffsetY = 0
                backFrameOffsetX = 0
            }
        }
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
