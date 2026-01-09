import ARKit
import SceneKit

/// Business-free replacement for `ToolVirtualModel`.
final class VirtualObject: SCNNode {
    // AR tracking
    var anchor: ARAnchor?
    var raycastQuery: ARRaycastQuery?
    var raycast: ARTrackedRaycast?
    var mostRecentInitialPlacementResult: ARRaycastResult?
    var shouldUpdateAnchor = false

    // Placement rules
    var surfaceOrientation: SurfaceOrientation = .horizontal
    var allowedPlace = false

    var originalRotation: SCNVector3?
    private var selectNode: SCNNode?

    /// Rotate the first child node.
    var objectRotation: Float {
        get { childNodes.first?.eulerAngles.y ?? 0 }
        set { childNodes.first?.eulerAngles.y = newValue }
    }

    var allowedAlignment: ARRaycastQuery.TargetAlignment { surfaceOrientation.alignment }

    func stopTrackedRaycast() {
        raycast?.stopTracking()
        raycast = nil
    }

    func createSelectNode() {
        var radius = max(boundingBox.max.z, boundingBox.max.x) + 0.05
        let torus = SCNTorus(ringRadius: CGFloat(radius), pipeRadius: 0.005)
        torus.pipeSegmentCount = 2

        let material = SCNMaterial()
        material.diffuse.contents = AppColors.planeTint
        material.lightingModel = .constant
        torus.materials = [material]

        let node = SCNNode(geometry: torus)
        node.position = position
        addChildNode(node)

        selectNode = node
        selectNode?.isHidden = true
    }

    func showSelectRing() { selectNode?.isHidden = false }
    func hideSelectRing() { selectNode?.isHidden = true }
}

extension VirtualObject {
    static func existingObjectContainingNode(_ node: SCNNode) -> VirtualObject? {
        if let root = node as? VirtualObject { return root }
        guard let parent = node.parent else { return nil }
        return existingObjectContainingNode(parent)
    }
}
