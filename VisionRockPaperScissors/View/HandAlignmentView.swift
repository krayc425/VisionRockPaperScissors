//
//  HandAlignmentView.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import SwiftUI

struct HandAlignmentView: View {

  @AppStorage(UserDefaultsKeys.selectedSkintone.rawValue) private var selectedToneRawValue: String = ""
  @Environment(\.openImmersiveSpace) private var openImmersiveSpace
  @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = HandTrackingResultViewModel()
  @StateObject private var distanceManager = HandDistanceManager.shared
  @State private var isImmersiveSpacePresented: Bool = false
  @State private var showResetAlert: Bool = false
  @State private var showAuthorizationAlert: Bool = false

  var body: some View {
    VStack(spacing: 8.0) {
      Text("Hand Alignment")
        .font(.title)
      Text("Please raise your hands and make a gesture of \(RPSResult.paper.applySkintone(SkinTone(rawValue: selectedToneRawValue)))")
        .font(.body)
      Text(distanceManager.latestLeftDistances.map { $0.formatted() }.joined(separator: ", "))
        .font(.footnote)
        .monospaced()
      Text(distanceManager.latestRightDistances.map { $0.formatted() }.joined(separator: ", "))
        .font(.footnote)
        .monospaced()
    }
    .frame(width: 600.0, height: 600.0)
    .overlay(alignment: .topLeading) {
      Button {
        dismiss()
      } label: {
        Image(systemName: "xmark")
      }
      .padding()
    }
    .overlay(alignment: .topTrailing) {
      Button {
        distanceManager.save()
        dismiss()
      } label: {
        Text("Done")
      }
      .disabled(!distanceManager.hasResults)
      .padding()
    }
    .overlay(alignment: .bottom) {
      Button(role: .destructive) {
        showResetAlert = true
      } label: {
        Text("Reset")
      }
      .padding()
      .disabled(!distanceManager.hasResults)
    }
    .alert("Are you sure to reset hand alignment data?", isPresented: $showResetAlert) {
      Button(role: .destructive) {
        distanceManager.reset()
      } label: {
        Text("Reset")
      }
    }
    .alert("Please go to System Settings and allow hand tracking for RockPaperScissors", isPresented: $showAuthorizationAlert) {
      Button("Open Settings") {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url)
        }
      }
      Button("Dismiss") {
        dismiss()
      }
    }
    .onChange(of: viewModel.leftResult, initial: true) { _, newValue in
      if let newValue {
        distanceManager.updateLeftAlignmentResult(newValue)
      }
    }
    .onChange(of: viewModel.rightResult, initial: true) { _, newValue in
      if let newValue {
        distanceManager.updateRightAlignmentResult(newValue)
      }
    }
    .onChange(of: viewModel.isAuthorized, initial: true) { _, newValue in
      if !newValue {
        showAuthorizationAlert = true
      }
    }
    .onAppear {
      Task {
        await openImmersiveSpace(id: "handalignment")
        isImmersiveSpacePresented = true
      }
    }
    .onDisappear {
      Task {
        if isImmersiveSpacePresented {
          await dismissImmersiveSpace()
          isImmersiveSpacePresented = false
        }
      }
    }
  }

}
