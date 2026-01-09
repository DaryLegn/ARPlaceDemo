import ARKit

enum SurfaceOrientation: String, CaseIterable, Codable {
    case horizontal
    case vertical

    var alignment: ARRaycastQuery.TargetAlignment {
        switch self {
        case .horizontal: return .horizontal
        case .vertical: return .vertical
        }
    }
}
