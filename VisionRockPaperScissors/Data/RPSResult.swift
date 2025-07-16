//
//  RecognitionResult.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import Foundation

enum RPSResult: CaseIterable {

  case rock
  case paper
  case scissor

  var emoji: String {
    switch self {
      case .rock:
        return "✊"
      case .paper:
        return "🖐"
      case .scissor:
        return "✌️"
    }
  }

}
