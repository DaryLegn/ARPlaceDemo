import SwiftUI
import ARKit
import SceneKit

struct ARSceneView: UIViewRepresentable {
    typealias UIViewType = VirtualObjectARView

    @ObservedObject var viewModel: ARViewModel

    func makeUIView(context: Context) -> VirtualObjectARView {
        let arView = VirtualObjectARView(frame: .zero)

        arView.automaticallyUpdatesLighting = true
        arView.autoenablesDefaultLighting = false

        let coordinator = context.coordinator
        coordinator.attach(to: arView)

        viewModel.view = coordinator

        arView.scene = SCNScene()
        arView.scene.rootNode.addChildNode(coordinator.focusSquare)

        // Gestures
        let tap = UITapGestureRecognizer(target: coordinator, action: #selector(ARSceneCoordinator.handleTap(_:)))
        arView.addGestureRecognizer(tap)

        // Start session
        let config = coordinator.sessionService.makeDefaultConfiguration()
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])

        return arView
    }

    func updateUIView(_ uiView: VirtualObjectARView, context: Context) {
        context.coordinator.updatePerFrame()
    }

    func makeCoordinator() -> ARSceneCoordinator {
        ARSceneCoordinator(viewModel: viewModel)
    }
}
