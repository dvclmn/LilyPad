//
//  Handler+Zoom.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import SwiftUI
import BaseHelpers

@Observable
final class ZoomHandler {
  var touches: Set<TouchPoint> = []
  
  var scale: CGFloat = 1
  var offset: CGPoint = .zero
  var canvasSize: CGSize = .zero
  
  var viewportSize: CGSize = .zero
  
}

extension ZoomHandler {
  
  var canvasPosition: CGPoint {

    let viewportMidPoint = viewportSize.midpoint
//    let canvasMidPoint = canvasSize.midpoint
    
    let centred = viewportMidPoint
    return offset + centred
  }
}

