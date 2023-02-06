//
//  onboardingView.swift
//  Flip_it
//
//  Created by JaemooJung on 2022/02/25.
//

import SwiftUI

struct onboardingView: View {
    
    @Binding var isOnboardingPresented: Bool
    
    var body: some View {

            
        TabView {
            firstPage
            secondPage
            thirdPage
            forthPage
            fifthPage
            sixthPage
        }
        .background(Color.f_navy.ignoresSafeArea())
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        
    }
}

extension onboardingView {
    
    var firstPage: some View {

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    HStack {
                        Text("Welcome to")
                            .font(.custom("Montserrat-ExtraLight", size: 30))
                        Image("flipit_logo_lighter")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: nil, height: 30)
                            .offset(x: -2, y: 2)
                    }.padding()
                    Spacer()
                }.padding([.horizontal, .bottom])
                Image(systemName: "arrow.right")
                    .font(.system(size: 35, weight: .ultraLight, design: .default))
            }
            .foregroundColor(.f_orange)
    }
    
    var secondPage: some View {
        
        VStack(spacing: 0) {
            
            Text("Add new notebook")
                .font(.custom("Montserrat-Light", size: 24))
                .padding()
            Image("example_add_notebook")
                .resizable().scaledToFit()
                .shadow(radius: 20)
                .border(Color.f_orange, width: 0.5)
                .padding()
            
            Text("tap + button to add a new notebook.")
                .font(.custom("Montserrat-Light", size: 16))
                .foregroundColor(.f_ivory)
                .padding()
        }
        .foregroundColor(.f_orange)
    }
    
    var thirdPage: some View {
        
        VStack(spacing: 0) {
            
            Text("Add word")
                .font(.custom("Montserrat-Light", size: 24))
                .padding()
            Image("example_add_word")
                .resizable().scaledToFit()
                .shadow(radius: 20)
                .border(Color.f_orange, width: 0.5)
                .padding()
            
            Text("Pull down the list to add a new word.")
                .font(.custom("Montserrat-Light", size: 16))
                .foregroundColor(.f_ivory)
                .padding()
        }
        .foregroundColor(.f_orange)
    }
    
    var forthPage: some View {
        
        VStack(spacing: 0) {
            
            Text("Mark Memorized")
                .font(.custom("Montserrat-Light", size: 24))
                .padding()
            Image("example_mark_memorized")
                .resizable().scaledToFit()
                .shadow(radius: 20)
                .border(Color.f_orange, width: 0.5)
                .padding()
            
            Text("Swipe the word left to mark memorized.")
                .font(.custom("Montserrat-Light", size: 16))
                .foregroundColor(.f_ivory)
                .padding()
        }
        .foregroundColor(.f_orange)
    }
    
    var fifthPage: some View {
        
        VStack(spacing: 0) {
            
            Text("Memorized words")
                .font(.custom("Montserrat-Light", size: 24))
                .padding()
            Image("example_memorized_word")
                .resizable().scaledToFit()
                .shadow(radius: 20)
                .border(Color.f_orange, width: 0.5)
                .padding()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("You can check the memorized words.")
                    .font(.custom("Montserrat-Light", size: 16))
                    .foregroundColor(.f_ivory)
                
                Text("Swipe left to mark unmemorized, and swipe right to delete.")
                    .font(.custom("Montserrat-Light", size: 16))
                    .foregroundColor(.f_ivory)
            }.padding()
            
        }
        .foregroundColor(.f_orange)
    }
    
    var sixthPage: some View {
        
        VStack {
            Spacer()
            HStack {
                Text("And now it's time to...")
                    .font(.custom("Montserrat-Light", size: 20))
                Image("flipit_logo_lighter")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: nil, height: 30)
                    .offset(x: -2, y: 2)
            }.padding()
            
            Button {
                withAnimation(.default) {
                    self.isOnboardingPresented.toggle()
                }
            } label: {
                HStack{
                    Text("Start")
                        .font(.custom("Montserrat-Light", size: 28))
                }
            }.foregroundColor(.f_ivory)
                .padding()
            Spacer()

        }.foregroundColor(.f_orange)
        
       
    }
    
}



//struct onboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            onboardingView()
//        }
//    }
//}
