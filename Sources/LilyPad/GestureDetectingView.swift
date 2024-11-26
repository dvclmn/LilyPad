//
//  GestureDetectingView.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import AppKit

@MainActor
public class GestureDetectingView: NSView {
  
  weak var delegate: TrackpadGestureDelegate?
  
  var gestureState = TrackpadGestureState()
  
  public var configs: [GestureType : GestureConfig]
  public var states: [GestureType : TrackpadGestureState]
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupGestureRecognisers()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupGestureRecognisers()
  }
  
  private func setupGestureRecognisers() {
    
    self.wantsRestingTouches = true
    
    let magnificationGesture = NSMagnificationGestureRecognizer(target: self, action: #selector(handleMagnification(_:)))
    self.addGestureRecognizer(magnificationGesture)
    
    let rotationGesture = NSRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
    self.addGestureRecognizer(rotationGesture)
  }
  
  public override func scrollWheel(with event: NSEvent) {
    
//    print("`event.scrollingDeltaX`: \(event.scrollingDeltaX)")
//    print("`event.scrollingDeltaY`: \(event.scrollingDeltaY)")
    
    gestureState.updateScroll(
      deltaX: event.scrollingDeltaX,
      deltaY: event.scrollingDeltaY
    )
    gestureState.phase = event.phase
    Task { @MainActor in
      delegate?.didUpdateGesture(gestureState)
    }
  }
  
  @objc private func handleMagnification(_ gesture: NSMagnificationGestureRecognizer) {
    
    gestureState.updateMagnification(gesture.magnification)
    
    /// Reset the gesture recognizer's magnification
    if gesture.state == .ended {
      gesture.magnification = 0
    }
    
    Task { @MainActor in
      delegate?.didUpdateGesture(gestureState)
    }
    delegate?.didUpdateGesture(gestureState)
  }
  
  @objc private func handleRotation(_ gesture: NSRotationGestureRecognizer) {

    gestureState.updateRotation(gesture.rotation)
    
    if gesture.state == .ended {
      gesture.rotation = 0
    }
    
    Task { @MainActor in
      delegate?.didUpdateGesture(gestureState)
    }
  }
}

