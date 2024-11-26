//
//  ViewModifier.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import SwiftUI

struct TrackpadGestureModifier: ViewModifier {
  @State private var gestureState = TrackpadGestureState()
  var onGestureUpdate: ((TrackpadGestureState) -> Void)?
  
  func body(content: Content) -> some View {
    ZStack {
      content
      TrackpadGestureView(gestureState: $gestureState, onGestureUpdate: onGestureUpdate)
    }
  }
}

extension View {
  func trackpadGestures(onUpdate: @escaping (TrackpadGestureState) -> Void) -> some View {
    modifier(TrackpadGestureModifier(onGestureUpdate: onUpdate))
  }
}

