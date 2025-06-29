//
//  PanGestureNSView.swift
//  Paperbark
//
//  Created by Dave Coleman on 24/6/2025.
//

import AppKit

// MARK: - Custom NSView for Pan Tracking
public class PanTrackingNSView: NSView {
  
  var didUpdatePanGesture: PanGestureOutput
  
  public init(
    didUpdatePanGesture: @escaping PanGestureOutput
  ) {
    self.didUpdatePanGesture = didUpdatePanGesture
    super.init(frame: .zero)
    self.setupView()
  }

  required init?(coder: NSCoder) {
    self.didUpdatePanGesture = { _ in }
    super.init(coder: coder)
  }
  
  private func setupView() {
    print("Set up `PanTrackingView`")
//    wantsLayer = true
  }
  
//  public override var acceptsFirstResponder: Bool {
//    return true
//  }
  
//  public override func viewDidMoveToWindow() {
//    super.viewDidMoveToWindow()
//    window?.makeFirstResponder(self)
//  }
  
  // MARK: - Two-Finger Pan via ScrollWheel
  public override func scrollWheel(with event: NSEvent) {
    
    //    print("Overridden `scrollWheel(with:). Event: \(event)")
    /// Filter for trackpad events (two-finger gestures)
//    guard event.subtype == .touch else {
//      super.scrollWheel(with: event)
//      return
//    }
    
    let deltaX = event.scrollingDeltaX
    let deltaY = event.scrollingDeltaY
    let delta = CGPoint(x: deltaX, y: deltaY)
    
    /// Map `NSEvent.Phase` to `PanPhase`
    let panPhase: PanPhase
    switch event.phase {
      case .began:
        panPhase = .active(delta: delta)
      case .changed:
        panPhase = .active(delta: delta)
      case .ended:
        panPhase = .ended(finalDelta: delta)
      case .cancelled:
        panPhase = .cancelled
      default:
        /// For stationary or other phases, may not want to trigger
        return
    }
    
    didUpdatePanGesture(panPhase)
    
//    onPanGesture?(panPhase)
  }
  
  public override func mouseExited(with event: NSEvent) {
    print("Mouse exited with event: \(event)")
    super.mouseExited(with: event)
    didUpdatePanGesture(.inactive)
//    onPanGesture?(.inactive)
  }
}
