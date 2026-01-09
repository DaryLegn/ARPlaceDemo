import ARKit

extension SCNNode {
    func createProbeLight() {
        light = SCNLight()
        scale = SCNVector3(1, 1, 1)
        light?.intensity = 1000
        castsShadow = true
        position = SCNVector3Zero
        light?.type = .probe
    }
}
