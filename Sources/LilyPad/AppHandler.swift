//
//  AppHandler.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import SwiftUI

@Observable
final class TouchHandler {
  var touches: Set<TrackpadTouch> = []
  var windowSize: CGSize = .zero
  var isPointerLocked: Bool = false
  
  let touchPadWidth: CGFloat = 700
  var touchPadHeight: CGFloat {
    touchPadWidth * (10.0 / 16.0)
  }
  
  func touchPosition(in size: CGSize, touch: TrackpadTouch) -> CGPoint {
    let originX = (size.width - touchPadWidth) / 2
    let originY = (size.height - touchPadHeight) / 2
    
    let x = originX + (touch.position.x * touchPadWidth)
    let y = originY + (touch.position.y * touchPadHeight)
    
    return CGPoint(x: x, y: y)
  }
}
