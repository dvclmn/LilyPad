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
  
  @State private var firstPosition: TouchPositions?
  @State private var currentPosition: TouchPositions?

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

      Rectangle()
        .fill(.white.opacity(0.1))
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

  func roughPan(touches: Set<TouchPoint>) {
    let touchesArray = Array(touches)
    guard touchesArray.count == 2 else {
      return
    }
    
    
  }
  
  func roughScale(touches: Set<TouchPoint>) {
    
    let touchesArray = Array(touches)
    guard touchesArray.count == 2 else {
      return
    }
    
    let touch01 = touchesArray[0]
    let touch02 = touchesArray[1]
    
    let p1 = touch01.position
    let p2 = touch02.position
    
    guard 
    
    let newPosition = TouchPositions(p01A: p1, p02B: p2)
    
    if firstPosition == nil {
      firstPosition = newPosition
    }
    
    currentPosition = newPosition
    
    if let first = firstPosition, let current = currentPosition {
      let scale = current.distance / first.distance
      let scaledStartMid = first.mid * scale
      let offset = current.mid - scaledStartMid
      
      store.scale = scale
      store.offset = offset
    }

    
  }
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
