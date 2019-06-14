//
//  Utilities.swift
//  FocusSquare
//
//  Created by Max Cobb on 11/28/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import simd

// MARK: - float4x4 extensions
internal extension float4x4 {
  /// Treats the 4x4 matrix as a transform matrix, where the translation is
  /// stored in the first 3 rows of the 3rd column
  var translation: SIMD3<Float> {
    get {
      let translation = columns.3
      return SIMD3<Float>(translation.x, translation.y, translation.z)
    }
    set(newValue) {
      columns.3 = SIMD4<Float>(newValue.x, newValue.y, newValue.z, columns.3.w)
    }
  }
}
