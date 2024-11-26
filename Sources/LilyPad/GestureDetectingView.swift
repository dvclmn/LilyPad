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

  var configs: [GestureType: GestureConfig] = [:] {
    didSet {
      // Optionally handle config changes
    }
  }
  private var states: [GestureType: TrackpadGestureState] = [:]
  
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
    
    // Update phase for both pan gestures
    states[.panX]?.phase = event.phase
    states[.panY]?.phase = event.phase

  }
  
  @objc private func handleMagnification(_ gesture: NSMagnificationGestureRecognizer) {
    
    updateGesture(.zoom, delta: gesture.magnification)
    
    if gesture.state == .ended {
      gesture.magnification = 0
    }

  }
  
  @objc private func handleRotation(_ gesture: NSRotationGestureRecognizer) {

    updateGesture(.rotation, delta: gesture.rotation)
    
    if gesture.state == .ended {
      gesture.rotation = 0
    }
    
  }
}

