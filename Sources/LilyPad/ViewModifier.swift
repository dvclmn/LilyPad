//
//  ViewModifier.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import SwiftUI

public struct TrackpadGestureModifier: ViewModifier {
  var onGestureUpdate: GestureOutput
  
  public init(onGestureUpdate: @escaping GestureOutput) {
    self.onGestureUpdate = onGestureUpdate
  }
  
  public func body(content: Content) -> some View {
    ZStack {
      content
      TrackpadGestureView(onGestureUpdate: onGestureUpdate)
    }
  }
}

public extension View {
  func trackpadGestures(onUpdate: @escaping GestureOutput) -> some View {
    modifier(TrackpadGestureModifier(onGestureUpdate: onUpdate))
  }
}

