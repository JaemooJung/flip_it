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
    @ObservedResults(WordGroup.self, sortDescriptor: SortDescriptor(keyPath: "timestamp", ascending: false)) var wordGroups
    
    @Binding var isWordGroupListViewPresented: Bool
    @Binding var currentWordGroupId: String
    
    @State private var wordGroupDeleteAlert: Bool = false
    @State private var isWordGroupOnEditing: Bool = false
    @State private var isAddWordGroupSheetPresented: Bool = false
    @State private var isEditWordGroupSheetPresented: Bool = false
    @State private var isMemorizedWordListPresented: Bool = false
    @State private var isSettingViewPresented: Bool = false
    
    @State private var wordGroupToDelete: WordGroup? = nil
    @State private var wordGroupToEdit: WordGroup? = nil
    
    @State private var newWordGroupName: String = ""
    @State private var wordGroupNameToUpdate: String = ""
    
    @FocusState private var newWordGroupNameFocus: Field?
    
    @State private var editmode: EditMode = .inactive
    
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
                
            //Divider
            Rectangle()
                .fill(Color.f_orange)
                .frame(width: nil, height: secondaryBorderWidth)
            
            //List
            List {
                
                //addWordGroupCell
                addWordGroupCell
                    .sheet(item: $wordGroupToEdit) { (wordGroup: WordGroup) in
                        editWordGroupSheet(wordGroupToEdit: wordGroup)
                            .onAppear {
                                self.wordGroupNameToUpdate = wordGroup.groupName
                            }
                    }
                    .alert("Delete notebook", isPresented: $wordGroupDeleteAlert, presenting: wordGroupToDelete) { (wordGroup:WordGroup) in
                        Button("Delete", role: .destructive) {
                            withAnimation {
                                wordGroupListViewModel.deleteWordGroup(id: wordGroup._id)
                            }
                        }
                    } message: { (wordGroup:WordGroup) in
                        Text("[\(wordGroup.groupName)] and every words in this group will be permanantly deleted.")
                    }

                //WordGroups
                ForEach(wordGroups) { wordGroup in
                        wordGroupCell(wordGroup: wordGroup)
                }.zIndex(1)
                
                
                //Memorized Words
                toMemorizedWord
                
            }.listStyle(.plain)
                .padding([.leading, .bottom, .trailing], 1)
                .environment(\.defaultMinListRowHeight, 0)
                .environment(\.editMode, self.$editmode)
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
            
            HStack(spacing: 0) {
            
                Spacer()
                
                Button {
                    isSettingViewPresented.toggle()
                } label: {
                    Text("Settings")
                        .font(.custom("Montserrat-Light", size: 16))
                            .foregroundColor(.f_orange)
                            .padding(.vertical)
                }
                .fullScreenCover(isPresented: $isSettingViewPresented) {
                    SettingsView()
                }

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
                            Text("New Notebook")
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
                        TextField("notebookName", text: self.$newWordGroupName)
                            .focused($newWordGroupNameFocus, equals: .newWordGroupName)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
    
    func editWordGroupSheet(wordGroupToEdit: WordGroup) -> some View {
        
        ZStack {
            Color.f_navy.ignoresSafeArea()
            VStack {
                ZStack {
                    VStack(spacing: 8) {
                        HStack {
                            Text("Edit Notebook")
                                .font(.custom("Montserrat-Light", size: 28))
                            Spacer()
                        }.padding([.top, .horizontal])
                        
                        devider(length: 70)
                        
                        HStack {
                            Text("Name")
                                .font(.custom("Montserrat-Light", size: 20))
                            Spacer()
                        }.padding([.top, .leading, .trailing])
                        
                        TextField("notebookName", text: $wordGroupNameToUpdate)
                            .onSubmit {
                                wordGroupListViewModel.updateWordGroup(id: wordGroupToEdit._id,
                                                                       newWordGroupName: wordGroupNameToUpdate)
                                self.wordGroupToEdit = nil
                            }
                            .padding()
                            .border(Color.f_orange)
                            .padding(.horizontal)
                        
                        Button {
                            wordGroupListViewModel.updateWordGroup(id: wordGroupToEdit._id,
                                                                   newWordGroupName: wordGroupNameToUpdate)
                            self.wordGroupToEdit = nil
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
        .foregroundColor(Color.f_orange)
    }
    
    //-----------------------------------------------------

    func wordGroupCell(wordGroup: WordGroup) -> some View {
        
            Button {
                if (self.isWordGroupOnEditing == true) {
                    withAnimation {
                        isWordGroupOnEditing.toggle()
                    }
                }
                let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                hapticFeedback.impactOccurred()
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
                                    wordGroupToEdit = wordGroup
                                } label: {
                                    Text("Edit")
                                        .foregroundColor(.f_orange)
                                        .font(.custom("Montserrat-Light", size: 16))
                                }
                                
                                Rectangle()
                                    .fill(Color.f_orange)
                                    .frame(width: secondaryBorderWidth, height: 16)
                                
                                Button(role: .destructive) {
                                    wordGroupToDelete = wordGroup
                                    wordGroupDeleteAlert.toggle()
                                } label: {
                                    Text("Delete")
                                        .foregroundColor(.red)
                                        .font(.custom("Montserrat-Light", size: 16))
                                }
                            }
                            .transition(.move(edge: .trailing))
                            .padding(.horizontal)
                            
                        }
                    }
            
                    Rectangle()
                        .fill(Color.f_orange)
                        .frame(width: nil, height: secondaryBorderWidth)
                        .padding(.horizontal)
                    
                }
                
            }
            .background(Color.f_navy)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)

    }
    
    //-----------------------------------------------------

    var addWordGroupCell: some View {
        
        VStack(alignment: .center, spacing: 0) {
            
            HStack {
                Spacer()
                
                Button(action: {
                    print("button tapped")
                    if (self.isWordGroupOnEditing == true) {
                        withAnimation {
                            isWordGroupOnEditing.toggle()
                        }
                    }
                    self.isAddWordGroupSheetPresented.toggle()
                }, label: {
                    Label("", systemImage: "plus")
                        .font(.system(size: 20, weight: .light, design: .default))
                })
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: self.$isAddWordGroupSheetPresented, content: {
                    addWordGroupSheet
                })
                    .padding()
                    .foregroundColor(.f_orange)
                
                Spacer()
            }

                Rectangle()
                    .fill(Color.f_orange)
                    .frame(width: nil, height: secondaryBorderWidth)
                    .padding(.horizontal)


        }
        .background(Color.f_navy)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .listRowSeparator(.hidden)
        
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
        .buttonStyle(.plain)
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
