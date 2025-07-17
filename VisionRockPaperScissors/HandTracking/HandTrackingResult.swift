//
//  HandTrackingResult.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

struct HandTrackingResult: Equatable {

  let chirality: HandChirality
  let distances: [Float]

  var description: String {
    return "\(String(describing: chirality)): \(distances.map { $0.formatted() }.joined(separator: ", "))"
  }

}
