//
//  WordGroupListView.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/05.
//

import SwiftUI
import RealmSwift
import UIKit

struct WordGroupListView: View {
    
    @ObservedObject var wordGroupListViewModel: WordGroupListViewModel
    
    @Binding var isWordGroupListViewPresented: Bool
    @Binding var currentWordGroupId: String
    
    @State var wordGroupDeleteAlert: Bool = false
    @State var isWordGroupOnEditing: Bool = false
    @State var isAddWordGroupSheetPresented: Bool = false
    @State var isMemorizedWordListPresented: Bool = false
    
    @State var newWordGroupName: String = ""
    @FocusState private var newWordGroupNameFocus: Field?
    
    enum Field: Hashable {
        case newWordGroupName, none
    }
    
    init(viewModel: WordGroupListViewModel,
         isWordGroupListViewPresented: Binding<Bool>,
         currentWordGroupId: Binding<String>) {
        
        self.wordGroupListViewModel = viewModel
        _isWordGroupListViewPresented = isWordGroupListViewPresented
        _currentWordGroupId = currentWordGroupId
    }
    
    //MARK: BODY
    var body: some View {
        VStack(spacing: 0) {
            
            //Header
            wordGroupListHeader
            Rectangle()
                .fill(Color.f_orange)
                .frame(width: nil, height: secondaryBorderWidth)
            
            //List
            List {
                
                //addWordGroupCell
                addWordGroupCell
                
                //WordGroups
                ForEach(wordGroupListViewModel.wordGroups) { wordGroup in
                    if (wordGroup.isInvalidated == false) {
                        wordGroupCell(wordGroup: wordGroup)
                    }
                }
                
                //Memorized Words
                toMemorizedWord
                
            }.listStyle(.plain)
                .padding([.leading, .bottom, .trailing], 1)
                .environment(\.defaultMinListRowHeight, 0)
        }
    }
}

extension WordGroupListView {
    
    //MARK: Functions
    private func addNewWordGroup() {
        withAnimation {
            guard (!self.newWordGroupName.isEmpty) else { return }
            wordGroupListViewModel.addWordGroup(groupName: self.newWordGroupName)
            self.newWordGroupName = ""
            isAddWordGroupSheetPresented.toggle()
        }
    }
    
    private func toSelectedWordList(wordGroup: WordGroup) {
        withAnimation(.easeInOut(duration: 0.4).delay(0.6)) {
            if (self.isWordGroupListViewPresented == true) {
                let currentIdString = wordGroup._id.stringValue
                self.currentWordGroupId = currentIdString
                UserDefaults.standard.set(currentIdString, forKey: keyForWordGroupID)
                self.isWordGroupListViewPresented.toggle()
            }
        }
    }
    
}

extension WordGroupListView {
    
    //MARK: Subviews
    
    //-----------------------------------------------------
    var wordGroupListHeader: some View {
        VStack {
            HStack {
                Image("flipit_logo")
                    .padding()
                Spacer()
            }
            HStack {
                Spacer()
                Button("Edit") {
                    withAnimation {
                        self.isWordGroupOnEditing.toggle()
                    }
                }.font(.custom("Montserrat-Light", size: 16))
                    .foregroundColor(.f_orange)
                    .padding()
            }
            
        }
    }
    //-----------------------------------------------------

    var addWordGroupSheet: some View {
        ZStack {
            Color.f_navy.ignoresSafeArea()
            VStack {
                ZStack {
                    VStack(spacing: 8) {
                        HStack {
                            Text("New Word Group")
                                .font(.custom("Montserrat-Light", size: 28))
                            Spacer()
                        }.padding([.top, .horizontal])
                        
                        devider(length: 70)
                        
                        HStack {
                            Text("Name")
                                .font(.custom("Montserrat-Light", size: 20))
                            Spacer()
                        }.padding([.top, .leading, .trailing])
                        
                        // focus mode 추가하기
                        TextField("GroupName", text: self.$newWordGroupName)
                            .focused($newWordGroupNameFocus, equals: .newWordGroupName)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    self.newWordGroupNameFocus = .newWordGroupName
                                }
                            }
                            .onSubmit {
                                addNewWordGroup()
                            }
                            .padding()
                            .border(Color.f_orange)
                            .padding(.horizontal)
                        
                        Button {
                            addNewWordGroup()
                        } label: {
                            Text("Done")
                        }
                        .padding()
                    }
                }.border(Color.f_orange, width: 1)
                    .padding(30)
                
                Spacer()
            }
        }
    }
    //-----------------------------------------------------

    func wordGroupCell(wordGroup: WordGroup) -> some View {
        
            Button {
                if (self.isWordGroupOnEditing == true) {
                    withAnimation {
                        isWordGroupOnEditing.toggle()
                    }
                }
                toSelectedWordList(wordGroup: wordGroup)
            } label: {
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(wordGroup.groupName)
                                .padding(.top, 14)
                                .padding(.bottom, 8)
                                .font(.custom("Montserrat-Regular", size: 24))
                                .foregroundColor(.f_orange)
                            Text("\(wordGroup.words.filter({ $0.isMemorized == false }).count) words")
                                .padding(.top, 8)
                                .padding(.bottom, 14)
                                .foregroundColor(.f_orange)
                                .font(.custom("Montserrat-Light", size: 16))
                            
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        //onEditing
                        if (isWordGroupOnEditing) {
                            HStack {
                                Button {
                                    //edit
                                } label: {
                                    Text("Edit")
                                        .foregroundColor(.f_orange)
                                        .font(.custom("Montserrat-Light", size: 18))
                                }
                                Rectangle()
                                    .fill(Color.f_orange)
                                    .frame(width: secondaryBorderWidth, height: 18)
                                Button(role: .destructive) {
                                    withAnimation {
                                        wordGroupListViewModel.deleteWordGroup(id: wordGroup._id)
                                    }
                                } label: {
                                    Text("Delete")
                                        .foregroundColor(.red)
                                        .font(.custom("Montserrat-Light", size: 18))
                                }
//                                .alert("Delete \(wordGroup.groupName)", isPresented: $wordGroupDeleteAlert) {
//                                    Button("Delete", role: .destructive) {
//
//                                    }
//                                } message: {
//                                    Text("If you delete word group, all the words will be permanantly deleted.")
//                                }
                                
                            }
                            .transition(.move(edge: .trailing))
                            .padding(.horizontal)
                            
                        }
                        
                    }.background(Color.f_navy)
                    
                    Rectangle()
                        .fill(Color.f_orange)
                        .frame(width: nil, height: secondaryBorderWidth)
                }

            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)

        
    }
    //-----------------------------------------------------

    var addWordGroupCell: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                
                Spacer()
                
                Button(action: {
                    if (self.isWordGroupOnEditing == true) {
                        withAnimation {
                            isWordGroupOnEditing.toggle()
                        }
                    }
                    self.isAddWordGroupSheetPresented.toggle()
                }, label: {
                    Label("", systemImage: "plus")
                        .font(.body)
                }).sheet(isPresented: self.$isAddWordGroupSheetPresented, content: {
                    addWordGroupSheet.background(.ultraThinMaterial)
                })
                    .padding()
                    .foregroundColor(.f_orange)
                
                Spacer()
            }
    
            Rectangle()
                .fill(Color.f_orange)
                .frame(width: nil, height: secondaryBorderWidth)
        }
        .background(Color.f_navy)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
       
        
    }
    
    //-----------------------------------------------------

    func MemorizedWordsCell() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Memorized Words")
                    .padding(.top, 14)
                    .padding(.bottom, 4)
                    .font(.custom("Montserrat-Regular", size: 18))
                    .foregroundColor(.f_orange)
                Text("\(wordGroupListViewModel.memorizedWordCount) words")
                    .padding(.top, 4)
                    .padding(.bottom, 14)
                    .foregroundColor(.f_orange)
                    .font(.custom("Montserrat-Light", size: 14))
            }
            .padding(.horizontal)
            Spacer()
        }.background(Color.f_navy)
    }
    
    var toMemorizedWord: some View {
        Button {
            withAnimation(.linear) {
                if (self.isMemorizedWordListPresented == false) {
                    self.isMemorizedWordListPresented.toggle()
                }
            }
        } label: {
            MemorizedWordsCell()
                .listRowSeparator(.hidden)
        }
        .buttonStyle(PlainButtonStyle())
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .sheet(isPresented: $isMemorizedWordListPresented) {
            MemorizedWordListView(MemorizedWordListViewModel: MemorizedWordListViewModel(),
                                  isMemorizedWordListViewPresented: $isMemorizedWordListPresented)
                .onDisappear {
                    self.wordGroupListViewModel.fetchWordGroup()
                }
            
        }.listRowSeparator(.hidden)
    }
    
    //-----------------------------------------------------

}

//struct WordGroupListView_Previews: PreviewProvider {
//    static var previews: some View {
//        WordGroupListView(viewModel: WordGroupListViewModel())
//    }
//}
