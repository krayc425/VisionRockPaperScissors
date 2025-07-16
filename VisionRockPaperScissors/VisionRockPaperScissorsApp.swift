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
    .defaultSize(width: 600.0, height: 600.0)
    ImmersiveSpace(id: ImmersiveSpaceIdentifiers.handTracking.rawValue) {
      HandTrackingView()
    }
  }
}
