import ARKit

final class VirtualObjectARView: ARSCNView {
    func virtualObject(at position: CGPoint) -> VirtualObject? {
        let hitTestOptions: [SCNHitTestOption: Any] = [.boundingBoxOnly: true]
        let hitTestResults = hitTest(position, options: hitTestOptions)

        return hitTestResults.lazy.compactMap { result in
            VirtualObject.existingObjectContainingNode(result.node)
        }.first
    }

    func addOrUpdateAnchor(for object: VirtualObject) {
        if let anchor = object.anchor {
            session.remove(anchor: anchor)
        }
        let newAnchor = ARAnchor(transform: object.simdWorldTransform)
        object.anchor = newAnchor
        session.add(anchor: newAnchor)
    }
}

extension ARSCNView {
    func castRay(for query: ARRaycastQuery) -> [ARRaycastResult] {
        session.raycast(query)
    }

    func getRaycastQuery(for alignment: ARRaycastQuery.TargetAlignment = .any) -> ARRaycastQuery? {
        raycastQuery(from: screenCenter, allowing: .estimatedPlane, alignment: alignment)
    }

    var screenCenter: CGPoint {
        CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
