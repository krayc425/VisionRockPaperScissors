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
    WindowGroup(id: WindowIdentifiers.main.rawValue) {
      MainView()
    }
    .defaultSize(width: 400.0, height: 400.0)
    WindowGroup(id: WindowIdentifiers.handAlignment.rawValue) {
      HandAlignmentView()
    }
    .defaultSize(width: 600.0, height: 400.0)
    WindowGroup(id: WindowIdentifiers.singlePlayer.rawValue) {
      SinglePlayerView()
    }
    .defaultSize(width: 800.0, height: 800.0)
    ImmersiveSpace(id: ImmersiveSpaceIdentifiers.handTracking.rawValue) {
      HandTrackingView()
    }
  }
}
