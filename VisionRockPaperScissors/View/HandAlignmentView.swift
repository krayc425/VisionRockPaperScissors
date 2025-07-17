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
      Button(role: .destructive) {
        showResetAlert = true
      } label: {
        Text("Reset")
      }
      .padding()
    }
    .overlay(alignment: .topTrailing) {
      Button {
        distanceManager.save()
        Task {
          await dismissImmersiveSpace()
          dismiss()
        }
      } label: {
        Text("Done")
      }
      .disabled(!distanceManager.hasResults)
      .padding()
    }
    .alert("Are you sure to reset hand alignment data?", isPresented: $showResetAlert) {
      Button(role: .destructive) {
        distanceManager.reset()
      } label: {
        Text("Reset")
      }
    }
    .onChange(of: viewModel.leftResult) { _, newValue in
      if let newValue {
        distanceManager.updateLeftAlignmentResult(newValue)
      }
    }
    .onChange(of: viewModel.rightResult) { _, newValue in
      if let newValue {
        distanceManager.updateRightAlignmentResult(newValue)
      }
    }
    .onAppear {
      Task {
        await openImmersiveSpace(id: "hangalignment")
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
