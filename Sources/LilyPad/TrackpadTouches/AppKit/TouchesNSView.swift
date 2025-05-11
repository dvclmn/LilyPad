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
    wantsRestingTouches = false
  }

  private func processTouches(
    with event: NSEvent,
    phase: TrackpadGesturePhase
  ) {
    let touches = event.allTouches()
//    let touches = event.touches(matching: [.cancelled, .ended, .touching], in: self)
    
    /// Only emit nil when all touches have ended
    let eventData = touchManager.processTouches(touches, phase: phase, timestamp: event.timestamp)
    
    touchesDelegate?.touchesView(self, didUpdate: eventData)
//    if eventData?.touches.isEmpty == true && (phase == .ended || phase == .cancelled) {
//      touchesDelegate?.touchesView(self, didUpdate: nil)
//    } else {
//      touchesDelegate?.touchesView(self, didUpdate: eventData)
//    }
//   
//    /// Convert to data model
//    var eventData: TouchEventData? = touchManager.processTouches(
//      touches,
//      phase: phase,
//      timestamp: event.timestamp
//    )
//
//    /// THIS is important, to ensure we don't send or leave a stale touch event
//    /// in the pipeline, when there are no touches. If there are no touches, we need
//    /// to clean things out, and set back to `nil`
//    if phase == .ended || phase == .cancelled {
//      
//      if touches.count <= 1 {
//        eventData = nil
//      }
//    }
//    touchesDelegate?.touchesView(self, didUpdate: eventData)
  }

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
//    print("Touches began")
    processTouches(with: event, phase: .began)
  }
  public override func touchesMoved(with event: NSEvent) {
//    print("Touches moved")
    processTouches(with: event, phase: .moved)
  }
  public override func touchesEnded(with event: NSEvent) {
//    print("Touches ended")
    processTouches(with: event, phase: .ended)
  }
  public override func touchesCancelled(with event: NSEvent) {
//    print("Touches cancelled")
    processTouches(with: event, phase: .cancelled)
  }
//  public override func pressureChange(with event: NSEvent) {
//    processPressure(event)
//  }
  
//  public override func addGestureRecognizer(_ gestureRecognizer: NSGestureRecognizer) {
//    <#code#>
//  }

  
  // MARK: - Disable mouse clicks when performing drawing/gestures
  public override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
    return isClickEnabled
  }
  
  public override func hitTest(_ point: NSPoint) -> NSView? {
    return isClickEnabled ? super.hitTest(point) : nil
  }
  
  
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
