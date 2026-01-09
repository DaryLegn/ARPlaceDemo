import ARKit
import Foundation
import SceneKit

extension SCNVector3: Equatable {
    static func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
        SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }

    func distance(from vector: SCNVector3) -> CGFloat {
        let dx = x - vector.x
        let dy = y - vector.y
        let dz = z - vector.z

        return CGFloat(sqrt(dx * dx + dy * dy + dz * dz))
    }

    public static func == (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z)
    }
}

extension float4x4 {
    var translation: SIMD3<Float> {
        get {
            let translation = columns.3
            return [translation.x, translation.y, translation.z]
        }
        set(newValue) {
            columns.3 = [newValue.x, newValue.y, newValue.z, columns.3.w]
        }
    }

    var orientation: simd_quatf {
        simd_quaternion(self)
    }
}
