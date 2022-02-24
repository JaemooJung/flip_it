//
//  Components.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/15.
//

import SwiftUI

let keyForWordGroupID: String = "lastWordGroupID"

struct devider: View {
    
    let length: CGFloat
    
    var body: some View {
        
        HStack {
            Rectangle()
                .fill(Color.f_orange)
                .frame(width: length, height: secondaryBorderWidth)
            Spacer()
        }.padding(.leading)
    }
}
