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
  
  private let touchBuffer = TouchBuffer()

//  public var isClickEnabled: Bool = true
//  public var shouldUseVelocity: Bool = true

  public override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    setupView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }

  private func setupView() {
    /// Direct == touches made directly onto a screen, like a Wacom
    /// Indirect == touches made on a device like a trackpad
    allowedTouchTypes = [.indirect]
    
    self.pressureConfiguration = NSPressureConfiguration(pressureBehavior: .primaryGeneric)
        
    /// Include stationary touches in the updates
    wantsRestingTouches = true

  }

  private func processFirstTouches(with event: NSEvent) {

//    let touches: Set<NSTouch> = event.allTouches()
//    let pressure = CGFloat(event.pressure)
//    
//    /// Important: NSTouches do not come with per-touch pressure,
//    /// so this doesn't work.
////    var touchesWithPressure: [NSTouch: CGFloat] = [:]
//    
////    for touch in touches {
////      touchesWithPressure[touch] = .zero
////    }
//    
//    let processedTouches: Set<TouchPoint> = touchManager.processCapturedTouches(
//      touches,
//      timestamp: event.timestamp
//    )
//    let eventData = TouchEventData(touches: processedTouches, pressure: pressure)
//    
//    /// ⬇️ Important: If no touches remain,  should notify with nil
//    if touchManager.activeTouches.isEmpty {
//      print("No active touches, should return nil")
//      touchesDelegate?.touchesView(self, didUpdate: nil)
//    } else {
//      
//      touchesDelegate?.touchesView(self, didUpdate: eventData)
//    }

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
    
    if let eventData = touchBuffer.update(with: event) {
      delegate?.touchesView(self, didUpdate: eventData)
      touchBuffer.reset()
    }
    
    processFirstTouches(with: event)
  }
  
  public override func pressureChange(with event: NSEvent) {
    <#code#>
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
