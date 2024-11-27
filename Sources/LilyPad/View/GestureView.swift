//
//  GestureView.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import AppKit

@MainActor
public class GestureView: NSView {
  
  weak var delegate: TrackpadGestureDelegate?

  var configs: [GestureType: GestureConfig] = [:]
  var states: [GestureType: TrackpadGestureState] = [:]
  var previousTouchDistance: CGFloat?
  var previousTouchAngle: CGFloat?
  
  var initialTouchDistance: CGFloat?
  var initialTouchAngle: CGFloat?
  var gestureStartTime: TimeInterval?
  
  var recentRotationDeltas: [CGFloat] = []
  var recentZoomDeltas: [CGFloat] = []
  let smoothingWindowSize = 3
  
  

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
  
  func smoothValue(_ value: CGFloat, deltas: inout [CGFloat]) -> CGFloat {
    deltas.append(value)
    if deltas.count > smoothingWindowSize {
      deltas.removeFirst()
    }
    return deltas.reduce(0, +) / CGFloat(deltas.count)
  }
  
 
  func updateGesture(_ type: GestureType, delta: CGFloat) {
    
    guard let config = configs[type] else { return }
    
    let currentState = states[type] ?? TrackpadGestureState()
    let newState = type.updateState(currentState, delta: delta, config: config)
    states[type] = newState
    
    Task { @MainActor in
      delegate?.didUpdateGesture(type, with: newState)
    }
  }
  
  
  
  func resetGestureState() {
    initialTouchDistance = nil
    initialTouchAngle = nil
    gestureStartTime = nil
    previousTouchDistance = nil
    previousTouchAngle = nil
    recentRotationDeltas.removeAll()
    recentZoomDeltas.removeAll()
  }
  
  

}

