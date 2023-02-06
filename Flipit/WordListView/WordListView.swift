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
    
    @State private var editmode: EditMode = .inactive
    
    init(viewModel: WordListViewModel, isWordGroupListViewPresented: Binding<Bool>) {
        wordListViewModel = viewModel
        _isWordGroupListViewPresented = isWordGroupListViewPresented
    }
    
    var body: some View {
            VStack(spacing: 0) {
                // 헤더 부분
                VStack(spacing: 0) {
                    
                    HStack {
                        Button {
                            withAnimation(.easeInOut(duration: 0.6).delay(0.2)) {
                                self.isWordGroupListViewPresented.toggle()
                            }
                        } label: {
                            Text(Image(systemName: "line.3.horizontal"))
                                .font(.title)
                                .fontWeight(.thin)
                                .foregroundColor(Color.f_orange)
                        }
                        Spacer()
                    }.padding([.top, .leading, .trailing])
                        .padding(.bottom, 12)
                    
                    HStack {
                        
                        Text(wordListViewModel.fetchedWordGroup?.groupName ?? "NoWordGroupName")
                            .foregroundColor(Color.f_orange)
                            .font(.custom("Montserrat-Light", size: 30))
                        Spacer()
                        
                    }.padding([.horizontal])
                    
                    devider(length: 100)
                        .padding(.top, 12)
                }

                // 단어 리스트
                wordList()
                    .padding([.bottom, .leading, .trailing], primaryBorderWidth)
                    .environmentObject(self.wordListViewModel)
                    .environment(\.editMode, self.$editmode)

            }
    }
}

//struct WordListView_Previews: PreviewProvider {
//    static var previews: some View {
//        WordListView()
//    }
//}


