//
//  TrackpadFrameSizeModifier.swift
//  LilyPad
//
//  Created by Dave Coleman on 18/6/2025.
//

import SwiftUI

public struct TrackpadFrameSizeModifier: ViewModifier {
  
  public func body(content: Content) -> some View {
    content
      .frame(
        width: TrackpadTouchesView.trackpadSize.width,
        height: TrackpadTouchesView.trackpadSize.height
      )
  }
}
extension View {
  public func trackpadFrameSize() -> some View {
    self.modifier(TrackpadFrameSizeModifier())
  }
}
