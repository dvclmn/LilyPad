//
//  ZoomView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import SwiftUI
import BaseHelpers

public struct ZoomView<Content: View>: View {
  
  @State private var store = ZoomHandler()
  
  let content: Content
  
  public init(
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.content = content()
  }
  
  public var body: some View {
    
    ZStack {
    
      content
      TrackpadTouchesView { touches in
        
        store.touches = touches
//        guard store.isInTouchMode else { return }
//        
//        if store.strokeHandler.touches != touches {
//          store.strokeHandler.touches = touches
//          store.strokeHandler.processTouchesIntoStrokes(config: store.preferences.strokeConfig)
//        }
        
      } onPressureUpdate: { pressure in
        //
      }
    }
    
    
  }
}
#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview(traits: .size(.narrow)) {
  ZoomView {
    Text(TestStrings.paragraphs[5])
  }
  .padding(40)
  .frame(width: 600, height: 700)
  .background(.black.opacity(0.6))
}
#endif

