//
//  CanvasView.swift
//  LilyPad
//
//  Created by Dave Coleman on 24/6/2025.
//

import BaseHelpers
import SwiftUI

public enum CanvasPhase {
  case isHovering(CGPoint)
  case isDrawing([MappedTouchPoint])
  case idle
}

/// The idea here is to provide a view that can Pan and Zoom any View
public struct CanvasView<Content: View>: View {
  
  public typealias CanvasPhaseOutput = (_ canvasPhase: CanvasPhase) -> Content

  @State private var store: CanvasGestureHandler

  let isDrawingEnabled: Bool
  let isDragPanEnabled: Bool
  let content: CanvasPhaseOutput

  public init(
    zoomRange: ClosedRange<Double>,
    isDragPanEnabled: Bool = false,
    @ViewBuilder content: @escaping CanvasPhaseOutput
  ) {
    self._store = State(initialValue: CanvasGestureHandler(zoomRange: zoomRange))
    //    self.zoomRange = zoomRange
    self.isDragPanEnabled = isDragPanEnabled
    self.content = content
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
      content()
        .scaleEffect(store.zoom)
        .position(proxy.size.midpoint)
        .offset(store.pan)
        .rotationEffect(
          Angle(radians: store.rotation)
        )
        //        .animation(.easeOut(duration: 0.1), value: store.pan)

        /// This may or may not be correct
        .allowsHitTesting(false)
        .drawingGroup()

    }  // END geo reader
    .touches(
      showIndicators: false,
      shouldShowOverlay: false
      //        shouldShowOverlay: store.preferences.isShowingTrackpadOverlay
    ) { mappedTouches in
      
      guard isDrawingEnabled else { return }
      let trackpadMapBuilder = MappedTouchPointsBuilder(
        touches: touches,
        in: TrackpadTouchesView.trackpadSize
      )
      let trackpadMapped = trackpadMapBuilder.mappedTouches
      
//      store.mappedTouches = mappedTouches
//      handleEventData(mappedTouches)
    }

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

    //    #warning("Link this up correctly")
    .dragItemGesture(isEnabled: isDragPanEnabled) { dragValue, initialPoint in
      print("Performing Pan Tool Gesture")
      store.pan.width = initialPoint.x + dragValue.translation.width
      store.pan.height = initialPoint.y + dragValue.translation.height
    } onDragEnded: { dragValue, initialPoint in
      CGPoint(
        x: initialPoint.x + dragValue.translation.width,
        y: initialPoint.y + dragValue.translation.height
      )
    }
//    .overlay(alignment: .topLeading) {
//      CanvasDebugView(store: store)
//        .allowsHitTesting(false)
//    }

  }
}

extension CanvasView {


}
