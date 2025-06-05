//
//  Gesture+Interpreter.swift
//  LilyPad
//
//  Created by Dave Coleman on 4/6/2025.
//

import BaseHelpers
import Foundation

public struct GestureRecogniser {
  
  
  
  
//
//  /// How often, and when will this be called?
//  public static func interpretGesture(
//    from currentTouchPair: TouchPair,
////    from touches: [MappedTouchPoint],
//    initialPair: TouchPair
//  ) -> GestureType {
////    guard let currentouchPair = TouchPair(touches) else { throw GestureError.touchesNotEqualToTwo }
//    let gestureType = GestureType(
//      currentTouchPair: currentTouchPair,
//      initialPair: initialPair
//    )
//    return gestureType
//  }
}


struct RollingBuffer<Value> {
  private var buffer: [Value] = []
  private let capacity: Int
  
  init(capacity: Int) {
    print("Initialising a rolling buffer with capacity \(capacity)")
    self.capacity = capacity
  }
  
  mutating func add(_ value: Value) {
    print("Adding value \(value) to rolling buffer")
    buffer.append(value)
    if buffer.count > capacity {
      buffer.removeFirst()
    }
  }
  
  var values: [Value] {
    buffer
  }
  
  var isFull: Bool {
    buffer.count >= capacity
  }
}

struct GestureSampler {
  private let sampleDistanceThreshold: CGFloat = 4
  private(set) var buffer = RollingBuffer<TouchPair>(capacity: 8)
  
  mutating func ingest(_ pair: TouchPair) {
    print("Ingesting a touch pair \(pair) for sampling")
    guard let last = buffer.values.last else {
      buffer.add(pair)
      return
    }
    
    let dist = pair.distance(to: last)
    print("Pair distance is \(dist). Distance threshold is \(sampleDistanceThreshold)")
    
    if dist >= sampleDistanceThreshold {
      buffer.add(pair)
    }
  }
  
  var count: Int {
    buffer.values.count
  }
  
  var totalTranslation: CGFloat {
    guard let first = buffer.values.first, let last = buffer.values.last else { return 0 }
    return last.midPointBetween.distance(to: first.midPointBetween)
//    return last.midpoint.distance(to: first.midpoint)
  }
  
  var totalRotation: CGFloat {
    guard let first = buffer.values.first, let last = buffer.values.last else { return 0 }
    let raw = last.angleInRadiansBetween - first.angleInRadiansBetween
    return min(abs(raw), 2 * .pi - abs(raw))  // shortest rotation
  }
  
  var totalPinchDelta: CGFloat {
    guard let first = buffer.values.first, let last = buffer.values.last else { return 0 }
    return abs(last.distanceBetween - first.distanceBetween)
  }
  
  mutating func clear() {
    buffer = RollingBuffer(capacity: buffer.values.capacity)
  }
}
