//
//  Representable.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

#if canImport(AppKit)
import SwiftUI

// MARK: - Delegate Protocol
/// Protocol for receiving touch updates
public protocol TrackpadTouchesDelegate: AnyObject {
  func touchesView(_ view: TrackpadTouchesNSView, didUpdateTouches touches: Set<TouchPoint>)
  func touchesView(_ view: TrackpadTouchesNSView, didUpdatePhase phase: TrackpadGesturePhase)
  func touchesView(_ view: TrackpadTouchesNSView, didUpdatePressure pressure: CGFloat)
}

public typealias TouchUpdates = (
  _ touches: Set<TouchPoint>,
  _ phase: TrackpadGesturePhase,
  _ pressure: CGFloat
) -> Void

// MARK: - SwiftUI Representable
/// SwiftUI wrapper for the trackpad touches view
public struct TrackpadTouchesView: NSViewRepresentable {

  /// Callback for touch updates
  private var onTouchesUpdate: TouchUpdates?
//  private var onPressureUpdate: PressureUpdates?

  public init(
    onTouchesUpdate: TouchUpdates? = nil,
//    onPressureUpdate: PressureUpdates? = nil,
  ) {
    self.onTouchesUpdate = onTouchesUpdate
//    self.onPressureUpdate = onPressureUpdate
  }

  public func makeNSView(context: Context) -> TrackpadTouchesNSView {
    let view = TrackpadTouchesNSView()
    view.delegate = context.coordinator
    return view
  }

  public func updateNSView(_ nsView: TrackpadTouchesNSView, context: Context) {}

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  public class Coordinator: NSObject, TrackpadTouchesDelegate {
    let parent: TrackpadTouchesView

    init(_ parent: TrackpadTouchesView) {
      self.parent = parent
    }

    public func touchesView(
      _ view: TrackpadTouchesNSView,
      didUpdateTouches touches: Set<TouchPoint>,
    ) {
      DispatchQueue.main.async {
        self.parent.onTouchesUpdate?(
          touches,
          phase,
          pressure
        )
//        self.parent.onPressureUpdate?(pressure)
      }
    }
    public func touchesView(
      _ view: TrackpadTouchesNSView,
      didUpdatePhase phase: TrackpadGesturePhase,
    ) {
      DispatchQueue.main.async {
        self.parent.onTouchesUpdate?(
          touches,
          phase,
          pressure
        )
        //        self.parent.onPressureUpdate?(pressure)
      }
    }
    public func touchesView(
      _ view: TrackpadTouchesNSView,
      didUpdatePressure pressure: CGFloat
    ) {
      DispatchQueue.main.async {
        self.parent.onTouchesUpdate?(
          touches,
          phase,
          pressure
        )
        //        self.parent.onPressureUpdate?(pressure)
      }
    }
  }
}
#endif
