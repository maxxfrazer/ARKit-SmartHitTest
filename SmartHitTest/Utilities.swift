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
	var translation: float3 {
		get {
			let translation = columns.3
			return float3(translation.x, translation.y, translation.z)
		}
		set(newValue) {
			columns.3 = float4(newValue.x, newValue.y, newValue.z, columns.3.w)
		}
	}
}
