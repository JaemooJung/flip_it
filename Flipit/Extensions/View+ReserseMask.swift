//
//  View+ReserseMask.swift
//  Flipit
//
//  Created by JaemooJung on 2022/02/07.
//

import SwiftUI

extension View {
  @inlinable
  public func reverseMask<Mask: View> (
    alignment: Alignment = .center,
    @ViewBuilder _ mask: () -> Mask
  ) -> some View {
    self.mask {
      Rectangle()
        .overlay(alignment: alignment) {
          mask()
            .blendMode(.destinationOut)
        }
    }
  }
}
