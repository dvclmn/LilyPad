//
//  Model+Debug.swift
//  LilyPad
//
//  Created by Dave Coleman on 5/5/2025.
//

import Foundation

public enum TouchDebugItem: String, Identifiable, CaseIterable {
  case touchCount
  case strokeCountActive
  case strokeCountCompleted
  case strokeCountTotal
  case pointCountFiltered
//  case pointCountRaw
  case touchModeActive
  case pointerLocked
  case clickedDown
  
  public var id: String { self.rawValue }
  
  public var name: String {
    switch self {
      case .touchCount: "Touch Count"
      case .strokeCountActive: "Strokes (Active)"
      case .strokeCountCompleted: "Strokes (Completed)"
      case .strokeCountTotal: "Strokes (Total)"
      case .pointCountFiltered: "Points (Filtered)"
//      case .pointCountRaw: "Points (Raw)"
      case .touchModeActive: "Touch Mode Active"
      case .pointerLocked: "Pointer Locked"
      case .clickedDown: "Clicked Down"
    }
  }
}
