//
//  PanModifier.swift
//  LilyPad
//
//  Created by Dave Coleman on 6/12/2024.
//


import SwiftUI

public typealias PanOutput = (CGPoint) -> Void

public struct PanGestureModifier: ViewModifier {
  
  @Binding private var panAmount: CGPoint
  @State private var previousPanAmount: CGPoint = .zero

  public init(panAmount: Binding<CGPoint>) {
    self._panAmount = panAmount
  }
  
  public func body(content: Content) -> some View {
    content
      .onAppear {
        NSEvent
          .addLocalMonitorForEvents(matching: .scrollWheel) { event in
          
//            print("Locally monitoring Scroll events: \(event)")
            
            panAmount.x = event.scrollingDeltaX
            panAmount.y = event.scrollingDeltaY
            
            print("`scrollingDeltaX` vs `deltaX`: | \(event.scrollingDeltaX) vs \(event.deltaX) |")
            
            return event
//          if insideCircle {
//            circleZoom += event.scrollingDeltaY/100
//            if circleZoom < 0.1 {circleZoom = 0.1}
//          }
//          return event
        }
      }
//    ZStack {
//      content
//      TrackpadGestureView { type, value in
//        switch type {
//          case .panX:
//            self.panAmount.x = value
//            
//          case .panY:
//            self.panAmount.y = value
//            
//          default: break
//        }
//      }  // END gesture view
//    } // END zstack
  }
}

extension View {
  public func panGesture(_ panAmount: Binding<CGPoint>) -> some View {
    self.modifier(
      PanGestureModifier(panAmount: panAmount)
    )
  }
//  public func panGesture(_ output: @escaping PanOutput) -> some View {
//    self.modifier(
//      PanGestureModifier(panOutput: output)
//    )
//  }
}
