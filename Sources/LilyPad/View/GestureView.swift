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
  var states: [GestureType: GestureState] = [:]
  
  var currentGestureState: CurrentGestureState?

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
  
  
  private func setupGestureRecognisers() {
    
    let rotationGesture = NSRotationGestureRecognizer(target: self, action: #selector(handleRotation))
    let magnifyGesture = NSMagnificationGestureRecognizer(target: self, action: #selector(handleZoom))
    
    self.addGestureRecognizer(rotationGesture)
    self.addGestureRecognizer(magnifyGesture)
    
  }
  @objc private func handleRotation(_ gesture: NSRotationGestureRecognizer) {
    
    updateGesture(.rotation, delta: gesture.rotation)
    
    if gesture.state == .ended {
      gesture.rotation = 0
    }
    
  }
  
  @objc private func handleZoom(_ gesture: NSMagnificationGestureRecognizer) {
    
//    updateGesture(.rotation, delta: gesture.rotation)
//    
//    if gesture.state == .ended {
//      gesture.rotation = 0
//    }
    
  }
  
//  func smoothValue(_ value: CGFloat, deltas: inout [CGFloat]) -> CGFloat {
//    deltas.append(value)
//    if deltas.count > smoothingWindowSize {
//      deltas.removeFirst()
//    }
//    return deltas.reduce(0, +) / CGFloat(deltas.count)
//  }
  
 
  func updateGesture(_ type: GestureType, delta: CGFloat) {
    
    guard let config = configs[type] else { return }
    
    let currentState = states[type] ?? GestureState()
    let newState = type.updateState(currentState, delta: delta, config: config)
    states[type] = newState
    
    Task { @MainActor in
      delegate?.didUpdateGesture(type, with: newState)
    }
  }
  
  
  
  func resetGestureState() {
    currentGestureState = nil
//    recentRotationDeltas.removeAll()
//    recentZoomDeltas.removeAll()
  }
  
  

}
