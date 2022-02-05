//
//  WordListView.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/05.
//

import SwiftUI
import RealmSwift

struct WordListView: View {
    
    @ObservedObject var wordListViewModel: WordListViewModel
    @Binding var isWordGroupListViewPresented: Bool
    
    init(viewModel: WordListViewModel, isWordGroupListViewPresented: Binding<Bool>) {
        wordListViewModel = viewModel
        _isWordGroupListViewPresented = isWordGroupListViewPresented
    }
    
    var body: some View {
            VStack(spacing: 0) {
                // 헤더 부분
                VStack {
                    Text("WordGroupName")
                        .foregroundColor(Color.f_orange)
                        .padding(25)
                        .font(.custom("Montserrat-Regular", size: 28))
                        .onTapGesture {
                            withAnimation(.default) {
                                self.isWordGroupListViewPresented.toggle()
                            }
                        }
                }
                // 구분선
                Rectangle()
                    .fill(Color.f_orange)
                    .frame(width: nil, height: 2)
                // 단어 리스트
                wordList()
                    .padding([.bottom, .leading, .trailing], 2)
                    .environmentObject(self.wordListViewModel)

            }
    }
}

//struct WordListView_Previews: PreviewProvider {
//    static var previews: some View {
//        WordListView()
//    }
//}
