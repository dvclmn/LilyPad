//
//  ZoomView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import BaseHelpers
import SwiftUI

struct TouchPositions {
  var p01A: CGPoint
  var p02B: CGPoint
  
  var mid: CGPoint {
    CGPoint.midPoint(p1: p01A, p2: p02B)
  }
  
  var distance: CGFloat {
    hypot(p02B.x - p01A.x, p02B.y - p01A.y)
  }
}

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

    ZStack {

      content
        .scaleEffect(store.scale)
        .offset(store.offset.toCGSize)
    }
    .touches(canvasSize: canvasSize) { touches, pressure in
      if touches.count == 2 {
//        store.touches = touches
        roughScale(touches: touches)
      }
      touchUpdates(touches, pressure)
      
    }
  }
}
extension ZoomView {
  func roughScale(touches: Set<TouchPoint>) {
    
    let touchesArray = Array(touches)
    guard touchesArray.count == 2 else {
      return
    }
    
    let p1 = touchesArray[0].position
    let p2 = touchesArray[1].position
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
    
//    guard firstPosition != nil else {
//      firstPosition =
//    }
//    
//    let touchesArray = Array(touches)
//    guard touchesArray.count == 2
//    else {
//      return 1.0  // Default scale value
//    }
//    
//    let p01 = touchesArray[0].position
//    let p02 = touchesArray[1].position
//    
//    let firstPoint = TouchPositions(p01A: p01, p02B: p02)
//    
//    
//    
//    self.firstPosition = firstPoint
    
  }
}

#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview(traits: .size(.narrow)) {
  ZoomView(canvasSize: CGSize.init(width: 400, height: 300)) { touches, pressure in
    //
  } content: {
    Text(TestStrings.paragraphs[5])
    
  }
  .padding(40)
  .frame(width: 600, height: 700)
  .background(.black.opacity(0.6))
}
#endif
