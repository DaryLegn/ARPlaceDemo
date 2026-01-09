import Combine
import SceneKit

protocol ARRouter: AnyObject {
    func didRequestShowGridInfo()
}

protocol ARViewInput: AnyObject {
    func addVirtualObject(_ object: VirtualObject)
    func setFocusSquareHidden(_ hidden: Bool)
}

enum ARSelectState {
    case emptyScene
    case preparedForPlacement
    case placed
}

final class ARViewModel: ObservableObject {
    private let workerQueue = DispatchQueue(label: "com.ardemo.thumbnail")

    weak var view: ARViewInput?
    private weak var router: ARRouter?

    private let showGridUseCase: ShowGridUseCase

    @Published var state: ARSelectState = .emptyScene

    let objectsPublisher = CurrentValueSubject<[VirtualObject], Never>([])

    init(router: ARRouter?) {
        self.router = router
        self.showGridUseCase = DefaultShowGridUseCase(router: router ?? DummyRouter())
    }

    func onAppear() {
        // Reserved for future
    }

    func showGridInfo() {
        showGridUseCase.execute()
    }

    func placePlaceholderObject(at transform: simd_float4x4) {
        let object = VirtualObject()

        let box = SCNBox(width: 0.08, height: 0.08, length: 0.08, chamferRadius: 0.01)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemOrange
        box.materials = [material]
        object.geometry = box

        object.simdWorldTransform = transform
        object.createSelectNode()

        view?.addVirtualObject(object)
        objectsPublisher.value.append(object)
        state = .placed
    }
}

private final class DummyRouter: ARRouter {
    func didRequestShowGridInfo() {}
}
