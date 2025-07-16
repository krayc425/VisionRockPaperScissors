//
//  HandTrackingComponent.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import ARKit.hand_skeleton
import RealityKit

struct HandTrackingComponent: Component {

  let chirality: AnchoringComponent.Target.Chirality

  init(chirality: AnchoringComponent.Target.Chirality) {
    self.chirality = chirality
    HandTrackingSystem.registerSystem()
  }

}
