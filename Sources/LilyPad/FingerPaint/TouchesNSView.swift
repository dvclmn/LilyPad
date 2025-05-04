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

  /// Touch manager to handle touch tracking and velocity calculation
  private let touchManager = TrackpadTouchManager()
  
  /// Minimum velocity threshold to consider when drawing (can be adjusted)
  private let minVelocityThreshold: CGFloat = 0.05
  
  public override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }

  private func setupView() {
    /// Only interested in trackpad touches, not direct touches
    allowedTouchTypes = [.indirect]
    /// Include stationary touches in the updates
    wantsRestingTouches = true
  }

  private func processTouches(with event: NSEvent) {
    /// Get all touching touches. `touching` matches the `began`, `moved`,
    /// or `stationary` phases of a touch.
    /// Note: Using `end` sems to break things, so don't use that
    let touches = event.touches(matching: [.touching], in: self)

    /// Convert to data model
    /// Process touches through the manager to get velocity information
    let trackpadTouches = touchManager.processTouches(touches, in: self)

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
}
