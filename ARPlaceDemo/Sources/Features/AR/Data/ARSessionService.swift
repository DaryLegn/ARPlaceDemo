import ARKit

protocol ARSessionService {
    func makeDefaultConfiguration() -> ARWorldTrackingConfiguration
}

final class DefaultARSessionService: ARSessionService {
    func makeDefaultConfiguration() -> ARWorldTrackingConfiguration {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        return config
    }
}
