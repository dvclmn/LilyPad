//
//  ExampleView.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import SwiftUI

struct ExampleView: View {
  
  @State private var gestureHandler: ActionLineGestureHandler = .init()
  @State private var displayText = "No gesture detected"
  
  var body: some View {
    
    Text("Hello")
      .padding(40)
      .trackpadGestures { state in
        let updates = gestureHandler.handleGesture(state)
        
        
        
        //        handler.lines.innerShape.radius = updates.innerRadius
        //        handler.lines.rotation = updates.rotation
        //        handler.lines.density = updates.density
        
        
        // Update display text
        self.displayText = """
                            Inner Radius: \(updates.innerRadius)
                            Rotation: \(updates.rotation)
                            Density: \(updates.density)
                            """
      }
    VStack {
      Button("Reset Zoom") {
        gestureHandler.reset()
        // Reset to default values
//        handler.lines.innerShape.radius = 0.2
      }
      .padding()
      
      Text(displayText)
        .padding()
    }
    
  }
}
#if DEBUG

#Preview {
  ExampleView()
}
#endif

