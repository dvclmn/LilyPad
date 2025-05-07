//
//  ExampleTouchView.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import SwiftUI
import BaseHelpers

public struct ExampleZoomView: View {
  
  public var body: some View {
    
    Text(TestStrings.paragraphs[5])
      .padding(40)
      .frame(width: 600, height: 700)
      .background(.black.opacity(0.6))
    
  }
}
#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview {
  ExampleZoomView()
}
#endif

