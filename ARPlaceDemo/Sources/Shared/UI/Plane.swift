import ARKit
import Foundation
import SceneKit

final class Plane: SCNNode {
    let planeNode: SCNNode

    init(anchor: ARPlaneAnchor, in _: ARSCNView) {
        let extentPlane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        planeNode = SCNNode(geometry: extentPlane)
        planeNode.simdPosition = anchor.center
        planeNode.eulerAngles.x = -.pi / 2
        super.init()

        addChildNode(planeNode)
        setupExtentVisualStyle()
        createProbeLight()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupExtentVisualStyle() {
        planeNode.opacity = 0.8

        guard let material = planeNode.geometry?.firstMaterial else { return }
        material.diffuse.contents = AppColors.planeTint
        material.isDoubleSided = true

        guard let path = Bundle.main.path(forResource: "wireframe_shader", ofType: "metal", inDirectory: "art.scnassets") else { return }
        do {
            let shader = try String(contentsOfFile: path, encoding: .utf8)
            material.shaderModifiers = [.surface: shader]
        } catch {
            assertionFailure("Can't load wireframe shader: \(error)")
        }
    }
}
