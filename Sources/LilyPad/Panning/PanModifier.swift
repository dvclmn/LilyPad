//
//  PanModifier.swift
//  LilyPad
//
//  Created by Dave Coleman on 6/12/2024.
//


import SwiftUI
import BaseHelpers

public typealias PanOutput = (CGPoint) -> Void

public struct PanState {
  public var delta: CGPoint = .zero
  public var total: CGPoint = .zero
}

public struct PanGestureModifier: ViewModifier {
  
  @Binding var panAmount: CGPoint
  
  @State private var panState: PanState = .init()
  let sensitivity: CGFloat

  public init(
    panAmount: Binding<CGPoint>,
    sensitivity: CGFloat = 0.8
  ) {
    self._panAmount = panAmount
    self.sensitivity = sensitivity
  }
  
  public func body(content: Content) -> some View {
    content
      .onAppear {
        NSEvent
          .addLocalMonitorForEvents(matching: .scrollWheel) { event in
          
            panAmount.x = self.updatePanGesture(
              axis: .horizontal,
              delta: event.scrollingDeltaX
            ).x
            
            panAmount.y = self.updatePanGesture(
              axis: .vertical,
              delta: event.scrollingDeltaY
            ).y
            
            print("`scrollingDeltaX` vs `deltaX`: | \(event.scrollingDeltaX) vs \(event.deltaX) |")
            
            return event

        }
      }
  }
}

extension PanGestureModifier {
  
  func updatePanGesture(axis: Axis, delta: CGFloat) -> CGPoint {
    
    var newPanState = panState
    
    switch axis {
        case .horizontal:
        newPanState.delta.x = delta * sensitivity
        newPanState.total.x = panState.total.x + newPanState.delta.x
        
      case .vertical:
        newPanState.delta.y = delta * sensitivity
        newPanState.total.y = panState.total.y + newPanState.delta.y
    }
    
    return newPanState.total
  }
}

extension View {
  public func panGesture(
    _ panAmount: Binding<CGPoint>,
    sensitivity: CGFloat = 0.8
  ) -> some View {
    self.modifier(
      PanGestureModifier(
        panAmount: panAmount,
        sensitivity: sensitivity
      )
    )
  }
//  public func panGesture(_ output: @escaping PanOutput) -> some View {
//    self.modifier(
//      PanGestureModifier(panOutput: output)
//    )
//  }
}
