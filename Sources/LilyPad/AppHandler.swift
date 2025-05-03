//
//  AppHandler.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import SwiftUI


@Observable
public final class TouchHandler {
  var touches: Set<TrackpadTouch> = []
  
//  var strokeBuilder = StrokePathBuilder()
  
  public init() {}

  /// Clear all strokes
//  func clearStrokes() {
//    strokeBuilder.clearStrokes()
//  }
  
  var windowSize: CGSize = .zero
  var isPointerLocked: Bool = false
  
  var isClicked: Bool = false
  
  let trackPadAspectRatio: CGFloat = 10.0 / 16.0
  
  var trackPadSize: CGSize {
    let trackPadWidth: CGFloat = 700
    let trackPadHeight: CGFloat = trackPadWidth * trackPadAspectRatio
    
    return CGSize(
      width: trackPadWidth,
      height: trackPadHeight
    )
  }
  
  var isInTouchMode: Bool {
    !isClicked && isPointerLocked
  }
  
  func touchPosition(
    _ touch: TrackpadTouch
  ) -> CGPoint {
    let originX = (windowSize.width - trackPadSize.width) / 2
    let originY = (windowSize.height - trackPadSize.height) / 2
    
    let x = originX + (touch.position.x * trackPadSize.width)
    let y = originY + (touch.position.y * trackPadSize.height)
    
    return CGPoint(x: x, y: y)
  }
}

