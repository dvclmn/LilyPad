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
    let touches = event.allTouches()
    
    let debugEventsMessage: String
    
    switch event.type {
      case .leftMouseDown: debugEventsMessage = "leftMouseDown"
      case .leftMouseUp: debugEventsMessage = "leftMouseUp"
      case .rightMouseDown: debugEventsMessage = "rightMouseDown"
      case .rightMouseUp: debugEventsMessage = "rightMouseUp"
      case .mouseMoved: debugEventsMessage = "mouseMoved"
      case .leftMouseDragged: debugEventsMessage = "leftMouseDragged"
      case .rightMouseDragged: debugEventsMessage = "rightMouseDragged"
      case .mouseEntered: debugEventsMessage = "mouseEntered"
      case .mouseExited: debugEventsMessage = "mouseExited"
      case .keyDown: debugEventsMessage = "keyDown"
      case .keyUp: debugEventsMessage = "keyUp"
      case .flagsChanged: debugEventsMessage = "flagsChanged"
      case .appKitDefined: debugEventsMessage = "appKitDefined"
      case .systemDefined: debugEventsMessage = "systemDefined"
      case.applicationDefined: debugEventsMessage = "applicationDefined"
      case .periodic: debugEventsMessage = "periodic"
      case .cursorUpdate: debugEventsMessage = "cursorUpdate"
      case .scrollWheel: debugEventsMessage = "scrollWheel"
      case .tabletPoint: debugEventsMessage = "tabletPoint"
      case .tabletProximity: debugEventsMessage = "tabletProximity"
      case .otherMouseDown: debugEventsMessage = "otherMouseDown"
      case .otherMouseUp: debugEventsMessage = "otherMouseUp"
      case .otherMouseDragged: debugEventsMessage = "otherMouseDragged"
      case .swipe: debugEventsMessage = "Swipe"
      case .pressure: debugEventsMessage = "Pressure"
      case .directTouch: debugEventsMessage = "Direct touch"
      case .changeMode: debugEventsMessage = "Change mode"
      default: debugEventsMessage = "Default event type"
    }
    print("Event of type \"\(debugEventsMessage)\" received")
    
    touchManager.activeTouches = touches
    let eventData = createEventData(phase: phase, timestamp: event.timestamp)
    delegate?.touchesView(self, didUpdate: eventData)
  }

  private func processPressure(_ event: NSEvent) {
    touchManager.currentPressure = CGFloat(event.pressure)

    /// Only send pressure updates during active touches
    guard !touchManager.activeTouches.isEmpty else { return }

    /// During pressure changes, the phase should be "moved"
    let eventData = createEventData(phase: .moved, timestamp: event.timestamp)
    delegate?.touchesView(self, didUpdate: eventData)

  }

  private func createEventData(
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


  // MARK: - Touch Event Handlers
  public override func touchesBegan(with event: NSEvent) {
    processTouches(with: event, phase: .began)
  }
  public override func touchesMoved(with event: NSEvent) {
    processTouches(with: event, phase: .moved)
  }
  public override func touchesEnded(with event: NSEvent) {
    print("`touchesEnded`, phase should be `ended`")
    processTouches(with: event, phase: .ended)
  }
  public override func touchesCancelled(with event: NSEvent) {
    print("`touchesCancelled`, phase should be `cancelled`")
    processTouches(with: event, phase: .cancelled)
  }
  public override func pressureChange(with event: NSEvent) {
    processPressure(event)
  }


}
