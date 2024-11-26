//
//  GestureDetectingView.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import AppKit


public class GestureDetectingView: NSView {
  
  weak var delegate: TrackpadGestureDelegate?
  
  private var gestureState = TrackpadGestureState()
  
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
    gestureState.scrollDeltaX += event.scrollingDeltaX
    gestureState.scrollDeltaY += event.scrollingDeltaY
    gestureState.phase = event.phase
    delegate?.didUpdateGesture(gestureState)
  }
  
  @objc private func handleMagnification(_ gesture: NSMagnificationGestureRecognizer) {
    gestureState.magnification = gesture.magnification + 1.0
    gestureState.accumulatedMagnification *= gesture.magnification
    delegate?.didUpdateGesture(gestureState)
  }
  
  @objc private func handleRotation(_ gesture: NSRotationGestureRecognizer) {
    gestureState.rotation = gesture.rotation
    delegate?.didUpdateGesture(gestureState)
  }
}

