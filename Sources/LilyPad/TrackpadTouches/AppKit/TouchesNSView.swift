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
    wantsRestingTouches = false

  }

  private func processTouches(
    with event: NSEvent,
    phase: TrackpadGesturePhase
  ) {
    let touches = event.touches(matching: [.touching], in: self)
    touchManager.activeTouches = touches
    let eventData = processTouches(phase: .moved, timestamp: event.timestamp)
    delegate?.touchesView(self, didUpdate: eventData)
  }

  private func processPressure(_ event: NSEvent) {
    touchManager.currentPressure = CGFloat(event.pressure)

    /// Only send pressure updates during active touches
    if !touchManager.activeTouches.isEmpty {

      /// During pressure changes, the phase should be "moved"
      let eventData = processTouches(phase: .moved, timestamp: event.timestamp)
//      let trackpadTouches = touchManager.processTouches(
//        touches,
//        timestamp: event.timestamp,
//        in: self
//      )
//
//      let eventData = TouchEventData(
//        touches: trackpadTouches,
//        /// During pressure changes, the phase should be "moved"
//        phase: .moved,
//        pressure: touchManager.currentPressure,
//        timestamp: event.timestamp
//      )
      delegate?.touchesView(self, didUpdate: eventData)
    }
  }

  private func processTouches(
    phase: TrackpadGesturePhase,
    timestamp: TimeInterval,
  ) -> TouchEventData {

    let touches = touchManager.processTouches(
      timestamp: timestamp,
      in: self
    )

    let eventData = TouchEventData(
      touches: touches,
      phase: phase,
      pressure: touchManager.currentPressure,
      timestamp: timestamp
    )

    return eventData
  }


  //  public override func pressureChange(with event: NSEvent) {
  //    currentPressure = CGFloat(event.pressure)
  //
  //    // Only send pressure updates during active touches
  //    if !activeTouches.isEmpty {
  //      let eventData = TouchEventData(
  //        touches: activeTouches, // Store active touches as a property
  //        phase: .moved, // During pressure changes, the phase should be "moved"
  //        pressure: currentPressure,
  //        timestamp: event.timestamp
  //      )
  //      delegate?.touchesView(self, didUpdate: eventData)
  //    }
  //  }


  //  private func processTouches(with event: NSEvent, phase: TrackpadGesturePhase) {
  //
  //    let touches = event.touches(matching: [.touching], in: self)
  //
  //    /// Convert to data model
  //    let trackpadTouches = touchManager.processTouches(
  //      touches,
  //      timestamp: event.timestamp,
  //      in: self
  //    )
  //
  //    /// Forward via delegate
  //    delegate?.touchesView(self, didUpdateTouches: trackpadTouches)
  //    delegate?.touchesView(self, didUpdatePhase: phase)
  //  }


  // MARK: - Touch Event Handlers
  public override func touchesBegan(with event: NSEvent) {
    processTouches(with: event, phase: .began)
  }
  public override func touchesMoved(with event: NSEvent) {
    processTouches(with: event, phase: .changed)
  }
  public override func touchesEnded(with event: NSEvent) {
    processTouches(with: event, phase: .ended)
  }
  public override func touchesCancelled(with event: NSEvent) {
    processTouches(with: event, phase: .cancelled)
  }

  public override func pressureChange(with event: NSEvent) {
    processPressure(event.pressure)
  }


}
