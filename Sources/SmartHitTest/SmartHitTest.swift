//
//  SmartHitTest.swift
//  SmartHitTest
//
//  Created by Max Cobb on 11/28/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import ARKit

/// It's recommended to use either ARSCNView or ARView when using this protocol
public protocol ARSmartHitTest where Self: UIView {

  /// This hitTest function deifnition is provided with both ARSCNView (SceneKit) and ARView (RealityKit)
  /// - Parameter point: A point in the view’s coordinate system.
  /// - Parameter types: The hit test search type to look for.
  func hitTest(_ point: CGPoint, types: ARHitTestResult.ResultType) -> [ARHitTestResult]
}

/// hitTest uses a series of methods to estimate the position of the anchor, like looking
/// for the best position based on what we know about other detected planes in the scene
public extension ARSmartHitTest {

  /// - Parameters:
  ///   - point: A point in the 2D coordinate system of the view.
  ///   - infinitePlane: set this to true if you're moving an object around on a plane
  ///   - objectPosition: Used for dragging objects in AR, will add Apple's bits for this later
  ///   - allowedAlignments: What plane alignments you want to use for the hit test
  /// - Returns: ARHitTestResult, check the
  func smartHitTest(
    _ point: CGPoint? = nil, infinitePlane: Bool = false, objectPosition: SIMD3<Float>? = nil,
    allowedAlignments: [ARPlaneAnchor.Alignment] = []
    ) -> ARHitTestResult? {
    var alignments = allowedAlignments
    var resultTypes: ARHitTestResult.ResultType = []
    if alignments.isEmpty {
      if #available(iOS 11.3, *) {
        alignments = [.horizontal, .vertical]
        resultTypes = [.existingPlaneUsingGeometry, .estimatedVerticalPlane, .estimatedHorizontalPlane]
      } else {
        alignments = [.horizontal]
        resultTypes = [.estimatedHorizontalPlane]
      }
    }

    let point = point ?? CGPoint(x: self.bounds.midX, y: self.bounds.midY)

    // Perform the hit test.
    let results = self.hitTest(point, types: resultTypes)

    // 1. Check for a result on an existing plane using geometry.
    if #available(iOS 13, *), let existingPlaneUsingGeometryResult = results.first(where: { $0.type == .existingPlaneUsingGeometry }),
      let planeAnchor = existingPlaneUsingGeometryResult.anchor as? ARPlaneAnchor,
      alignments.contains(planeAnchor.alignment) {

      return existingPlaneUsingGeometryResult
    }

    if infinitePlane {

      // 2. Check for a result on an existing plane, assuming its dimensions are infinite.
      //    Loop through all hits against infinite existing planes and either return the
      //    nearest one (vertical planes) or return the nearest one which is within 5 cm
      //    of the object's position.
      let infinitePlaneResults = hitTest(point, types: .existingPlane)

      for infinitePlaneResult in infinitePlaneResults {
        guard let planeAnchor = infinitePlaneResult.anchor as? ARPlaneAnchor,
          alignments.contains(planeAnchor.alignment) else {
            continue
        }
        if #available(iOS 11.3, *), planeAnchor.alignment == .vertical {
          // Return the first vertical plane hit test result.
          return infinitePlaneResult
        } else {
          // For horizontal planes we only want to return a hit test result
          // if it is close to the current object's position.
          if let objectY = objectPosition?.y {
            let planeY = infinitePlaneResult.worldTransform.columns.3.y
            if objectY > planeY - 0.05 && objectY < planeY + 0.05 {
              return infinitePlaneResult
            }
          } else {
            return infinitePlaneResult
          }
        }
      }
    }
    return self.smartHitTestFallback(allowedAlignments: alignments, results: results)
  }

  func smartHitTestFallback(
    allowedAlignments: [ARPlaneAnchor.Alignment],
    results: [ARHitTestResult]
    ) -> ARHitTestResult? {
    // 3. As a final fallback, check for a result on estimated planes.
    var vResult: ARHitTestResult? = nil
    var containsVertical = false
    if #available(iOS 11.3, *) {
      vResult = results.first(where: { $0.type == .estimatedVerticalPlane })
      containsVertical = allowedAlignments.contains(.vertical)
    }
    let hResult = results.first(where: { $0.type == .estimatedHorizontalPlane })
    switch (allowedAlignments.contains(.horizontal), containsVertical) {
    case (true, false):
      return hResult
    case (false, true):
      // Allow fallback to horizontal because we assume that objects meant for vertical placement
      // (like a picture) can always be placed on a horizontal surface, too.
      return vResult ?? hResult
    case (true, true):
      if hResult != nil && vResult != nil {
        return hResult!.distance < vResult!.distance ? hResult! : vResult!
      } else {
        return hResult ?? vResult
      }
    default:
      return nil
    }
  }
}
