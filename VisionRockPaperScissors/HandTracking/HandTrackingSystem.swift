//
//  HandTrackingSystem.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import ARKit
import Combine
import RealityKit

struct HandTrackingSystem: System {

  static var arSession = ARKitSession()
  static let query = EntityQuery(where: .has(HandTrackingComponent.self))
  static let handTracking = HandTrackingProvider()
  static var latestLeftHand: HandAnchor?
  static var latestRightHand: HandAnchor?

  static var handTrackingLeftResultPublisher = PassthroughSubject<HandTrackingResult, Never>()
  static var handTrackingRightResultPublisher = PassthroughSubject<HandTrackingResult, Never>()

  init(scene: RealityKit.Scene) {
    Task {
      await Self.runSession()
    }
  }

  @MainActor
  static func runSession() async {
    do {
      try await arSession.run([handTracking])
    } catch let error as ARKitSession.Error {
      debugPrint("The app has encountered an error while running providers: \(error.localizedDescription)")
    } catch let error {
      debugPrint("The app has encountered an unexpected error: \(error.localizedDescription)")
    }

    for await anchorUpdate in handTracking.anchorUpdates {
      switch anchorUpdate.anchor.chirality {
        case .left:
          self.latestLeftHand = anchorUpdate.anchor
        case .right:
          self.latestRightHand = anchorUpdate.anchor
      }
    }
  }

  func update(context: SceneUpdateContext) {
    for entity in context.entities(matching: HandTrackingSystem.query, updatingSystemWhen: .rendering) {
      guard let handComponent = entity.components[HandTrackingComponent.self] else {
        continue
      }

      guard let handAnchor: HandAnchor = switch handComponent.chirality {
      case .left: Self.latestLeftHand
      case .right: Self.latestRightHand
      default: nil
      } else {
        continue
      }

      if let handSkeleton = handAnchor.handSkeleton {
        let wrist = handSkeleton.joint(.wrist).anchorFromJointTransform
        let thumbTip = handSkeleton.joint(.thumbTip).anchorFromJointTransform
        let indexTip = handSkeleton.joint(.indexFingerTip).anchorFromJointTransform
        let middleTip = handSkeleton.joint(.middleFingerTip).anchorFromJointTransform
        let ringTip = handSkeleton.joint(.ringFingerTip).anchorFromJointTransform
        let littleTip = handSkeleton.joint(.littleFingerTip).anchorFromJointTransform

        let wristWorld = (handAnchor.originFromAnchorTransform * wrist).position
        let thumbWorld = (handAnchor.originFromAnchorTransform * thumbTip).position
        let indexWorld = (handAnchor.originFromAnchorTransform * indexTip).position
        let middleWorld = (handAnchor.originFromAnchorTransform * middleTip).position
        let ringWorld = (handAnchor.originFromAnchorTransform * ringTip).position
        let littleWorld = (handAnchor.originFromAnchorTransform * littleTip).position

        let distances = [thumbWorld, indexWorld, middleWorld, ringWorld, littleWorld].map {
          simd_distance($0, wristWorld)
        }
        switch handAnchor.chirality {
          case .left:
            HandTrackingSystem.handTrackingLeftResultPublisher.send(HandTrackingResult(chirality: .left, distances: distances))
          case .right:
            HandTrackingSystem.handTrackingRightResultPublisher.send(HandTrackingResult(chirality: .right, distances: distances))
        }
      }
    }
  }

}
