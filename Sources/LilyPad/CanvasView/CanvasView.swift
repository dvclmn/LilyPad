//
//  CanvasView.swift
//  LilyPad
//
//  Created by Dave Coleman on 24/6/2025.
//

import BaseHelpers
import SwiftUI

/// The idea here is to provide a view that can Pan and Zoom any View
public struct CanvasView<Content: View>: View {

  @State private var handler = CanvasGestureHandler()

  let content: Content

  public init(
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.content = content()
  }

  public var body: some View {

    /// This reader should cover the entirety of the 'drawing'
    /// or active Canvas area of the app. But not the UI portion,
    /// such as any sidebars or Inspectors, or even InfoBar etc.
    GeometryReader { proxy in

      /// Worth noting: this is not 'full-bleed' right here, this is
      /// constrained to the trackpad size. Can check it out
      /// with a debug border to see. Just good to know.
      content
        .scaleEffect(handler.zoom)
        .position(proxy.size.midpoint)
        .offset(handler.pan.toCGSize)
        .rotationEffect(
          Angle(radians: handler.rotation)
        )
    }  // END geo reader
    .drawingGroup()


  }
}

extension CanvasView {


}
