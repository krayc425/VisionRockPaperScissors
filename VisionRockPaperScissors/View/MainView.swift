//
//  MainView.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import SwiftUI

struct MainView: View {

  @State private var showSinglePlayerView: Bool = false
  @State private var showHandAlignmentView: Bool = false
  @State private var showSettingsView: Bool = false
  @AppStorage(UserDefaultsKeys.selectedSkintone.rawValue) private var selectedToneRawValue: String = ""

  var body: some View {
    VStack(alignment: .center, spacing: 24.0) {
      Spacer()
      Text("Rock. Paper. Scissors.")
        .font(.extraLargeTitle)
      Text(RPSResult.makeAllCasesPreview(SkinTone(rawValue: selectedToneRawValue)))
        .font(.largeTitle)
      Spacer()
      Button {
        if HandDistanceManager.shared.hasResults {
          showSinglePlayerView = true
        } else {
          showHandAlignmentView = true
        }
      } label: {
        Text("Start")
      }
      Button {
        showSettingsView = true
      } label: {
        Label("Settings", systemImage: "gear")
      }
      Spacer()
    }
    .fullScreenCover(isPresented: $showSinglePlayerView) {
      SinglePlayerView()
    }
    .fullScreenCover(isPresented: $showHandAlignmentView) {
      HandAlignmentView()
    }
    .fullScreenCover(isPresented: $showSettingsView) {
      SettingsView()
    }
  }

}

#Preview {
  MainView()
    .frame(width: 600.0, height: 600.0)
}
