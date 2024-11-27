//
//  Touches.swift
//  LilyPad
//
//  Created by Dave Coleman on 27/11/2024.
//

import AppKit

extension GestureDetectingView {
  
  func handleTouches(with event: NSEvent) {
    let touches = event.touches(matching: .touching, in: self)
    let trackpadTouches = Set(touches.map(TrackPadTouch.init))
    
    delegate?.didUpdateTouches(trackpadTouches)
    
    if touches.count == 2 {
      let touchesArray = Array(touches)
      handleZoomFromTouches(touchesArray)
      handleRotationFromTouches(touchesArray)
    } else {
      previousTouchDistance = nil
      previousTouchAngle = nil
    }
  }
  
  
  public override func touchesBegan(with event: NSEvent) {
    handleTouches(with: event)
  }
  
  public override func touchesMoved(with event: NSEvent) {
    handleTouches(with: event)
  }
  
  public override func touchesEnded(with event: NSEvent) {
    handleTouches(with: event)
    previousTouchDistance = nil
  }
  
  public override func touchesCancelled(with event: NSEvent) {
    handleTouches(with: event)
    previousTouchDistance = nil
  }
}
