//
//  LineBetweenAngleModifier.swift
//  LilyPad
//
//  Created by Dave Coleman on 11/5/2025.
//

import SwiftUI
import BaseHelpers

public struct AngledLineConfig: Equatable {
  //  var p1: CGPoint
  //  var p2: CGPoint
  var lineColour: Color = .blue
  var lineWidth: CGFloat = 2
  var textColour: Color = .white
  var textBackgroundColour: Color = .black.opacity(0.7)
}

public struct AngleLineModifier: ViewModifier {
  
  let touches: Set<TouchPoint>
  let mappingRect: CGRect
  let config: AngledLineConfig
  let debouncer = AsyncDebouncer(interval: 0.4)
  
  @State private var angleString: String = "—"
  
  public func body(content: Content) -> some View {
    content
      .overlay {
        Canvas {
          context,
          size in
          /// Draw line between the two points
          let path = Path { path in
            path.move(to: pointPair.0)
            path.addLine(to: pointPair.1)
          }
          
          context.stroke(
            path,
            with: .color(config.lineColour),
            lineWidth: config.lineWidth
          )
          
        }
        .overlay {
          if touches.count >= 2 {
            Text(angleString)
              .position(CGPoint.midPoint(from: pointPair.0, to: pointPair.1))
          }
        }
      }
//      .task(id: config) {
//        await debouncer.execute { @MainActor in
//          let value = CGPoint.angleInRadians(from: config.p1, to: config.p2).toDegrees.displayString
//          angleString = value
//        }
//      }
  }
}
extension AngleLineModifier {
  
  var pointPair: (CGPoint, CGPoint) {
    guard let touchPair = touches.touchPair(in: mappingRect) else { return  (.zero, .zero) }
    return (touchPair.p1, touchPair.p2)
  }
  
}

extension View {
  public func angledLine(
    between touches: Set<TouchPoint>,
    mappingRect: CGRect,
    lineColour: Color = .blue,
    lineWidth: CGFloat = 2,
    textColour: Color = .white,
    textBackgroundColour: Color = .black.opacity(0.7),
  ) -> some View {
    self.modifier(
      AngleLineModifier(
        touches: touches,
        mappingRect: mappingRect,
        config: AngledLineConfig(
          lineColour: lineColour,
          lineWidth: lineWidth,
          textColour: textColour,
          textBackgroundColour: textBackgroundColour
        )
      )
    )
  }
}


//public struct ExampleLineBetweenView: View {
//  
//  let p1: CGPoint = .init(x: 200, y: 300)
//  let p2: CGPoint = .init(x: 400, y: 600)
//  
//  public var body: some View {
//    
//    Text("Hello")
//      .frame(width: 600, height: 700)
//      .angledLine(from: p1, to: p2)
//    
//  }
//}
//#if DEBUG
//#Preview {
//  ExampleLineBetweenView()
//}
//#endif
