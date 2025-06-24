//
//  ZoomViewModifier.swift
//  LilyPad
//
//  Created by Dave Coleman on 24/6/2025.
//

import BaseHelpers
import SwiftUI

public struct ZoomViewModifier: ViewModifier {

  @State private var ratioTracker: RatioTracker
  @GestureState private var magnification: CGFloat = 1
  @GestureState private var zoomGestureAnchor: UnitPoint = .center

  @Binding var zoom: CGFloat
  @Binding var pan: CGPoint

  public init(
    zoom: Binding<CGFloat>,
    pan: Binding<CGPoint>,
    zoomRange: ClosedRange<Double>,
  ) {
    self._zoom = zoom
    self._pan = pan
    
    let tracker = RatioTracker(range: zoomRange)
    self._ratioTracker = State(initialValue: tracker)
  }

  public func body(content: Content) -> some View {
    GeometryReader { proxy in
      content
        .simultaneousGesture(zoomGesture(in: proxy.size), isEnabled: true)
    }
  }
}
extension ZoomViewModifier {
  func zoomGesture(in size: CGSize) -> some Gesture {
    MagnifyGesture()
      .updating($magnification) { value, state, _ in
        state = value.magnification
      }
      .updating($zoomGestureAnchor) { value, state, _ in
        state = value.startAnchor
      }
      .onChanged { value in
        let scale = ratioTracker.ratio(from: value.magnification)
        let newZoom = zoom * scale

        /// Convert startAnchor to absolute view coordinates
        let anchorPoint = CGPoint(
          x: size.width * zoomGestureAnchor.x,
          y: size.height * zoomGestureAnchor.y)

        /// Position of anchor in canvas space before zooming
        let anchorCanvasPositionBefore = CGPoint(
          x: (anchorPoint.x - pan.x) / zoom,
          y: (anchorPoint.y - pan.y) / zoom
        )

        /// New pan that keeps that canvas point under anchorPoint
        let newPan = CGPoint(
          x: anchorPoint.x - anchorCanvasPositionBefore.x * newZoom,
          y: anchorPoint.y - anchorCanvasPositionBefore.y * newZoom
        )

        zoom = newZoom
        pan = newPan
      }
      .onEnded { _ in
        ratioTracker.reset()
      }
  }

}
extension View {
  public func zoomView(
    zoom: Binding<CGFloat>,
    pan: Binding<CGPoint>,
    zoomRange: ClosedRange<Double>,
  ) -> some View {
    self.modifier(
      ZoomViewModifier(
        zoom: zoom,
        pan: pan,
        zoomRange: zoomRange
      )
    )
  }
}
