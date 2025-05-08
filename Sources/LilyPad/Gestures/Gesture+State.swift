//
//  Gesture+State.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import BaseHelpers
import Foundation

protocol GestureTrackable: Sendable, Equatable, Hashable {

  associatedtype GestureValue
  var value: GestureValue { get set }
  var startTouchPositions: TouchPositions? { get set }
  var lastValue: GestureValue { get set }

  //  var requiredTouchCount: Int { get }
  //  var isActive: Bool { get }

  mutating func update(
    event: TouchEventData,
    in rect: CGRect,
  )
}

public enum GestureType: Sendable {
  case draw
  case pan
  case zoom
  case rotate
}
//
//enum GestureValue {
//  case point(CGPoint)
//  case float(CGFloat)
//}

struct GestureLifecycle: GestureTrackable {

  typealias GestureValue = CGPoint

  let type: GestureType
  private(set) var value: GestureValue = .zero
  private(set) var startTouchPositions: TouchPositions?
  private(set) var lastValue: GestureValue = .zero

  init(type: GestureType) {
    self.type = type
  }

  //  func calculateDelta(from: GestureValue, to: GestureValue) -> GestureValue {
  //
  //  }

  
}


//extension GestureTrackable {
//
//}


struct MappingSpaces {
  var canvas: CGRect
  var viewport: CGRect
}

public enum TrackpadGesturePhase: String, Sendable, Equatable {
  case none
  case began
  case moved
  case ended
  case cancelled
}


struct TrackpadGestureState {

  //  var activeGestures: Set<GestureType> = []

  var pan = PanGestureState()
  var zoom = ZoomGestureState()
  //  var rotation = RotateGestureState()
  //  var drawing = DrawingGestureState()

  /// The space to which touch points are mapped (e.g., canvas or viewport)
  //  var mappingRect: CGRect = .zero

  mutating func update(event: TouchEventData, in rect: CGRect) {
    pan.update(event: event, in: rect)
    zoom.update(event: event, in: rect)
    //    rotation.update(event: event, in: rect)
    //    drawing.update(event: event, in: rect)
  }

  /// Something worth considering — a default cascade of gesture types?
  /// Though they *can* be simultaneous, so maybe this isn't the way to go.
  ///
  /// Though could maintain a `Set<ActiveGesture>`?
  ///
  /// 1. Drawing as default
  /// 2. If not drawing then Panning (e.g. *two* fingers?
  ///   But what if wanting to *draw* with two fingers?). Can set a tool for that in the UI.
  /// 3. If touches pinch and spread, then Zooming
  /// 4. If
  //  func determineActiveGestures(event: TouchEventData) -> Set<GestureType> {

  /// What are the rules?
  ///
  /// Drawing: By default, only one touch. With a tool selected, multiple touches allowed
  /// Pan: 2x touches. The default/defacto two-finger gesture type. Should be easiest to invoke
  /// Zoom: 2x touches. Detected when finger distance changes sufficiently (past threshold)
  /// Rotate: 2x touches. Similar to above, but change in rotation between the two touches


  //  }
}
