//
//  HandTrackingView.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import ARKit
import RealityKit
import SwiftUI

/// A reality view that contains all hand-tracking entities.
struct HandTrackingView: View {
  /// The main body of the view.
  var body: some View {
    RealityView { content in
      makeHandEntities(in: content)
    }
  }

  /// Creates the entity that contains all hand-tracking entities.
  @MainActor
  func makeHandEntities(in content: any RealityViewContentProtocol) {
    // Add the left hand.
    let leftHand = Entity()
    leftHand.components.set(HandTrackingComponent(chirality: .left))
    content.add(leftHand)

    // Add the right hand.
    let rightHand = Entity()
    rightHand.components.set(HandTrackingComponent(chirality: .right))
    content.add(rightHand)
  }
}

