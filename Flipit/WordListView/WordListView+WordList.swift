//
//  WordListView+WordList.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/05.
//

import SwiftUI

struct cardFront: View {
    
    var text: String
    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(.f_ivory)
                .padding()
            Spacer()
        }
        .background(Color.f_navy)
    }
}

struct cardBack: View {
    
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(.f_navy)
                .padding()
            Spacer()
        }
        .background(Color.f_ivory)
    }
    
}

struct wordList: View {
    
    //MARK: Variables
    @EnvironmentObject var wordListViewModel: WordListViewModel
    
    @State var isAddingNewWord: Bool = false
    @State var newWord: String = ""
    @State var newWordMeaning: String = ""
    @State var isAddingNewWordViewClosed: Bool = true
    
    @State var startingOffsetY: CGFloat = 0.0
    @State var currentOffsetY: CGFloat = 0.0
    @State var listGeoReaderHeight: CGFloat = 0.0
    @State var isListPulled: Bool = false
    @State var isListReleased: Bool = false
    @State var invalid: Bool = false
    
    enum Field: Hashable {
        case word, meaning
    }
    
    @FocusState private var focusField: Field?
    
    //MARK: Body
    var body: some View {
        
        VStack(spacing: 0) {
            
            // Add Word
            
            addWordView
            
            //___________________________________
            
            ZStack {
                
                List {
                    
                    // Pull to add a word
                    
                    if (self.isAddingNewWord == false) {
                        
                        GeometryReader { reader -> AnyView in
                            customPullAction(reader: reader)
                            return AnyView(
                                VStack(spacing: 0) {
                                    HStack {
                                        Spacer()
                                        Text("Pull to add new word")
                                            .padding()
                                            .font(.custom("Montserrat-Light", size: 16))
                                            .foregroundColor(.f_orange)
                                        Spacer()
                                    }
                                }
                                
                            )
                        }
                        .background(Color.f_navy)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowSeparatorTint(.f_navy)
                        
                    }
                    
                    //______________________________________________________
                    
                    // Actual Word List
                    wordListBody
                    
                }
                .ignoresSafeArea(.all, edges: .bottom)
                .listStyle(.plain)
                .onTapGesture {
                    if (self.isAddingNewWord == true) {
                        withAnimation(.default) {
                            self.isAddingNewWord.toggle()
                        }
                    }
                }
                
                //-------------------------------------------------------------------
                
                // 단어 추가 중 단어 리스트 흐리게 하는 뷰
                if (self.isAddingNewWord) {
                    VStack {
                        Color.f_navy.contentShape(Rectangle()).opacity(0.5)
                    }.ignoresSafeArea(.all, edges: .bottom)
                }
            }
            
        }
    }
    
}

extension wordList {
    
    //MARK: SubViews
    
    var addWordView: some View {
        VStack(spacing: 0) {
            if (self.isAddingNewWord) {
                HStack {
                    TextField("New word here", text: $newWord)
                        .foregroundColor(Color.f_navy)
                        .padding()
                        .focused($focusField, equals: .word)
                        .onSubmit {
                            withAnimation(.default) {
                                if (newWordMeaning.isEmpty) {
                                    focusField = .meaning
                                } else {
                                    wordListViewModel.addNewWord(newWord: newWord, meaning: newWordMeaning)
                                    newWord = ""
                                    newWordMeaning = ""
                                }
                            }
                        }
                        .submitLabel(.return)
                        .textInputAutocapitalization(.never)
                    Spacer()
                }
                .background(Color.f_ivory)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)
                .onAppear {
                    focusField = .word
                }
                
                HStack {
                    TextField("New meaning here", text: $newWordMeaning)
                        .foregroundColor(Color.f_ivory)
                        .padding()
                        .focused($focusField, equals: .meaning)
                        .onSubmit {
                            withAnimation(.default) {
                                if (!newWord.isEmpty) {
                                    wordListViewModel.addNewWord(newWord: newWord,
                                                                 meaning: newWordMeaning)
                                }
                                newWord = ""
                                newWordMeaning = ""
                                focusField = .word
                            }
                        }
                        .submitLabel(.return)
                        .textInputAutocapitalization(.never)
                    Spacer()
                }
                .background(Color.f_orange)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowSeparator(.hidden)
            }
        }
    }

    var wordListBody: some View {
        ForEach(wordListViewModel.words) { word in
            FlippableWordCell {
                cardFront(text: word.wordString)
            } back: {
                cardBack(text: word.meaningString)
            }
            .listRowSeparator(.visible)
            .listRowSeparatorTint(.f_orange)
            .swipeActions(edge: .trailing) {
                Button {
                    withAnimation(.easeInOut) {
                        wordListViewModel.markWordAsMemorized(wordId: word._id)
                    }
                } label: {
                    Text("← Memorized")
                    
                }
                .tint(.f_orange)
            }
            
            
        }
        //                    .onDelete(perform: { idx in
        //                        let tmpWords = wordListViewModel.Words.reversed()[idx.first!]
        //                        if let ndx = wordListViewModel.Words.firstIndex(of: tmpWords) {
        //                            wordListViewModel.Words.remove(at: ndx)
        //                        }
        //                    })
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        .background(Color.f_orange)
    }
    
}

extension wordList {
    
    //MARK: Functions
    
    func customPullAction(reader: GeometryProxy) {
        DispatchQueue.main.async {
            
            if (self.listGeoReaderHeight == 0) {
                listGeoReaderHeight = reader.frame(in: .global).height
            }
            if (self.startingOffsetY == 0) {
                self.startingOffsetY = reader.frame(in: .global).minY
            }
            self.currentOffsetY = reader.frame(in: .global).minY
            if (currentOffsetY - startingOffsetY > 80 && isListPulled == false && isAddingNewWordViewClosed) {
                self.isListPulled = true
                let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                hapticFeedback.impactOccurred()
            }
            if (currentOffsetY == startingOffsetY && isListPulled == true && isListReleased == false && !isAddingNewWord) {
                isListReleased = true
                toggleAddingNewWordView()
            }
            if (currentOffsetY == startingOffsetY && isListPulled == true && isListReleased == true && invalid == true) {
                invalid = false
                toggleAddingNewWordView()
            }
            if (isAddingNewWord == false && currentOffsetY == startingOffsetY) {
                isAddingNewWordViewClosed = true
            }
            
        }
    }
    
    func toggleAddingNewWordView() {
        
        withAnimation(.easeIn(duration:0.3)) {
            
            if (startingOffsetY == currentOffsetY && isAddingNewWord == false) {
                if (isAddingNewWord == false) {
                    isAddingNewWord.toggle()
                    isAddingNewWordViewClosed = false
                }
                isListPulled = false
                isListReleased = false
            } else {
                invalid = true
            }
            
        }
        
    }
    
}
