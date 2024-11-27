//
//  ExampleView.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import SwiftUI


struct GestureExampleView: View {
  
  @State private var gestureValues: GestureValues = .init()
  
  public init() {
  }
  
  var body: some View {
    
      Text("Hello")
      .trackpadGestures()
      .background(.black.opacity(0.8))
      .background(.purple.opacity(0.3))

  }
}
#if DEBUG
#Preview(traits: .fixedLayout(width: 500, height: 700)) {
  GestureExampleView()
}
#endif

