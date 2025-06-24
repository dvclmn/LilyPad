//
//  ZoomViewModifier.swift
//  LilyPad
//
//  Created by Dave Coleman on 24/6/2025.
//

import SwiftUI
import BaseHelpers

public struct ZoomViewModifier: ViewModifier {
  
  @State private var ratioTracker: RatioTracker
  @GestureState private var magnification: CGFloat = 1
  @GestureState private var zoomGestureAnchor: UnitPoint = .center
  
  public func body(content: Content) -> some View {
    content
      .simultaneousGesture(zoomGesture(), isEnabled: true)
  }
}
extension ZoomViewModifier {
  func zoomGesture() -> some Gesture {
    MagnifyGesture()
      .updating($magnification) { value, state, _ in
        state = value.magnification
      }
      .updating($zoomGestureAnchor) { value, state, _ in
        state = value.startAnchor
      }
      .onChanged { value in
        let scale = ratioTracker.ratio(from: value.magnification)
        let newZoom = store.gestureHandler.zoom * scale
        
        /// Convert startAnchor to absolute view coordinates
        let anchorPoint = CGPoint(
          x: store.canvasViewportSize.width * zoomGestureAnchor.x,
          y: store.canvasViewportSize.height * zoomGestureAnchor.y)
        
        /// Position of anchor in canvas space before zooming
        let anchorCanvasPositionBefore = CGPoint(
          x: (anchorPoint.x - store.gestureHandler.pan.x) / store.gestureHandler.zoom,
          y: (anchorPoint.y - store.gestureHandler.pan.y) / store.gestureHandler.zoom
        )
        
        /// New pan that keeps that canvas point under anchorPoint
        let newPan = CGPoint(
          x: anchorPoint.x - anchorCanvasPositionBefore.x * newZoom,
          y: anchorPoint.y - anchorCanvasPositionBefore.y * newZoom
        )
        
        store.gestureHandler.zoom = newZoom
        store.gestureHandler.pan = newPan
      }
      .onEnded { _ in
        ratioTracker.reset()
        store.gestureHandler.zoom = store.gestureHandler.zoom
        store.gestureHandler.pan = store.gestureHandler.pan
      }
    
    //      .updating($magnification) { value, state, _ in
    //        value.startAnchor
    ////        print(
    ////          "`updating` Magnification: \(value.magnification.displayString). Start Anchor: \(value.startAnchor.displayString). Start location: \(value.startLocation.displayString)."
    ////        )
    //        state = value.magnification
    //      }
    //      .onChanged { value in
    //        let ratio = ratioTracker.ratio(from: value.magnification)
    ////        totalZoom *= ratio
    //        store.gestureHandler.zoom *= ratio
    ////        print(
    ////          "`onChanged` ratio: \(ratio.displayString). `store.gestureHandler.zoom`: \(store.gestureHandler.zoom.displayString)"
    ////        )
    //      }
    //      .onEnded { _ in
    //        ratioTracker.reset()
    //      }
  }

}
extension View {
  public func example() -> some View {
    self.modifier(ZoomViewModifier())
  }
}
