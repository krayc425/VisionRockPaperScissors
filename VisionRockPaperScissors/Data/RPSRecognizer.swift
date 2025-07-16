//
//  RPSRecognizer.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import Foundation
import simd

final class RPSRecognizer {

  static func classifyGesture(distances: HandDistances, baseline: HandDistances) -> RPSResult? {
    guard distances.count == 5 && baseline.count == 5 else {
      return nil
    }

    let far = zip(distances, baseline).map { $0 >= $1 - 0.02 }
    let close = zip(distances, baseline).map { $0 <= $1 - 0.02 }

    debugPrint("Distances: \(distances), baseline: \(baseline)")
    debugPrint("Close: \(close), far: \(far)")

    if close.filter({ $0 == true }).count == 5 {
      return .rock
    }
    if far.filter({ $0 == true }).count == 5 {
      return .paper
    }
    if close[0] && far[1] && far[2] && close[3] && close[4] {
      return .scissor
    }
    return nil
  }

}
