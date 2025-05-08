//
//  DrawingCommandsModifier.swift
//  LilyPad
//
//  Created by Dave Coleman on 8/5/2025.
//

import SwiftUI

// Define a protocol for handling drawing commands
public protocol DrawingCommandHandler {
  func handleCommand(_ command: DrawingCommand)
}

public enum DrawingCommand {
  case lockPointer
  case clearCanvas
  
  public var keyboardShortcut: KeyboardShortcut {
    switch self {
      case .lockPointer:
        KeyboardShortcut("a")
      case .clearCanvas:
        KeyboardShortcut("c")
    }
  }
  
  /// Map from key to command
  public static func fromKey(_ key: KeyEquivalent) -> DrawingCommand? {
    switch key {
      case "a": return .lockPointer
      case "c": return .clearCanvas
      default: return nil
    }
  }
}

/// Example usage in a view:
///
/// ```
/// struct DrawingView: View, DrawingCommandHandler {
///     @StateObject private var viewModel = DrawingViewModel()
///
///     var body: some View {
///         Canvas { context, size in
///             // Drawing code
///         }
///         .drawingCommands(handler: self)
///     }
///
///     // Implement the command handler protocol
///     func handleCommand(_ command: DrawingCommand) {
///         switch command {
///         case .lockPointer:
///             viewModel.isPointerLocked.toggle()
///         case .clearCanvas:
///             viewModel.clearStrokes()
///         }
///     }
/// }
/// ```
public struct DrawingCommandsModifier: ViewModifier {

  let commandHandler: DrawingCommandHandler
  @FocusState private var isFocused: Bool

  public func body(content: Content) -> some View {
    content
      .focusable(true)
      .focused($isFocused)
      .focusEffectDisabled(true)
      .onAppear {
        isFocused = true
      }
      .onKeyPress { keyPress in
        return handleKeyPress(keyPress.key)
      }
    

  }
}
extension DrawingCommandsModifier {
  private func handleKeyPress(_ key: KeyEquivalent) -> KeyPress.Result {
    if let command = DrawingCommand.fromKey(key) {
      commandHandler.handleCommand(command)
      return .handled
    }
    return .ignored
  }
}
extension View {
  public func drawingCommands(handler: DrawingCommandHandler) -> some View {
    self.modifier(DrawingCommandsModifier(commandHandler: handler))
  }
}

