////
////  Example.swift
////  LilyPad
////
////  Created by Dave Coleman on 3/5/2025.
////
//
//#if canImport(AppKit)
//import SwiftUI
//import AppKit
//
//// MARK: - Touch Trail Visualization Example
//
///// A touch with trail history
//public struct TouchWithTrail: Identifiable {
//  public var id: Int
//  public var currentPosition: CGPoint
//  public var trail: [CGPoint]
//  public var color: Color
//  
//  public init(from touch: TrackpadTouch) {
//    self.id = touch.id
//    self.currentPosition = touch.position
//    self.trail = [touch.position]
//    
//    // Generate a stable color based on the touch ID
//    let hue = CGFloat(abs(touch.id.hashValue % 20)) / 20.0
//    self.color = Color(hue: Double(hue), saturation: 0.8, brightness: 0.9)
//  }
//  
//  /// Update with a new position, maintaining trail history
//  mutating func update(with newTouch: TrackpadTouch, maxTrailLength: Int = 20) {
//    currentPosition = newTouch.position
//    trail.append(newTouch.position)
//    
//    // Limit trail length
//    if trail.count > maxTrailLength {
//      trail.removeFirst(trail.count - maxTrailLength)
//    }
//  }
//}
//
///// View that displays touch trails
//public struct TouchTrailView: View {
//  @State private var touches: Set<TrackpadTouch> = []
//  @State private var touchTrails: [Int: TouchWithTrail] = [:]
//  
//  // Configuration
//  private let maxTrailLength = 20
//  private let fadeTrail = true
//  
//  public init() {}
//  
//  public var body: some View {
//    ZStack {
//      // Background
//      Color.black
//        .edgesIgnoringSafeArea(.all)
//      
//      // Draw trails for each touch
//      ForEach(touchTrails.keys, id: \.self) { touchTrail in
////      ForEach(touchTrails, id: \.self) { touchTrail in
//        // Draw the trail as a path
//        if touchTrail.trail.count > 1 {
//          Path { path in
//            path.move(to: touchTrail.trail.first!)
//            
//            for point in touchTrail.trail.dropFirst() {
//              path.addLine(to: point)
//            }
//          }
//          .stroke(
//            touchTrail.color,
//            style: StrokeStyle(
//              lineWidth: 3,
//              lineCap: .round,
//              lineJoin: .round
//            )
//          )
//          .opacity(fadeTrail ? 0.7 : 1.0)
//          .animation(.easeOut(duration: 0.2), value: touchTrail.trail)
//        }
//        
//        // Draw the current touch point
//        Circle()
//          .fill(touchTrail.color)
//          .frame(width: 24, height: 24)
//          .position(
//            touchTrail.currentPosition.scaled(to: CGSize(width: 500, height: 500))
//          )
//      }
//      
//      // The invisible touch capture view
//      GeometryReader { geometry in
//        TrackpadTouchesView(touches: $touches) { updatedTouches in
//          processTouches(updatedTouches, in: geometry.size)
//        }
//        .allowsHitTesting(false)
//      }
//      
//      // Info overlay
//      VStack {
//        Spacer()
//        
//        Text("Active touches: \(touchTrails.count)")
//          .font(.headline)
//          .padding()
//          .background(Color.white.opacity(0.2))
//          .cornerRadius(10)
//          .padding()
//      }
//    }
//  }
//  
//  private func processTouches(_ updatedTouches: Set<TrackpadTouch>, in size: CGSize) {
//    // Create a mutable copy of the current trails
//    var updatedTrails = touchTrails
//    
//    // Process each new touch
//    for touch in updatedTouches {
//      if let existingTrail = updatedTrails[touch.id] {
//        // Update existing trail
//        var trail = existingTrail
//        trail.update(with: touch, maxTrailLength: maxTrailLength)
//        updatedTrails[touch.id] = trail
//      } else {
//        // Create new trail
//        updatedTrails[touch.id] = TouchWithTrail(from: touch)
//      }
//    }
//    
//    // Remove trails for touches that are no longer present
//    let currentIds = Set(updatedTouches.map { $0.id })
//    for id in updatedTrails.keys where !currentIds.contains(id) {
//      updatedTrails.removeValue(forKey: id)
//    }
//    
//    // Update the state
//    touchTrails = updatedTrails
//  }
//}
//
//// MARK: - Helper Extensions
//
//extension CGPoint {
//  /// Scale normalized point (0-1) to the given size
//  func scaled(to size: CGSize) -> CGPoint {
//    return CGPoint(
//      x: self.x * size.width,
//      y: self.y * size.height
//    )
//  }
//}
//
//// MARK: - Preview Provider
//
//struct TouchTrailView_Previews: PreviewProvider {
//  static var previews: some View {
//    TouchTrailView()
//      .frame(width: 600, height: 400)
//  }
//}
//#endif
