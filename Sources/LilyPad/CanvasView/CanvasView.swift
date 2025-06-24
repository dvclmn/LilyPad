//
//  CanvasView.swift
//  LilyPad
//
//  Created by Dave Coleman on 24/6/2025.
//

import BaseHelpers
import SwiftUI

public enum CanvasPhase: Equatable {
  case isHovering(CGPoint)
  //  case isDrawing(Set<MappedTouchPoint>)
  case idle
}

/// The idea here is to provide a view that can Pan and Zoom any View
public struct CanvasView<Content: View>: View {

  public typealias CanvasOutput = (_ hoverPoint: CGPoint?) -> Void
//  public typealias CanvasOutput = (_ hoverPoint: CGPoint?, _ touches: Set<TouchPoint>) -> Void

  @State private var store: CanvasGestureHandler

  let mapStrategy: TrackpadMapStrategy
  let isDragPanEnabled: Bool
  let canvasOutput: CanvasOutput
  let content: Content

  public init(
    mapStrategy: TrackpadMapStrategy,
    zoomRange: ClosedRange<Double>,
    isDragPanEnabled: Bool = false,
    canvasOutput: @escaping CanvasOutput,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self._store = State(initialValue: CanvasGestureHandler(zoomRange: zoomRange))
    self.mapStrategy = mapStrategy
    self.isDragPanEnabled = isDragPanEnabled
    self.canvasOutput = canvasOutput
    self.content = content()
  }

  public var body: some View {
    @Bindable var store = store
    /// This reader should cover the entirety of the 'drawing'
    /// or active Canvas area of the app. But not the UI portion,
    /// such as any sidebars or Inspectors, or even InfoBar etc.
    GeometryReader { proxy in

      /// Worth noting: this is not 'full-bleed' right here, this is
      /// constrained to the trackpad size. Can check it out
      /// with a debug border to see. Just good to know.
      ZStack {
        content
          .frame(
            width: mapStrategy.size(for: proxy.size).width,
            height: mapStrategy.size(for: proxy.size).height
          )
          .scaleEffect(store.zoom)
          .position(proxy.size.midpoint)
          .offset(store.pan)
          .rotationEffect(
            Angle(radians: store.rotation)
          )
          .allowsHitTesting(false)
          .drawingGroup()

      }  // END zstack
    }  // END geo reader

//    .touches(
//      mapStrategy: mapStrategy,
//      showIndicators: false,
//      shouldShowOverlay: true
//        //      shouldShowOverlay: store.preferences.isShowingTrackpadOverlay
//    ) { rawTouches in
//      store.rawTouches = rawTouches
//      //      handleDrawingTouches(rawTouches)
//    }

    .onPanGesture { phase in
      store.handlePanPhase(phase)
    }
    .onZoomGesture(
      zoom: $store.zoom,
      pan: $store.pan,
      zoomRange: store.zoomRange
    ) { anchor in
      store.lastZoomAnchor = anchor
    }

    .mappedHoverLocation(
      isEnabled: true,
      mappingSize: nil
    ) { point in
      store.hoveredPoint = point
    }

//    .dragItemGesture(isEnabled: isDragPanEnabled) { dragValue, initialPoint in
//      print("Performing Pan Tool Gesture")
//      store.pan.width = initialPoint.x + dragValue.translation.width
//      store.pan.height = initialPoint.y + dragValue.translation.height
//    } onDragEnded: { dragValue, initialPoint in
//      CGPoint(
//        x: initialPoint.x + dragValue.translation.width,
//        y: initialPoint.y + dragValue.translation.height
//      )
//    }
    
    #warning("Turn dragItemGesture back on, for panning tool")
    //    .overlay(alignment: .topLeading) {
    //      CanvasDebugView(store: store)
    //        .allowsHitTesting(false)
    //    }

  }
}

extension CanvasView {

  //  private var currentCanvasPhase: CanvasPhase {
  //    if let hoverPoint = store.hoveredPoint, !isDragPanEnabled {
  //      return .isHovering(hoverPoint)
  //    } else {
  //      return .idle
  //    }

  //  }

}
