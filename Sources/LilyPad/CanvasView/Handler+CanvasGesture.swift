//
//  Handler+CanvasGesture.swift
//  LilyPad
//
//  Created by Dave Coleman on 24/6/2025.
//

import SwiftUI

@Observable
final class CanvasGestureHandler {
  var zoom: CGFloat = 1
  var pan: CGPoint = .zero
  var rotation: CGFloat = 0
}
