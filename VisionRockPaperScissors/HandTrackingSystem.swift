import ARKit
import RealityKit

/// A system that provides hand-tracking capabilities.
struct HandTrackingSystem: System {

  static var arSession = ARKitSession()

  /// The provider instance for hand-tracking.
  static let handTracking = HandTrackingProvider()

  /// The most recent anchor that the provider detects on the left hand.
  static var latestLeftHand: HandAnchor?

  /// The most recent anchor that the provider detects on the right hand.
  static var latestRightHand: HandAnchor?

  init(scene: RealityKit.Scene) {
    Task {
      await Self.runSession()
    }
  }

  @MainActor
  static func runSession() async {
    do {
      // Attempt to run the ARKit session with the hand-tracking provider.
      try await arSession.run([handTracking])
    } catch let error as ARKitSession.Error {
      print("The app has encountered an error while running providers: \(error.localizedDescription)")
    } catch let error {
      print("The app has encountered an unexpected error: \(error.localizedDescription)")
    }

    // Start to collect each hand-tracking anchor.
    for await anchorUpdate in handTracking.anchorUpdates {
      // Check whether the anchor is on the left or right hand.
      switch anchorUpdate.anchor.chirality {
        case .left:
          self.latestLeftHand = anchorUpdate.anchor
        case .right:
          self.latestRightHand = anchorUpdate.anchor
      }
    }
  }

  /// The query this system uses to find all entities with the hand-tracking component.
  static let query = EntityQuery(where: .has(HandTrackingComponent.self))

  /// Performs any necessary updates to the entities with the hand-tracking component.
  /// - Parameter context: The context for the system to update.
  func update(context: SceneUpdateContext) {
    let handEntities = context.entities(matching: Self.query, updatingSystemWhen: .rendering)

    for entity in handEntities {
      guard let handComponent = entity.components[HandTrackingComponent.self] else {
        continue
      }

      // Get the hand anchor for the component, depending on its chirality.
      guard let handAnchor: HandAnchor = switch handComponent.chirality {
      case .left: Self.latestLeftHand
      case .right: Self.latestRightHand
      default: nil
      } else {
        continue
      }

      // Iterate through all of the anchors on the hand skeleton.
      if let handSkeleton = handAnchor.handSkeleton {
        for (jointName, jointEntity) in handComponent.fingers {
          /// The current transform of the person's hand joint.
          let anchorFromJointTransform = handSkeleton.joint(jointName).anchorFromJointTransform

          // Update the joint entity to match the transform of the person's hand joint.
          jointEntity.setTransformMatrix(
            handAnchor.originFromAnchorTransform * anchorFromJointTransform,
            relativeTo: nil
          )
        }
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

        let gesture = classifyGesture(
          wrist: wristWorld,
          tips: [thumbWorld, indexWorld, middleWorld, ringWorld, littleWorld]
        )
        print("Hand gesture \(gesture)")
      }
    }
  }

  func classifyGesture(wrist: simd_float3, tips: [simd_float3]) -> String {
    guard tips.count == 5 else {
      return "unknown"
    }
    let distances = tips.map { simd_distance($0, wrist) }

    debugPrint("Distances \(distances)")

    let close = distances.filter { $0 < 0.1 }.count
    let far = distances.filter { $0 > 0.1 }.count

    if close == 5 {
      return "rock"
    } else if far == 5 {
      return "paper"
    } else if distances[1] > 0.1 && distances[2] > 0.1 && // index, middle 伸出
                distances[0] < 0.1 && distances[3] < 0.1 && distances[4] < 0.1 {
      return "scissors"
    }

    return "unknown"
  }

}
extension simd_float4x4 {
  var position: simd_float3 {
    simd_make_float3(columns.3)
  }
}
