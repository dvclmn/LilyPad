//
//  Gesture.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import SwiftUI

public struct TrackpadGestureView: NSViewRepresentable {
  
  public typealias GestureCallback = ([GestureType: GestureState]) -> Void
  public typealias TouchCallback = (Set<TrackPadTouch>) -> Void
  
  private var configs: [GestureType: GestureConfig]
  
  var onGestureUpdate: GestureCallback
  var onTouchesUpdate: TouchCallback
  
  public init(
    configs: [GestureType: GestureConfig]? = nil,
    onGestureUpdate: @escaping GestureCallback,
    onTouchesUpdate: @escaping TouchCallback = { _ in }
  ) {
    // Use provided configs or defaults
    self.configs = configs ?? Dictionary(
      uniqueKeysWithValues: GestureType.allCases.map { ($0, $0.defaultConfig) }
    )
    self.onGestureUpdate = onGestureUpdate
    self.onTouchesUpdate = onTouchesUpdate
  }
  
  public func makeNSView(context: Context) -> GestureView {
    let view = GestureView()
    view.delegate = context.coordinator
    view.configs = configs
    return view
    
  }
  
  public func updateNSView(_ nsView: GestureView, context: Context) {
  }
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
}

@MainActor
protocol TrackpadGestureDelegate: AnyObject {
  func didUpdateGesture(_ type: GestureType, with state: GestureState)
  func didUpdateTouches(_ touches: Set<TrackPadTouch>)
}

public class Coordinator: NSObject, TrackpadGestureDelegate {
  
  var parent: TrackpadGestureView
  
  init(parent: TrackpadGestureView) {
    self.parent = parent
  }
  
  func didUpdateGesture(_ type: GestureType, with state: GestureState) {
    DispatchQueue.main.async {
#warning("Implement this")
//      self.parent.onGestureUpdate(type, state)
    }
  }
  
  func didUpdateTouches(_ touches: Set<TrackPadTouch>) {
    DispatchQueue.main.async {
      self.parent.onTouchesUpdate(touches)

    }
  }

}



