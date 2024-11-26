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

  var configs: [GestureType: GestureConfig] = [:]
  private var states: [GestureType: TrackpadGestureState] = [:]
  private var previousTouchDistance: CGFloat?
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    
    setupView()
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    self.wantsRestingTouches = true
    self.allowedTouchTypes = [.indirect]
  }
  
  // Touch handling
  private func handleTouches(with event: NSEvent) {
    let touches = event.touches(matching: .touching, in: self)
    let trackpadTouches = Set(touches.map(TrackPadTouch.init))
    
    delegate?.didUpdateTouches(trackpadTouches)
    
    // Handle zoom gesture when there are exactly two touches
    if touches.count == 2 {
      handleZoomFromTouches(Array(touches))
    } else {
      previousTouchDistance = nil
    }
  }
  
  private func handleZoomFromTouches(_ touches: [NSTouch]) {
    guard touches.count == 2 else { return }
    
    let touch1 = touches[0].normalizedPosition
    let touch2 = touches[1].normalizedPosition
    
    // Calculate current distance between touches
    let currentDistance = hypot(
      touch2.x - touch1.x,
      touch2.y - touch1.y
    )
    
    if let previousDistance = previousTouchDistance {
      // Calculate zoom delta
      let delta = (currentDistance - previousDistance) / previousDistance
      updateGesture(.zoom, delta: delta)
    }
    
    previousTouchDistance = currentDistance
  }
  
  // Touch event handlers
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
  
  


  private func updateGesture(_ type: GestureType, delta: CGFloat) {
    guard let config = configs[type] else { return }
    
    let currentState = states[type] ?? TrackpadGestureState()
    let newState = type.updateState(currentState, delta: delta, config: config)
    states[type] = newState
    
    Task { @MainActor in
      delegate?.didUpdateGesture(type, with: newState)
    }
  }
  
  public override func scrollWheel(with event: NSEvent) {
    
    guard !event.scrollingDeltaX.isNaN && !event.scrollingDeltaY.isNaN else { return }
    
    updateGesture(.panX, delta: event.scrollingDeltaX)
    updateGesture(.panY, delta: event.scrollingDeltaY)
    
    /// Update phase for both pan gestures
    states[.panX]?.phase = event.phase
    states[.panY]?.phase = event.phase

  }

  @objc private func handleRotation(_ gesture: NSRotationGestureRecognizer) {

    updateGesture(.rotation, delta: gesture.rotation)
    
    if gesture.state == .ended {
      gesture.rotation = 0
    }
    
  }
}

