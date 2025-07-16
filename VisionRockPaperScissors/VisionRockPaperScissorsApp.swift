//
//  VisionRockPaperScissorsApp.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import SwiftUI

@main
struct VisionRockPaperScissorsApp: App {
  var body: some Scene {
    WindowGroup {
      MainView()
    }

    // The immersive space that defines `HeadPositionView`.
    ImmersiveSpace(id: "HandTrackingScene") {
      HandTrackingView()
    }
  }
}
