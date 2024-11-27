//
//  ViewModifier.swift
//  LilyPad
//
//  Created by Dave Coleman on 27/11/2024.
//

import SwiftUI

struct GestureValues {
  var zoom: CGFloat = 1.0
  var rotation: CGFloat = .zero
  var pan: CGPoint = .zero
}

public struct GestureModifier: ViewModifier {
  
  @State private var gestures: GestureValues = .init()
  
  private let isDebugMode: Bool = true
  
  public func body(content: Content) -> some View {
    ZStack {
      content
        .scaleEffect(gestures.zoom)
        .offset(x: gestures.pan.x, y: gestures.pan.y)
        .rotationEffect(.degrees(gestures.rotation))
      
      TrackpadGestureView { gestureType, state in
        switch gestureType {
          case .zoom:
            print("Zoom: \(state.total)")
            self.gestures.zoom = state.total
          case .rotation:
            print("Rotation: \(state.total)")
            self.gestures.rotation = state.total
          case .panX:
            print("Pan X: \(state.total)")
            self.gestures.pan.x = state.total
          case .panY:
            print("Pan Y: \(state.total)")
            self.gestures.pan.y = state.total
        }
      } // END gesture view
    } // END zstack
    .overlay {
      RotationDebugGauge()
        .frame(width: 200)
    }
  }
}
public extension View {
  func trackpadGestures() -> some View {
    self.modifier(
      GestureModifier()
    )
  }
}



struct RotationDebugGauge: View {
  
  let currentAngle: Double = .zero
  
  var body: some View {
    VStack {
      Canvas { context, size in
        
        let center = CGPoint(x: size.width/2, y: size.height/2)
        let radius = min(size.width, size.height)/2 * 0.9
        
        /// Draw outer circle
        let circlePath = Path { path in
          path.addArc(center: center,
                      radius: radius,
                      startAngle: .degrees(0),
                      endAngle: .degrees(360),
                      clockwise: false)
        }
        context.stroke(circlePath, with: .color(.gray), lineWidth: 2)
        
        /// Draw angle marks
        for angle in stride(from: 0, to: 360, by: 30) {
          
          let angleAsDouble = Double(angle)
          
          let markStart = CGPoint(
            x: center.x + cos(Angle(degrees: angleAsDouble).radians - .pi/2) * radius * 0.9,
            y: center.y + sin(Angle(degrees: angleAsDouble).radians - .pi/2) * radius * 0.9
          )
          let markEnd = CGPoint(
            x: center.x + cos(Angle(degrees: angleAsDouble).radians - .pi/2) * radius,
            y: center.y + sin(Angle(degrees: angleAsDouble).radians - .pi/2) * radius
          )
          
          let markColor = angleAsDouble.truncatingRemainder(dividingBy: 90) == 0 ? Color.red : Color.black
          let lineWidth = angleAsDouble.truncatingRemainder(dividingBy: 90) == 0 ? 3.0 : 1.0
          
          context.stroke(
            Path { path in
              path.move(to: markStart)
              path.addLine(to: markEnd)
            },
            with: .color(markColor),
            lineWidth: lineWidth
          )
          
          /// Label each mark
          context.draw(
            Text("\(angle)°/\(String(format: "%.2f", angleAsDouble * .pi / 180))r")
              .font(.system(size: 10)),
            at: CGPoint(
              x: center.x + cos(Angle(degrees: angleAsDouble).radians - .pi/2) * radius * 1.1,
              y: center.y + sin(Angle(degrees: angleAsDouble).radians - .pi/2) * radius * 1.1
            ),
            anchor: .center
          )
        }
        
        /// Current angle indicator
        let indicatorEnd = CGPoint(
          x: center.x + cos(Angle(degrees: currentAngle).radians - .pi/2) * radius * 0.8,
          y: center.y + sin(Angle(degrees: currentAngle).radians - .pi/2) * radius * 0.8
        )
        
        context.stroke(
          Path { path in
            path.move(to: center)
            path.addLine(to: indicatorEnd)
          },
          with: .color(.blue),
          lineWidth: 4
        )
      } // END canvas
      
      
//      Slider(value: $currentAngle, in: 0...360)
//        .padding()
      
      Text("\(Int(currentAngle))°/\(String(format: "%.2f", currentAngle * .pi / 180))r")
    }
  }
}
