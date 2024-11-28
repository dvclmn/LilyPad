//
//  Gesture.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import SwiftUI

public struct TrackpadGestureView: NSViewRepresentable {
  
//  public typealias GestureCallback = ([GestureType: GestureState]) -> Void
  public typealias GestureOutput = (GestureType, CGFloat) -> Void
  public typealias TouchCallback = (Set<TrackPadTouch>) -> Void
  
  
  private var configs: [GestureType: GestureConfig]
  
  var gestureOutput: GestureOutput
//  var onGestureUpdate: GestureCallback
//  var onTouchesUpdate: TouchCallback
  
  public init(
    configs: [GestureType: GestureConfig]? = nil,
    gestureOutput: @escaping GestureOutput
//    onTouchesUpdate: @escaping TouchCallback = { _ in }
  ) {
    // Use provided configs or defaults
    self.configs = configs ?? Dictionary(
      uniqueKeysWithValues: GestureType.allCases.map { ($0, $0.defaultConfig) }
    )
    self.gestureOutput = gestureOutput
//    self.onTouchesUpdate = onTouchesUpdate
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

//@MainActor
//protocol TrackpadGestureDelegate: AnyObject {
////  func didUpdateGesture(_ type: GestureType, with state: GestureState)
//  func didUpdatePan(x: CGFloat, y: CGFloat)
//  func didUpdateTouches(_ touches: Set<TrackPadTouch>)
//}

@MainActor
public class Coordinator: NSObject {
  
  var parent: TrackpadGestureView
  
  init(parent: TrackpadGestureView) {
    self.parent = parent
  }
  
  func didUpdateGesture(_ type: GestureType, _ newValue: CGFloat) {
    DispatchQueue.main.async {
      self.parent.gestureOutput(type, newValue)
    }
  }
  
  func didUpdateTouches(_ touches: Set<TrackPadTouch>) {
    DispatchQueue.main.async {
//      self.parent.onTouchesUpdate(touches)

    }
  }

}



