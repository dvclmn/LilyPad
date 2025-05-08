//
//  TouchesView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import SwiftUI
import BaseHelpers

public struct TrackpadTouchesModifier: ViewModifier {
  @State private var viewSize: CGSize = .zero
  @State private var localTouches: Set<TouchPoint> = []
  let showIndicators: Bool
  
  /// Not sure if useful — this allowed the touch indicators to be mapped onto
  /// specific dimensions, but wondering if this should be handled implicitly/consistently elswhere?
//  let mapToSize: CGSize
  let touchUpdates: TouchUpdates

  public init(
    showIndicators: Bool,
//    mapToSize: CGSize,
    touchUpdates: @escaping TouchUpdates
  ) {
    self.showIndicators = showIndicators
//    self.mapToSize = mapToSize
    self.touchUpdates = touchUpdates
  }
  public func body(content: Content) -> some View {
    ZStack {
      content
      if showIndicators {
        TouchIndicatorsView(
          touches: localTouches,
          mapToSize: viewSize
        )
      }
      TrackpadTouchesView { touches, pressure in
        self.localTouches = touches
        touchUpdates(touches, pressure)
      }
    }
    .viewSize { size in
      self.viewSize = size
    }
  }
}
extension View {
  public func touches(
    showIndicators: Bool = true,
    touchUpdates: @escaping TouchUpdates
  ) -> some View {
    self.modifier(
      TrackpadTouchesModifier(
        showIndicators: showIndicators,
        touchUpdates: touchUpdates
      ))
  }
}
