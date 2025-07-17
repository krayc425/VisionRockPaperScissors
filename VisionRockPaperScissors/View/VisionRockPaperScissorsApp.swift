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
        .frame(width: 600.0, height: 600.0)
    }
    .defaultSize(width: 600.0, height: 600.0)
    .windowResizability(.contentSize)
    ImmersiveSpace(id: "handalignment") {
      HandTrackingView()
    }
    ImmersiveSpace(id: "singleplayer") {
      HandTrackingView()
    }
  }
}
