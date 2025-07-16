//
//  Extensions.swift
//  VisionRockPaperScissors
//
//  Created by Kuixi Song on 7/15/25.
//

import RealityKit
import simd

extension simd_float4x4 {
  var position: simd_float3 {
    simd_make_float3(columns.3)
  }
}
