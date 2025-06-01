//
//  Model+TouchEvent.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import AppKit
import BaseHelpers

public struct TouchEventData: Sendable, Equatable, Hashable {
  private let touches: Set<TouchPoint>

  /// If this value is present, then the touches should
//  public let mappingRect: CGRect?
  public static let atRest = TouchEventData(
    touches: [],
//    mappingRect: nil
  )

  public init(
    touches: Set<TouchPoint>,
//    mappingRect: CGRect?
  ) {
    self.touches = touches
//    self.mappingRect = mappingRect
  }
}

extension TouchEventData {
  public func getTouches(mappedTo mappingRect: CGRect?) -> Set<TouchPoint> {
    guard let mappingRect else {
      return touches
    }
    let mappedTouches: [TouchPoint] = touches.map { point in
      point.mapPoint(to: mappingRect)
    }
    return mappedTouches.toSet()
  }
}

extension TouchEventData: CustomStringConvertible {
  public var description: String {
    """

    TouchEventData
      - Touches (count: \(touches.count): 
          \(touches)


    """
  }
}
