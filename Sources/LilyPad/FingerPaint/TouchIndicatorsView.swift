//
//  TouchIndicatorsView.swift
//  LilyPad
//
//  Created by Dave Coleman on 4/5/2025.
//

import SwiftUI

public struct TouchIndicatorsView: View {
  
  let handler: TouchHandler
  
  public var body: some View {
    
    if handler.isInTouchMode {
      // Visualise Touches
      ForEach(Array(handler.touches), id: \.id) { touch in
        Circle()
          .fill(Color.blue.opacity(0.7))
          .frame(width: 40, height: 40)
          .position(handler.touchPosition(touch))
      }
//      .frame(
//        width: handler.trackPadSize.width,
//        height: handler.trackPadSize.height
//      )
    }
    
  }
}
#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview(traits: .size(.normal)) {
  TouchIndicatorsView(handler: TouchHandler())
}
#endif

