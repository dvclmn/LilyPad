//
//  PanModifier.swift
//  LilyPad
//
//  Created by Dave Coleman on 6/12/2024.
//


import SwiftUI


public typealias PanOutput = (CGPoint) -> Void


public struct PanGestureModifier: ViewModifier {
  
  @State private var panAmount: CGPoint = .zero
  
  let panOutput: PanOutput
  
  public init (panOutput: @escaping PanOutput = { _ in }) {
    self.panOutput = panOutput
  }
  
  public func body(content: Content) -> some View {
    ZStack {
      
      content

      TrackpadGestureView { type, value in
        switch type {
          case .panX:
            self.panAmount.x = value
            
          case .panY:
            self.panAmount.y = value
            
          default: break
        }
      }  // END gesture view
      .task(id: panAmount) {
        self.panOutput(panAmount)
      }
    } // END zstack
  }
}



extension View {
  public func panGesture(_ output: @escaping PanOutput) -> some View {
    self.modifier(
      PanGestureModifier(panOutput: output)
    )
  }
}
