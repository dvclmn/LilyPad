//
//  TouchesNSView.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import AppKit

extension NSTouch {
  func debuggingString(
    timestamp: TimeInterval,
    pressure: CGFloat
  ) -> String {
    """
    ////
    Received `NSTouch`
      - Phase: \(self.phase)
      - ID: \(self.identity)
      - ID Hash: \(self.identity.hash)
      - Is Resting: \(self.isResting)
      - Device: \(self.device.debugDescription)
      - Device Size: \(self.deviceSize)

      From NSEvent:
      - Timestamp: \(timestamp)
      - Pressure: \(pressure)
    """
  }
}

/// The underlying AppKit NSView that captures raw trackpad touches
public class TrackpadTouchesNSView: NSView {
  /// Delegate to forward touch events to
  weak var touchesDelegate: TrackpadTouchesDelegate?

  /// Touch manager to handle touch tracking and velocity calculation
  private let touchManager = TrackpadTouchManager()

  public var isClickEnabled: Bool = true

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

    #warning("Use this in future for that annoying palm triggering I always get")
    ///    wantsRestingTouches = false is fine; set it to true if you want to receive .stationary phase updates (like for palm resting detection).

  }

  private func processFirstTouches(
    with event: NSEvent,
//    phase: NSTouch.Phase
  ) {

    let touches = event.allTouches()

    //    var touches: Set<NSTouch> = []
    //
    //    switch phase {
    //      case .ended, .cancelled:
    //        // Include ended/cancelled + still-touching touches
    //        touches = event.touches(matching: [.ended, .cancelled, .touching], in: self)
    //
    //      case .began, .moved:
    //        touches = event.touches(matching: [.touching], in: self)
    //
    //      default:
    //        break
    //    }

    let eventData = touchManager.processCapturedTouches(
      touches,
      timestamp: event.timestamp,
//      pressure: CGFloat(event.pressure)
    )

    ///     ⬇️ Important: If no touches remain, you should notify with nil
    if touchManager.activeTouches.isEmpty {
      touchesDelegate?.touchesView(self, didUpdate: nil)
    } else {
      touchesDelegate?.touchesView(self, didUpdate: eventData)
    }
  }

  //  private func processFirstTouches(
  //    with event: NSEvent,
  //    phase: TrackpadGesturePhase
  //  ) {
  //    // Get all touches for the current view
  //    // For .ended and .cancelled phases, we need to specifically request those touches
  //    var touches: Set<NSTouch> = Set()
  //
  //    if phase == .ended || phase == .cancelled {
  //      // When touches end or cancel, we need to request those specific touches
  //      touches = event.touches(matching: [.ended, .cancelled], in: self)
  //    } else {
  //      // For active touches (.began, .moved, .touching)
  //      touches = event.touches(matching: [.touching], in: self)
  //    }
  //
  //    let eventData = touchManager.processCapturedTouches(
  //      touches,
  //      phase: phase,
  //      timestamp: event.timestamp
  //    )
  //
  //    touchesDelegate?.touchesView(self, didUpdate: eventData)
  //  }

  //  private func processPressure(_ event: NSEvent) {
  //    touchManager.currentPressure = CGFloat(event.pressure)
  //
  //    /// Only send pressure updates during active touches
  //    guard !touchManager.activeTouches.isEmpty else { return }
  //
  //    /// During pressure changes, the phase should be "moved"
  //    let eventData = createEventData(phase: .moved, timestamp: event.timestamp)
  //    delegate?.touchesView(self, didUpdate: eventData)
  //
  //  }

  //  private func createEventData(
  //    phase: TrackpadGesturePhase,
  //    timestamp: TimeInterval,
  //  ) -> TouchEventData {
  //    print("Creating event data, with phase: `\(phase.rawValue)`. `TrackpadTouchManager` is showing `\(touchManager.activeTouches.count)` active touches.")
  //    let touches = touchManager.processTouches(
  //      timestamp: timestamp,
  //      in: self
  //    )
  //
  //
  //    return eventData
  //  }


  // MARK: - Touch Event Handlers
  public override func touchesBegan(with event: NSEvent) {
    processFirstTouches(with: event)
  }
  public override func touchesMoved(with event: NSEvent) {
    processFirstTouches(with: event)
  }
  public override func touchesEnded(with event: NSEvent) {
    processFirstTouches(with: event)
  }
  public override func touchesCancelled(with event: NSEvent) {
    processFirstTouches(with: event)
  }
  //  public override func pressureChange(with event: NSEvent) {
  //    processPressure(event)
  //  }

  //  public override func addGestureRecognizer(_ gestureRecognizer: NSGestureRecognizer) {
  //    <#code#>
  //  }


  // MARK: - Disable mouse clicks when performing drawing/gestures
  //  public override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
  //    return isClickEnabled
  //  }
  //
  //  public override func hitTest(_ point: NSPoint) -> NSView? {
  //    return isClickEnabled ? super.hitTest(point) : nil
  //  }


  //  public override func mouseDown(with event: NSEvent) {
  //    if isClickEnabled {
  //      super.mouseDown(with: event)
  //    }
  //    // else: swallow the event
  //  }
  //
  //  public override func mouseUp(with event: NSEvent) {
  //    if isClickEnabled {
  //      super.mouseUp(with: event)
  //    }
  //  }
  //
  //  public override func rightMouseDown(with event: NSEvent) {
  //    if isClickEnabled {
  //      super.rightMouseDown(with: event)
  //    }
  //  }
  //
  //  public override func otherMouseDown(with event: NSEvent) {
  //    if isClickEnabled {
  //      super.otherMouseDown(with: event)
  //    }
  //  }

}
