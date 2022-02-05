//
//  MainView.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/05.
//

import SwiftUI
import RealmSwift

struct MainView: View {
    
    @State var isWordGroupListViewPresented: Bool = true
    @State var currentWordGroupId: ObjectId = ObjectId()
    
    var body: some View {
        ZStack {
            Color.f_navy.ignoresSafeArea()
            ZStack {
                ZStack {
                    Color.f_navy
                        .border(Color.f_ivory, width: 1)
                        .offset(x: 6, y: 6)
                    Color.f_navy
                        .border(Color.f_orange, width: 1)
                }
                if (isWordGroupListViewPresented == true) {
                    WordGroupListView(viewModel: WordGroupListViewModel(), wordGroupID: $currentWordGroupId,
                                      isWordGroupListViewPresented: self.$isWordGroupListViewPresented)
                } else {
                    WordListView(viewModel: WordListViewModel(wordGroupId: currentWordGroupId), isWordGroupListViewPresented: $isWordGroupListViewPresented)
                }
            }.padding(20)
        }
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
