//
//  MainView.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import SwiftUI

struct MainView: View {
  /// The environment value to get the `OpenImmersiveSpaceAction` instance.
  @Environment(\.openImmersiveSpace) var openImmersiveSpace

  var body: some View {
    Text("Hand Tracking Example")
      .onAppear {
        Task {
          await openImmersiveSpace(id: "HandTrackingScene")
        }
      }
  }
}

#Preview(windowStyle: .automatic) {
  MainView()
}
