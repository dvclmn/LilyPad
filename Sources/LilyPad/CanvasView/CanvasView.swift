//
//  CanvasView.swift
//  LilyPad
//
//  Created by Dave Coleman on 24/6/2025.
//

import BaseHelpers
import SwiftUI

//public enum CanvasPhase: Equatable {
//  case isHovering(CGPoint)
////  case isDrawing(Set<MappedTouchPoint>)
//  case idle
//}

/// The idea here is to provide a view that can Pan and Zoom any View
public struct CanvasView<Content: View>: View {

  public typealias CanvasPhaseOutput = (_ hoverPoint: CGPoint?) -> Content
//  public typealias CanvasPhaseOutput = (_ canvasPhase: CanvasPhase) -> Content

  @State private var store: CanvasGestureHandler

  let mapStrategy: TrackpadMapStrategy
//  let isDrawingEnabled: Bool
  let isDragPanEnabled: Bool
  let content: CanvasPhaseOutput

  public init(
    mapStrategy: TrackpadMapStrategy,
//    isDrawingEnabled: Bool,
    zoomRange: ClosedRange<Double>,
    isDragPanEnabled: Bool = false,
    @ViewBuilder content: @escaping CanvasPhaseOutput
  ) {
    self._store = State(initialValue: CanvasGestureHandler(zoomRange: zoomRange))
    self.mapStrategy = mapStrategy
    self.isDragPanEnabled = isDragPanEnabled
//    self.isDrawingEnabled = isDrawingEnabled
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
      ZStack {
        content(store.hoveredPoint)
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
        
      } // END zstack
//      .frame(maxWidth: .infinity, maxHeight: .infinity)
      //        .animation(.easeOut(duration: 0.1), value: store.pan)
//      .touches(
//        mapStrategy: mapStrategy,
//        showIndicators: false,
//        shouldShowOverlay: true
//        //        shouldShowOverlay: store.preferences.isShowingTrackpadOverlay
//      ) { rawTouches in
//        
//        guard isDrawingEnabled else { return }
//        
//        print("Did we get past the drawing mode guard?")
//        let trackpadMapBuilder = MappedTouchPointsBuilder(
//          touches: rawTouches,
//          in: proxy.size
//        )
////        let trackpadMapBuilder = MappedTouchPointsBuilder(
////          touches: touches,
////          in: mapStrategy.size(for: proxy.size)
////        )
//        let mapped = trackpadMapBuilder.mappedTouches
//        
//              store.mappedTouches = mapped
//        //      handleEventData(mappedTouches)
//      }

      /// This may or may not be correct

    }  // END geo reader

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

//  private var currentCanvasPhase: CanvasPhase {
//    if let hoverPoint = store.hoveredPoint, !isDragPanEnabled {
//      return .isHovering(hoverPoint)
//    } else {
//      return .idle
//    }

//  }

}
