//
//  MemorizedWordListView.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/07.
//

import SwiftUI

struct MemorizedWordListView: View {
    
    @ObservedObject var MemorizedWordListViewModel: MemorizedWordListViewModel
    @Binding var isMemorizedWordListViewPresented: Bool
    
    var wordListHeader: some View {
        VStack {
            Text("Memorized Words")
                .foregroundColor(Color.f_orange)
                .padding(30)
                .font(.custom("Montserrat-Light", size: 30))
                .onTapGesture {
                    withAnimation(.default) {
                        self.isMemorizedWordListViewPresented.toggle()
                    }
                }
        }
    }
    
    var wordListBody: some View {
        ForEach(MemorizedWordListViewModel.MemorizedWords) { word in
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
                            MemorizedWordListViewModel.markWordAsNotMemorized(wordId: word._id)
                        }
                    } label: {
                        Text("Ahh.. I don't Think it's in my brain :(")
                            .font(.caption2)
                    }
                    .tint(.f_orange)
                }
        }
        
    }
    
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
                    
                    Rectangle()
                        .fill(Color.f_orange)
                        .frame(width: nil, height: primaryBorderWidth)
                    List {
                        wordListBody
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }.listStyle(.plain)
                        .padding([.bottom, .horizontal], primaryBorderWidth)

                }
            }.padding(25)
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
