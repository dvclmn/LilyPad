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
  weak var touchesDelegate: TrackpadTouchesDelegate?

  /// Touch manager to handle touch tracking and velocity calculation
  private let touchManager = TrackpadTouchManager()

//  public var isClickEnabled: Bool = true
  public var shouldUseVelocity: Bool = true

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

  private func processFirstTouches(with event: NSEvent) {

    let touches = event.allTouches()
//    let pressure = CGFloat(event.pressure)
    
    var touchesWithPressure: [NSTouch: CGFloat] = [:]
    
    for touch in touches {
      touchesWithPressure[touch] = .zero
    }
    
    let eventData = touchManager.processCapturedTouches(
      touchesWithPressure,
      timestamp: event.timestamp
    )
    
    /// ⬇️ Important: If no touches remain,  should notify with nil
    if touchManager.activeTouches.isEmpty {
      touchesDelegate?.touchesView(self, didUpdate: nil)
    } else {
      touchesDelegate?.touchesView(self, didUpdate: eventData)
    }

  }

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
}

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
