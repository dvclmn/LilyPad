//
//  TouchesNSView.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import AppKit

/// The underlying AppKit NSView that captures raw trackpad touches
public class TrackpadTouchesNSView: NSView {
  /// Delegate to forward touch events to
  weak var delegate: TrackpadTouchesDelegate?
  
  public override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    /// Only interested in trackpad touches, not direct touches
    allowedTouchTypes = [.indirect]
    /// Include stationary touches in the updates
    wantsRestingTouches = true
  }
  
  private func processTouches(with event: NSEvent) {
    /// Get all touching touches (includes .began, .moved, .stationary)
    let touches = event.touches(matching: .touching, in: self)
    
    /// Convert to our data model
    let trackpadTouches = Set(touches.map(TrackpadTouch.init))
    
    /// Forward via delegate
    delegate?.touchesView(self, didUpdateTouches: trackpadTouches)
  }
  
  // MARK: - Touch Event Handlers
  
  public override func touchesBegan(with event: NSEvent) {
    processTouches(with: event)
  }
  
  public override func touchesMoved(with event: NSEvent) {
    processTouches(with: event)
  }
  
  public override func touchesEnded(with event: NSEvent) {
    processTouches(with: event)
  }
  
  public override func touchesCancelled(with event: NSEvent) {
    processTouches(with: event)
  }
  
  public override func pressureChange(with event: NSEvent) {
    processTouches(with: event)
  }
}
