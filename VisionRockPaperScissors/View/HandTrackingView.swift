//
//  HandTrackingView.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import ARKit
import RealityKit
import SwiftUI

struct HandTrackingView: View {

  var body: some View {
    RealityView { content in
      makeHandEntities(in: content)
    }
  }

  @MainActor
  func makeHandEntities(in content: any RealityViewContentProtocol) {
    let leftHand = Entity()
    leftHand.components.set(HandTrackingComponent(chirality: .left))
    content.add(leftHand)

    let rightHand = Entity()
    rightHand.components.set(HandTrackingComponent(chirality: .right))
    content.add(rightHand)
  }

}
