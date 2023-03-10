//
//  WordListView+FlippableWordCell.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/05.
//

import SwiftUI

struct FlippableWordCell<Front, Back>: View where Front: View, Back: View {
    
    var front: () -> Front
    var back: () -> Back
    
    @State var isFliped: Bool = false
    @State var cardRotation = 0.0
    @State var contentRotation = 0.0
    @State var tapped: Bool = false
    
    @State var lastTappedHash = Date().hashValue
    
    init(@ViewBuilder front: @escaping () -> Front, @ViewBuilder back: @escaping () -> Back) {
        self.front = front
        self.back = back
    }
    
    var body: some View {
        ZStack {
            if (isFliped) {
                back()
            } else {
                front()
            }
        }
        .rotation3DEffect(Angle(degrees: contentRotation), axis: (x: 1, y: 0, z: 0))
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity)
        .onTapGesture {
            if (tapped == false) {
                flipContent()
                tapped = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tapped = false
            }
        }
        .rotation3DEffect(.degrees(cardRotation), axis: (x: 1, y: 0, z: 0))
    }
    
    func flipContent() {
        withAnimation(Animation.linear(duration: 0.35)) {
            cardRotation += 180
            isFliped.toggle()
        }
        withAnimation(Animation.linear(duration: 0.001).delay(0.175)) {
            contentRotation += 180

        }
        let hash = Date().hashValue
        self.lastTappedHash = hash
        turnBackAfterThreeSec(hashValue: hash)
    }
    
    func turnBackAfterThreeSec(hashValue: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3 ) {
            if (isFliped == true && hashValue == lastTappedHash) {
                withAnimation(Animation.linear(duration: 0.35)) {
                    cardRotation += 180
                    isFliped.toggle()
                }
                withAnimation(Animation.linear(duration: 0.001).delay(0.175)) {
                    contentRotation += 180

                }
            }
        }
    }
    
}
