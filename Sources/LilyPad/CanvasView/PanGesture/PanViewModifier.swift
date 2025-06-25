//
//  TestPanGestureModifier.swift
//  Paperbark
//
//  Created by Dave Coleman on 24/6/2025.
//

import BaseHelpers
import SwiftUI

public struct PanGestureModifier: ViewModifier {
  
  let isEnabled: Bool
  let action: (PanPhase) -> Void

  public func body(content: Content) -> some View {
    GeometryReader { _ in
      content
      if isEnabled {
        PanGestureView { phase in
          //        print("Received phase from `PanGestureView`: \(phase)")
          action(phase)
        }
      }
    }
  }
}
extension View {
  public func onPanGesture(
    isEnabled: Bool = true,
    _ action: @escaping (PanPhase) -> Void
  ) -> some View {
    modifier(
      PanGestureModifier(
        isEnabled: isEnabled,
        action: action
      )
    )
  }
}

