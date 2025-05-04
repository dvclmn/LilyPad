//
//  AppHandler.swift
//  LilyPad
//
//  Created by Dave Coleman on 3/5/2025.
//

import SwiftUI
import BaseHelpers

@Observable
public final class AppHandler {
  
  var touches: Set<TrackpadTouch> = []
  
  var strokeHandler = StrokeHandler()
  
  let isDebugMode: Bool = false
  var windowSize: CGSize = .zero
  var isPointerLocked: Bool = false
  var isClicked: Bool = false
  
  public init() {}
  
}

extension AppHandler {
  
  var trackPadSize: CGSize {
    let trackPadWidth: CGFloat = 700
    let trackPadAspectRatio: CGFloat = 10.0 / 16.0
    
    let trackPadHeight: CGFloat = trackPadWidth * trackPadAspectRatio
    
    return CGSize(
      width: trackPadWidth,
      height: trackPadHeight
    )
  }
  
  func transformPoint(_ point: CGPoint, in size: CGSize) -> CGPoint {
    /// Assuming normalized points (0–1 range)
    return CGPoint(
      x: point.x * size.width,
      y: point.y * size.height
    )
  }
  
  func touchPosition(
    _ touch: TrackpadTouch
  ) -> CGPoint {
    
    let originX: CGFloat = 0
    let originY: CGFloat = 0

    let x = originX + (touch.position.x * trackPadSize.width)
    let y = originY + (touch.position.y * trackPadSize.height)
    
    return CGPoint(x: x, y: y)
  }
  
  var isInTouchMode: Bool {
    !isClicked && isPointerLocked
  }
  
  /// Process touch updates and update strokes
  public func processTouches() {
    
    guard isInTouchMode else {
      print("No need to process touches, not in touch mode.")
      return
    }
    
    if isDebugMode { print("Processing touches. Touch count: \(touches.count)") }
    /// Process each touch to update strokes
    for touch in touches {
      let touchId = touch.id
      let touchPosition = touchPosition(touch)
      
      /// Calculate width based on velocity
      let width = strokeHandler.strokeWidth.calculateStrokeWidth(for: touch)

      /// Update or create stroke for this touch
      if var stroke = strokeHandler.activeStrokes[touchId] {
        if isDebugMode {
          print("There are active strokes for touch \(touchId). Count: \(stroke.points.count)")
          print("Point count for stroke BEFORE: \(stroke.points.count)")
        }

        stroke.addPoint(touchPosition, width: width)
        strokeHandler.activeStrokes[touchId] = stroke
        
//        if isDebugMode {
//          print("Point count for stroke AFTER: \(stroke.points.count)")
//          print("`activeStrokes[touchId]`: \(String(describing: activeStrokes[touchId]?.points.count))")
//          print("`stroke.points.count`: \(String(describing: stroke.points.count))")
//        }
        
      } else {
        /// New touch, create a new stroke
        if isDebugMode {  print("Creating a new stroke for touch \(touchId)") }
        
        let stroke = TouchStroke(points: [touchPosition], color: .purple)
        strokeHandler.activeStrokes[touchId] = stroke
      }
    }
    
    /// Check for ended touches
    let currentIds = Set(touches.map { $0.id })
    let activeIds = Set(strokeHandler.activeStrokes.keys)
    let endedIds = activeIds.subtracting(currentIds)
    
    /// Finalize ended strokes
    for touchId in endedIds {
      if let stroke = strokeHandler.activeStrokes[touchId], stroke.points.count >= strokeHandler.minPointsForCurve {
//        if isDebugMode {  print("Adding a stroke to completed strokes. Completed Count: \(completedStrokes.count)") }
        strokeHandler.completedStrokes.append(stroke)
      }
      strokeHandler.activeStrokes.removeValue(forKey: touchId)
    }
  }
  
  // MARK: - Strokes
  
  public func clearStrokes() {
    strokeHandler.activeStrokes.removeAll()
    strokeHandler.completedStrokes.removeAll()
  }
  
  
  
}

