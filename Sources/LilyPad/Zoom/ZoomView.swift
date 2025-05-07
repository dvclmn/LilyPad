//
//  ZoomView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import BaseHelpers
import SwiftUI

public struct ZoomView<Content: View>: View {

  @State private var store = ZoomHandler()

  @State private var firstPositionPair: TouchPositions?
  @State private var currentPositionPair: TouchPositions?
  
  let scaleThesholdDistance: CGFloat = 10

  let canvasSize: CGSize
  let touchUpdates: TouchUpdates
  let content: Content

  public init(
    canvasSize: CGSize,
    touchUpdates: @escaping TouchUpdates,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.canvasSize = canvasSize
    self.touchUpdates = touchUpdates
    self.content = content()
  }

  public var body: some View {

    /// Using `GeometryReader` to kind 'reset' everything to be full width,
    /// full height, and top leading.
    GeometryReader { proxy in

      content
//      Rectangle()
//        .fill(.white.opacity(0.1))
        .midpointIndicator()
        .frame(width: store.canvasSize.width, height: store.canvasSize.height)
        .position(store.canvasPosition)

        .task(id: proxy.size) {
          store.viewportSize = proxy.size
        }
    }
    .midpointIndicator()
    .touches(canvasSize: canvasSize) { touches, pressure in
      if touches.count == 2 {
        //        store.touches = touches
        roughScale(touches: touches)
      }

      /// Pass the touches through to the recieving view
      touchUpdates(touches, pressure)

    }
    .task(id: canvasSize) {
      store.canvasSize = canvasSize
    }
  }
}
extension ZoomView {

//  func roughPan(touches: Set<TouchPoint>) {
//    let newPositions = TouchPositions(touches: touches)
//    initialisePositionsIfNeeded(newPositions)
//
//
//
//  }

  func roughScale(touches: Set<TouchPoint>) {
    guard touches.count == 2 else {
      return
    }
    
    let newPositionPair = TouchPositions(touches: touches, destinationSpace: store.viewportSize.toCGRect)
    
    if firstPositionPair == nil {
      firstPositionPair = newPositionPair
    }
    currentPositionPair = newPositionPair


    if let firstPair = firstPositionPair, let currentPair = currentPositionPair {
      
      let delta = currentPair.midPoint(mapped: true) - firstPair.midPoint(mapped: true)
      
      let scale = currentPair.distanceBetween(mapped: true) / firstPair.distanceBetween(mapped: true)
//      let scaledStartMid = firstPair.mid * scale
//      let offset = currentPair.mid - scaledStartMid
      
      store.offset = store.offset + delta
//          if newPositions.p1.distance(to: newPositions.p2) >= scaleThesholdDistance {
      //      roughPan(touches: touches)
      //      return
//          } else {
//          }

      store.scale = scale
//      store.offset = offset
    }
  }
  
//  func initialisePositionsIfNeeded(_ positions: TouchPositions) {
//
//    
//  }


}

#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview(traits: .size(.narrow)) {
  ZoomView(canvasSize: CGSize.init(width: 400, height: 300)) { touches, pressure in
    //
  } content: {
    Text(TestStrings.paragraphs[5])
      .padding(40)
      .background(.purple.quinary)
      .frame(width: 400)

  }
  .frame(width: 600, height: 700)
  .background(.black.opacity(0.6))
}
#endif
