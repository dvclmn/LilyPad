//
//  Gesture.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import SwiftUI

public struct TrackpadGestureView: NSViewRepresentable {
  
  public typealias GestureCallback = (GestureType, TrackpadGestureState) -> Void
  
  private var configs: [GestureType: GestureConfig]
  
//  var config: TrackpadGestureConfig
  var onGestureUpdate: GestureCallback
  
  public init(
    configs: [GestureType: GestureConfig]? = nil,
    onGestureUpdate: @escaping GestureCallback
  ) {
    // Use provided configs or defaults
    self.configs = configs ?? Dictionary(
      uniqueKeysWithValues: GestureType.allCases.map { ($0, $0.defaultConfig) }
    )
    self.onGestureUpdate = onGestureUpdate
  }
  
  public func makeNSView(context: Context) -> GestureDetectingView {
    
    let view = GestureDetectingView()
    view.delegate = context.coordinator
    view.configs = configs
    return view
    
  }
  
  public func updateNSView(_ nsView: GestureDetectingView, context: Context) {
    // Update configs if needed
    nsView.configs = configs
  }
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
}

@MainActor
protocol TrackpadGestureDelegate: AnyObject {
  func didUpdateGesture(_ type: GestureType, with state: TrackpadGestureState)
}

public class Coordinator: NSObject, TrackpadGestureDelegate {
  var parent: TrackpadGestureView
  
  init(parent: TrackpadGestureView) {
    self.parent = parent
  }
  
  func didUpdateGesture(_ type: GestureType, with state: TrackpadGestureState) {
    DispatchQueue.main.async {
      self.parent.onGestureUpdate(type, state)
//      self.onGestureUpdate(type, state)
    }
  }
  
//  func didUpdateGesture(_ state: TrackpadGestureState) {
//    DispatchQueue.main.async {
//      self.parent.onGestureUpdate(state, <#TrackpadGestureState#>)
//    }
//  }
}



