//
//  PanGestureNSView.swift
//  Paperbark
//
//  Created by Dave Coleman on 24/6/2025.
//

import AppKit

// MARK: - Custom NSView for Pan Tracking
public class PanTrackingNSView: NSView {
  
  weak var panDelegate: PanDelegate?
//  var onPanGesture: ((PanPhase) -> Void)?
  
  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView() {
    print("Set up `PanTrackingView`")
    wantsLayer = true
    /// Make background transparent so it doesn't interfere with SwiftUI content
    //    layer?.backgroundColor = NSColor.clear.cgColor
  }
  
  public override var acceptsFirstResponder: Bool {
    return true
  }
  
  public override func viewDidMoveToWindow() {
    super.viewDidMoveToWindow()
    window?.makeFirstResponder(self)
  }
  
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
    
    panDelegate?.panView(self, didUpdate: panPhase)
    
//    onPanGesture?(panPhase)
  }
  
  public override func mouseExited(with event: NSEvent) {
    print("Mouse exited with event: \(event)")
    super.mouseExited(with: event)
    panDelegate?.panView(self, didUpdate: .inactive)
//    onPanGesture?(.inactive)
  }
}
