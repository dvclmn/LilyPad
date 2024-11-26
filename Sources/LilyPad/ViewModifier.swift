//
//  ViewModifier.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import SwiftUI

//public struct TrackpadGestureModifier: ViewModifier {
//  var config: TrackpadGestureConfig
//  var onGestureUpdate: GestureOutput
//  
//  public init(
//    config: TrackpadGestureConfig,
//    onGestureUpdate: @escaping GestureOutput
//  ) {
//    self.config = config
//    self.onGestureUpdate = onGestureUpdate
//  }
//  
//  public func body(content: Content) -> some View {
//    ZStack {
//      content
//      TrackpadGestureView(
//        config: config,
//        onGestureUpdate: onGestureUpdate
//      )
//    }
//  }
//}
//
//public extension View {
//  func trackpadGestures(
//    config: TrackpadGestureConfig = .init(),
//    onUpdate: @escaping GestureOutput
//  ) -> some View {
//    modifier(
//      TrackpadGestureModifier(
//        config: config,
//        onGestureUpdate: onUpdate
//      )
//    )
//  }
//}
//
