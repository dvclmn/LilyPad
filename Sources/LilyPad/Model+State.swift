//
//  Model+State.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import AppKit


struct TrackpadGestureState {
  var scrollDeltaX: CGFloat = 0
  var scrollDeltaY: CGFloat = 0
  
  /// https://developer.apple.com/documentation/appkit/nsevent/eventtype/magnify
  var magnification: CGFloat = 1.0
  var rotation: CGFloat = 0
  
  /// https://developer.apple.com/documentation/appkit/nsevent/eventtype/pressure
  var pressure: CGFloat = 0
  
  /// E.g. `began`, `changed`, `ended`
  /// https://developer.apple.com/documentation/appkit/nsevent/phase-swift.property
  var phase: NSEvent.Phase = []
}

