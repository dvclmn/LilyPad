//
//  ExampleView.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import SwiftUI

struct ExampleView: View {
  
  @State private var displayText = "No gesture detected"
  
  public init() {
  }
  
  var body: some View {
    
    Text("Hello")
      .padding(40)
//      .trackpadGestures { state in

//        self.displayText = """
//        Magnification: \(state.accumulatedMagnification)
//        Rotation: \(state.rotation)
//        Gesture phase: \(state.phase.name)
//        Scroll X: \(state.scrollDeltaX)
//        Scroll Y: \(state.scrollDeltaY)
//        """
//      }
    VStack {
      Text(displayText)
        .padding()
    }
    
  }
}
#if DEBUG

#Preview {
  ExampleView()
}
#endif

