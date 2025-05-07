//
//  Handler+Zoom.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import SwiftUI

@Observable
final class ZoomHandler {
  var touches: Set<TouchPoint> = []
  
  var scale: CGFloat = 1
  var offset: CGPoint = .zero
}
