import ARKit
import SceneKit
import UIKit

final class ARSceneCoordinator: NSObject {
    private weak var arView: VirtualObjectARView?
    private let viewModel: ARViewModel

    let sessionService: ARSessionService = DefaultARSessionService()

    let focusSquare = FocusSquare()

    init(viewModel: ARViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    func attach(to view: VirtualObjectARView) {
        arView = view
        view.delegate = self
        view.session.delegate = self
    }

    func updatePerFrame() {
        updateFocusSquare()
    }

    private func updateFocusSquare() {
        guard let arView else { return }

        guard let query = arView.getRaycastQuery(for: .any) else {
            focusSquare.opacity = 0
            return
        }

        let results = arView.castRay(for: query)
        if let result = results.first {
            focusSquare.opacity = 0.9
            focusSquare.simdWorldPosition = result.worldTransform.translation
            viewModel.state = .preparedForPlacement
        } else {
            focusSquare.opacity = 0.2
            viewModel.state = .emptyScene
        }
    }

    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let arView else { return }
        let point = recognizer.location(in: arView)

        guard let query = arView.raycastQuery(from: point, allowing: .estimatedPlane, alignment: .any) else { return }
        let results = arView.session.raycast(query)

        if let first = results.first {
            viewModel.placePlaceholderObject(at: first.worldTransform)
        }
    }
}

extension ARSceneCoordinator: ARViewInput {
    func addVirtualObject(_ object: VirtualObject) {
        arView?.scene.rootNode.addChildNode(object)
        arView?.addOrUpdateAnchor(for: object)
    }

    func setFocusSquareHidden(_ hidden: Bool) {
        focusSquare.isHidden = hidden
    }
}

extension ARSceneCoordinator: ARSCNViewDelegate, ARSessionDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, let view = renderer as? ARSCNView else { return }
        let plane = Plane(anchor: planeAnchor, in: view)
        node.addChildNode(plane)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) { }
}
