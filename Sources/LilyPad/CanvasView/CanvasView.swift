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

  @State private var store = CanvasGestureHandler()

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
        .scaleEffect(store.zoom)
        .position(proxy.size.midpoint)
        .offset(store.pan)
        .rotationEffect(
          Angle(radians: store.rotation)
        )
        .drawingGroup()
        /// This may or may not be correct
        .allowsHitTesting(false)
        .animation(.easeOut(duration: 0.1), value: store.pan)


        .onPanGesture { phase in
          store.handlePanPhase(phase)
        }

        //    #warning("Link this up correctly")
        .dragItemGesture(isEnabled: true) { dragValue, initialPoint in
          print("Performing Pan Tool Gesture")
          store.pan.width = initialPoint.x + dragValue.translation.width
          store.pan.height = initialPoint.y + dragValue.translation.height
        } onDragEnded: { dragValue, initialPoint in
          CGPoint(
            x: initialPoint.x + dragValue.translation.width,
            y: initialPoint.y + dragValue.translation.height
          )
        }

        .mappedHoverLocation(
          isEnabled: true,
          mappingSize: proxy.size
        ) { point in
          store.hoveredPoint = point
        }
    }  // END geo reader

    //    .simultaneousGesture(store.zoomGesture(), isEnabled: true)


  }
}

extension CanvasView {


}
