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
  
  public typealias CanvasOutput = (_ hoveredPoint: CGPoint?) -> Content

  @State private var store: CanvasGestureHandler

  let isDragPanEnabled: Bool
  let content: CanvasOutput

  public init(
    zoomRange: ClosedRange<Double>,
    isDragPanEnabled: Bool = false,
    @ViewBuilder content: @escaping CanvasOutput
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
      content(store.hoveredPoint)
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
    .overlay(alignment: .topLeading) {
      CanvasDebugView(store: store)
        .allowsHitTesting(false)
    }

  }
}

extension CanvasView {


}
