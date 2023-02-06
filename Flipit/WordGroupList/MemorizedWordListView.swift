//
//  MemorizedWordListView.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/07.
//

import SwiftUI
import RealmSwift

struct MemorizedWordListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var MemorizedWordListViewModel: MemorizedWordListViewModel
    @Binding var isMemorizedWordListViewPresented: Bool
    @ObservedResults(Word.self,
                     filter: NSPredicate(format: "isMemorized == %@", NSNumber(value: true)),
                     sortDescriptor: SortDescriptor(keyPath: "timestamp",
                                                    ascending: false)) var memorizedWords
    
    
    var body: some View {
        
        ZStack {
            
            Color.f_navy.ignoresSafeArea()
            
            ZStack {
                
                ZStack {
                    
                    Color.f_navy
                        .border(Color.f_ivory, width: primaryBorderWidth)
                        .offset(x: 8, y: 8)
                    
                    Color.f_navy
                        .border(Color.f_orange, width: primaryBorderWidth)
                    
                }
                
                VStack(spacing: 0) {
                    
                    wordListHeader
                        .zIndex(1)
                        .background(Color.f_navy)
                        .padding([.top, .horizontal], primaryBorderWidth)
                    
                    List {
                        
                        wordListBody
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .zIndex(2)
                        
                    }.listStyle(.plain)
                        
                        .padding([.bottom, .horizontal], primaryBorderWidth)
                        .offset(x: 0, y: -1)

                }
                
            }.padding(25)
        }
    }
}

extension MemorizedWordListView {
    
    var wordListHeader: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text(Image(systemName: "chevron.down"))
                        .font(.title)
                        .fontWeight(.thin)
                        .foregroundColor(Color.f_orange)
                }
                Spacer()
                
            }.padding([.top, .leading, .trailing])
                .padding(.bottom, 12)
            
            HStack {
                
                Text("Memorized words")
                    .foregroundColor(Color.f_orange)
                    .font(.custom("Montserrat-Light", size: 24))
                Spacer()
                
            }.padding([.horizontal])
            
            devider(length: 100)
                .padding(.top, 12)
            
        }
        
    }
    
    var wordListBody: some View {
        
        ForEach(memorizedWords) { word in
                FlippableWordCell {
                    cardFront(text: word.wordString)
                } back: {
                    cardBack(text: word.meaningString)
                }
                .background(Color.f_orange)
                .listRowSeparator(.visible)
                .listRowSeparatorTint(.f_orange)
                .swipeActions(edge: .trailing) {
                    Button {
                        withAnimation(.easeInOut) {
                            MemorizedWordListViewModel.markWordAsNotMemorized(wordId: word._id)
                        }
                    } label: {
                        Text("Ahh.. I don't think I memorized :(")
                            .font(.caption2)
                    }
                    .tint(.f_orange)
                }
                .swipeActions(edge: .leading) {
                    Button(role: .destructive) {
                        withAnimation(.easeInOut) {
                            MemorizedWordListViewModel.deleteWord(wordId: word._id)
                        }
                    } label: {
                        Text("Delete word →")
                    }
                }
        }
        
    }

    
}

//struct MemorizedWordListView_Previews: PreviewProvider {
//    @State var status: Bool = true
//
//    static var previews: some View {
//
//        MemorizedWordListView(MemorizedWordListViewModel: MemorizedWordListViewModel(), isMemorizedWordListViewPresented: $status)
//    }
//}
