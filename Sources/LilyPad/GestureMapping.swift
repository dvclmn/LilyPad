//
//  GestureMapping.swift
//  LilyPad
//
//  Created by Dave Coleman on 26/11/2024.
//

import SwiftUI

struct GestureValueMapper {
  // Helps convert raw gesture values to usable parameter ranges
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
  //  private var baseInnerRadius: Double
  //  private var baseOuterRadius: Double
  
  private var accumulated = AccumulatedGestureValues()
  private var isGestureInProgress: Bool = false
  private var activeGestureTypes: Set<GestureType> = []
  
  enum GestureType {
    case magnification
    case rotation
    case scroll
  }
  
  //  private var accumulatedMagnification: CGFloat = 1.0
  //  private var isGestureInProgress: Bool = false
  
  //  init(initialInnerRadius: Double, initialOuterRadius: Double) {
  //    self.baseInnerRadius = initialInnerRadius
  //    self.baseOuterRadius = initialOuterRadius
  //  }
  
  func handleGesture(_ state: TrackpadGestureState) -> ActionLineUpdates {
    updateGestureState(state)
    
    // Calculate effective values using accumulated values
    let effectiveMagnification = calculateEffectiveValue(
      current: state.magnification,
      accumulated: accumulated.magnification,
      type: .magnification
    )
    
    let effectiveRotation = calculateEffectiveValue(
      current: state.rotation,
      accumulated: accumulated.rotation,
      type: .rotation
    )
    
    let effectiveScroll = calculateEffectiveValue(
      current: state.scrollDeltaY,
      accumulated: accumulated.scrollY,
      type: .scroll
    )
    
    return ActionLineUpdates(
      innerRadius: calculateInnerRadius(from: effectiveMagnification),
      rotation: calculateRotation(from: effectiveRotation),
      density: calculateDensity(from: effectiveScroll)
    )
  }
  
  private func updateGestureState(_ state: TrackpadGestureState) {
    switch state.phase {
      case .began:
        isGestureInProgress = true
        if state.magnification != 1.0 { activeGestureTypes.insert(.magnification) }
        if state.rotation != 0.0 { activeGestureTypes.insert(.rotation) }
        if state.scrollDeltaY != 0.0 { activeGestureTypes.insert(.scroll) }
        
      case .ended, .cancelled:
        isGestureInProgress = false
        // Accumulate final values for active gestures
        if activeGestureTypes.contains(.magnification) {
          accumulated.magnification *= state.magnification
        }
        if activeGestureTypes.contains(.rotation) {
          accumulated.rotation += state.rotation
        }
        if activeGestureTypes.contains(.scroll) {
          accumulated.scrollY += state.scrollDeltaY
        }
        activeGestureTypes.removeAll()
        
      default:
        break
    }
  }
  
  private func calculateEffectiveValue(
    current: CGFloat,
    accumulated: CGFloat,
    type: GestureType
  ) -> CGFloat {
    if isGestureInProgress && activeGestureTypes.contains(type) {
      switch type {
        case .magnification:
          return accumulated * current
        case .rotation, .scroll:
          return accumulated + current
      }
    }
    return accumulated
  }
  
  private func calculateInnerRadius(from magnification: CGFloat) -> Double {
    let config = GestureParameterConfig.magnification
    let value = config.baseValue * Double(magnification * config.sensitivity)
    return value.clamped(to: config.range)
  }
  
  private func calculateRotation(from rotation: CGFloat) -> Double {
    let config = GestureParameterConfig.rotation
    let direction = config.invertDirection ? -1.0 : 1.0
    let value = direction * Double(rotation) * config.sensitivity * .pi * 2
    return value.clamped(to: config.range)
  }
  
  private func calculateDensity(from scrollDelta: CGFloat) -> Double {
    let config = GestureParameterConfig.density
    let direction = config.invertDirection ? -1.0 : 1.0
    let value = GestureValueMapper.normalizeValue(
      gesture: CGFloat(direction) * scrollDelta,
      outputRange: CGFloat(config.range.lowerBound)...CGFloat(config.range.upperBound),
      sensitivity: config.sensitivity
    )
    return Double(value)
  }
  
  func reset() {
    accumulated = AccumulatedGestureValues()
    activeGestureTypes.removeAll()
    isGestureInProgress = false
  }
  
  
  
  //  func handleGesture(_ state: TrackpadGestureState) -> ActionLineUpdates {
  //    // Handle gesture phases to track start/end of gestures
  //    switch state.phase {
  //      case .began:
  //        isGestureInProgress = true
  //      case .ended, .cancelled:
  //        isGestureInProgress = false
  //        // Store the final magnification value when gesture ends
  //        accumulatedMagnification *= state.magnification
  //      default:
  //        break
  //    }
  //
  //    // Calculate the effective magnification
  //    let effectiveMagnification = isGestureInProgress ? (accumulatedMagnification * state.magnification) : accumulatedMagnification
  //
  //    let innerRadiusUpdate = calculateInnerRadius(from: effectiveMagnification)
  //    let rotationUpdate = calculateRotation(from: state.rotation)
  //    let densityUpdate = calculateDensity(from: state.scrollDeltaY)
  //
  //
  //    return ActionLineUpdates(
  //      innerRadius: innerRadiusUpdate,
  //      rotation: rotationUpdate,
  //      density: densityUpdate
  //    )
  //  }
  //
  //  // Add method to reset accumulation if needed
  //  func resetMagnification() {
  //    accumulatedMagnification = 1.0
  //  }
  //
  //
  //
  //
  //  private func calculateInnerRadius(from magnification: CGFloat) -> Double {
  //    // Adjust the mapping to work with accumulated values
  //    let baseValue = 0.2 // Your default/initial value
  //    let sensitivity = 0.05
  //    let mappedValue = baseValue * Double(magnification * sensitivity)
  //
  //    return mappedValue
  //  }
  //
  //  private func calculateRotation(from rotation: Double) -> Double {
  //    return Double(rotation.clamped(to: ActionLineParameter.rotation.range) * 0.05) * .pi * 2
  //  }
  //
  //  private func calculateDensity(from scrollDelta: CGFloat) -> Double {
  //    let mapped = GestureValueMapper.normalizeValue(
  //      gesture: -scrollDelta,
  //      outputRange: ActionLineParameter.density.range,
  //      sensitivity: 0.0003
  //    )
  //    return Double(mapped)
  //  }
}


// 3. Create a struct to hold parameter updates
struct ActionLineUpdates {
  let innerRadius: Double
  let rotation: Double
  let density: Double
}

struct AccumulatedGestureValues {
  var magnification: CGFloat = 1.0
  var rotation: CGFloat = 0.0
  var scrollY: CGFloat = 0.0
}

// Parameter configuration structure
struct GestureParameterConfig {
  let sensitivity: Double
  let range: ClosedRange<Double>
  let baseValue: Double
  let invertDirection: Bool
  
  static let magnification = GestureParameterConfig(
    sensitivity: 0.05,
    range: 0.05...2.0,
    baseValue: 0.2,
    invertDirection: false
  )
  
  static let rotation = GestureParameterConfig(
    sensitivity: 0.05,
    range: -Double.pi...Double.pi,
    baseValue: 0.0,
    invertDirection: true  // Flip rotation direction
  )
  
  static let density = GestureParameterConfig(
    sensitivity: 0.0003,
    range: 10...200,
    baseValue: 50,
    invertDirection: true  // Invert scroll direction if needed
  )
}

extension Comparable {
  func clamped(to limits: ClosedRange<Self>) -> Self {
    min(max(self, limits.lowerBound), limits.upperBound)
  }
}
