//
//  Gesture.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import SwiftUI

public typealias GestureOutput = (TrackpadGestureState) -> Void

public struct TrackpadGestureView: NSViewRepresentable {
  
  var onGestureUpdate: GestureOutput
  
  public init(onGestureUpdate: @escaping GestureOutput) {
    self.onGestureUpdate = onGestureUpdate
  }
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
  
  public func makeNSView(context: Context) -> GestureDetectingView {
    let view = GestureDetectingView()
    view.delegate = context.coordinator
    return view
  }
  
  public func updateNSView(_ nsView: GestureDetectingView, context: Context) {
  }
}

protocol TrackpadGestureDelegate: AnyObject {
  func didUpdateGesture(_ state: TrackpadGestureState)
}

public class Coordinator: NSObject, TrackpadGestureDelegate {
  var parent: TrackpadGestureView
  
  init(parent: TrackpadGestureView) {
    self.parent = parent
  }
  
  func didUpdateGesture(_ state: TrackpadGestureState) {
    DispatchQueue.main.async {
      self.parent.onGestureUpdate(state)
    }
  }
}



