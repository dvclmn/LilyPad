//
//  TouchesView.swift
//  LilyPad
//
//  Created by Dave Coleman on 7/5/2025.
//

import SwiftUI

public struct TouchesView<Content: View>: View {
  @State private var touches: Set<TouchPoint> = []
  
  public typealias Touches = (Set<TouchPoint>) -> Content
  
  let showIndicators: Bool
  let canvasSize: CGSize
  let content: Touches
  
  public init(
    showIndicators: Bool = true,
    canvasSize: CGSize,
    @ViewBuilder content: @escaping Touches,
  ) {
    self.showIndicators = showIndicators
    self.canvasSize = canvasSize
    self.content = content
  }
  
  public var body: some View {
    
    ZStack {
      content(touches)
      TouchIndicatorsView(touches: touches, canvasSize: canvasSize)
      TrackpadTouchesView { touches in
        self.touches = touches
      } onPressureUpdate: { pressure in
        // Nothing for now
      }
    }
  }
}
