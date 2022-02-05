//
//  WordGroupListView.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/05.
//

import SwiftUI
import RealmSwift

struct WordGroupListView: View {
    
    @ObservedObject var wordGroupListViewModel: WordGroupListViewModel
    @Binding var wordGroupID: ObjectId
    @Binding var isWordGroupListViewPresented: Bool
    
    init(viewModel: WordGroupListViewModel, wordGroupID: Binding<ObjectId>, isWordGroupListViewPresented: Binding<Bool>) {
        self.wordGroupListViewModel = viewModel
        _wordGroupID = wordGroupID
        _isWordGroupListViewPresented = isWordGroupListViewPresented
    }
    
    //MARK: Subviews

    var wordGroupListHeader: some View {
        VStack {
            HStack {
                Image("flipit_logo")
                    .padding()
                Spacer()
            }
            HStack {
                Spacer()
                Button("Settings") {
                    print("settings")
                }.font(.system(size: 18, weight: .light, design: .default))
                    .foregroundColor(.f_orange)
                Button(action: {
                    withAnimation {
                        wordGroupListViewModel.addWordGroup(groupName: "NewWordGroup")
                    }
                }, label: {
                    Label("", systemImage: "plus")
                }).padding()
                    .foregroundColor(.f_orange)
            }
            
        }
    }
    
    func wordGroupCell(wordGroup: WordGroup) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(wordGroup.groupName)
                    .padding(.top, 10)
                    .padding(.bottom, 8)
                    .font(.system(size: 14, weight: .light, design: .default))
                    .foregroundColor(.f_ivory)
                Text("\(wordGroup.words.count) words")
                    .padding(.top, 8)
                    .padding(.bottom, 10)
                    .foregroundColor(.f_ivory)
                    .font(.system(size: 14, weight: .light, design: .default))
                Rectangle()
                    .fill(Color.f_orange)
                    .frame(width: nil, height: 1)
            }
            .padding(.horizontal)
            Spacer()
        }.background(Color.f_navy)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
            .onTapGesture {
                withAnimation(.linear) {
                    if (self.isWordGroupListViewPresented == true) {
                        self.wordGroupID = wordGroup._id
                        self.isWordGroupListViewPresented.toggle()
                    }
                }
            }
    }

    //MARK: BODY
    var body: some View {
            VStack(spacing: 0) {
                wordGroupListHeader
                Rectangle()
                    .fill(Color.f_orange)
                    .frame(width: nil, height: 1)
                List {
                    ForEach(wordGroupListViewModel.wordGroups) { wordGroup in
                        if (wordGroup.isInvalidated == false) {
                            wordGroupCell(wordGroup: wordGroup)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            wordGroupListViewModel.deleteWordGroup(id: wordGroup._id)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }.listStyle(.plain)
                    .padding([.leading, .bottom, .trailing], 1)
            }
    }
}

//struct WordGroupListView_Previews: PreviewProvider {
//    static var previews: some View {
//        WordGroupListView(viewModel: WordGroupListViewModel())
//    }
//}
