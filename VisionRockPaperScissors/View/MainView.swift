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
    VStack(alignment: .center) {
      Spacer()
      Text(RPSResult.makeAllCasesPreview(SkinTone(rawValue: selectedToneRawValue)))
        .font(.largeTitle)
      Spacer(minLength: 24.0)
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
        Text("Settings")
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
