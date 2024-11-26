//
//  GestureMapping.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import SwiftUI


struct GestureValueMapper {

  static func normalizeValue(
    gesture: Double,
    inputRange: ClosedRange<Double> = -1...1,
    outputRange: ClosedRange<Double>,
    sensitivity: Double = 1.0
  ) -> CGFloat {
    let normalizedInput = (gesture - inputRange.lowerBound) / (inputRange.upperBound - inputRange.lowerBound)
    let scaledValue = normalizedInput * sensitivity
    let mappedValue = outputRange.lowerBound + (scaledValue * (outputRange.upperBound - outputRange.lowerBound))
    return mappedValue.clamped(to: outputRange)
  }
}

class ActionLineGestureHandler {
  
    
    let innerRadiusUpdate = calculateZoom(from: effectiveMagnification)
    let rotationUpdate = calculateRotation(from: state.rotation)
    let densityUpdate = calculateDensity(from: state.scrollDeltaY)
    
    
    return ActionLineUpdates(
      innerRadius: innerRadiusUpdate,
      rotation: rotationUpdate,
      density: densityUpdate
    )
  }

  func resetMagnification() {
    accumulatedMagnification = 1.0
  }


  
  private func calculateZoom(from magnification: CGFloat) -> Double {
    // Adjust the mapping to work with accumulated values
    let baseValue = 0.2 // Your default/initial value
    let sensitivity = 0.05
    let mappedValue = baseValue * Double(magnification * sensitivity)
    
    return mappedValue
  }

  private func calculateRotation(from rotation: Double) -> Double {
    return Double(rotation.clamped(to: 0...359.99) * 0.05) * .pi * 2
  }

  
  private func calculateDensity(from scrollDelta: CGFloat) -> Double {
    let mapped = GestureValueMapper.normalizeValue(
      gesture: -scrollDelta,
      outputRange: 1...800,
      sensitivity: 0.0003
    )
    return Double(mapped)
  }



}


// 3. Create a struct to hold parameter updates
//struct ActionLineUpdates {
//  let innerRadius: Double
//  let rotation: Double
//  let density: Double
//}

//struct AccumulatedGestureValues {
//  var magnification: CGFloat = 1.0
//  var rotation: CGFloat = 0.0
//  var scrollY: CGFloat = 0.0
//}
//
