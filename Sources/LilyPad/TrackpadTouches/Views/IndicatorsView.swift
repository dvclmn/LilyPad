//
//  IndicatorsView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import SwiftUI
import BaseHelpers
import BaseComponents
import BaseStyles

public struct TouchIndicatorsView: View {

  let touches: Set<TouchPoint>
  let mappingRect: CGRect
  
  public var body: some View {

    ForEach(touches.array) { touch in
      Circle()
        .fill(Color.blue.opacity(0.7))
        .frame(width: 40, height: 40)
        .overlay(alignment: .top) {
          Text(touch.position.displayString)
            .monospaced()
            .roundedBackground(Styles.sizeNano, colour: AnyShapeStyle(.black.opacity(0.6)))
            .offset(y: -22)
            .font(.caption2)
            .fixedSize()
        }
        .position(touchPosition(touch))
    }
    .angledLine(from: pointPair.0, to: pointPair.1)
    .frame(
      width: mappingRect.width,
      height: mappingRect.height
    )

  }
}

extension TouchIndicatorsView {
  
  var pointPair: (CGPoint, CGPoint) {
    guard let touchPair = touches.touchPair(in: mappingRect) else { return  (.zero, .zero) }
    return (touchPair.p1, touchPair.p2)
    
  }
  
//  var firstTwoPoints: PointPair {
//    
//    let fallback: PointPair = (.zero, .zero)
//
//    guard let touchPair = touches.touchPair else { return fallback }
//    
//    let pointPair = touchPair.pointPair(in: mappingRect)
//    return pointPair
//  }
//  
  func touchPosition(_ touch: TouchPoint) -> CGPoint {
    touch.position.mapped(to: mappingRect)
  }
}

#if DEBUG
@available(macOS 15, iOS 18, *)
#Preview(traits: .size(.normal)) {
  GeometryReader { _ in
    TouchIndicatorsView(
      touches: [TouchPoint.example01, TouchPoint.example02],
      mappingRect: CGRect(x: 0, y: 0, width: 400, height: 500)
    )
  }
  .padding()
}
#endif
