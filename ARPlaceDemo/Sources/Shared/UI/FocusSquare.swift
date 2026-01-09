import ARKit
import Foundation
import SceneKit
import UIKit

final class FocusSquare: SCNNode {
    private var primaryColor = AppColors.focusPrimary
    private var lightColor = AppColors.planeTint

    var isClosed: Bool = true {
        didSet {
            geometry?.firstMaterial?.diffuse.contents = isClosed ? material(primaryColor, radius: 0.01) : material(lightColor, radius: 0.035)
        }
    }

    var focusEulerAngles: Float = -90.0 {
        didSet { eulerAngles.x = GLKMathDegreesToRadians(focusEulerAngles) }
    }

    override init() {
        let plane = SCNPlane(width: AppConstants.UI.focusSquareSize, height: AppConstants.UI.focusSquareSize)
        plane.cornerRadius = 0
        super.init()

        opacity = 0
        geometry = plane
        eulerAngles.x = GLKMathDegreesToRadians(focusEulerAngles)
        openAnimation()
        createProbeLight()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func material(_ color: UIColor, radius: CGFloat) -> SCNMaterial? {
        let plane = SCNPlane(width: AppConstants.UI.focusSquareSize, height: AppConstants.UI.focusSquareSize)
        plane.cornerRadius = radius
        geometry = plane
        guard let material = geometry?.firstMaterial else { return nil }

        guard let path = Bundle.main.path(forResource: "wireframe_shader", ofType: "metal", inDirectory: "art.scnassets") else { return nil }
        do {
            let shader = try String(contentsOfFile: path, encoding: .utf8)
            material.shaderModifiers = [.surface: shader]
        } catch {
            assertionFailure("Can't load wireframe shader: \(error)")
        }
        material.diffuse.contents = color
        return material
    }

    private func pulseAction() -> SCNAction {
        let pulseOutAction = SCNAction.fadeOpacity(to: 0.4, duration: 0.5)
        let pulseInAction = SCNAction.fadeOpacity(to: 1.0, duration: 0.5)
        pulseOutAction.timingMode = .easeInEaseOut
        pulseInAction.timingMode = .easeInEaseOut
        return SCNAction.repeatForever(SCNAction.sequence([pulseOutAction, pulseInAction]))
    }

    private func openAnimation() {
        SCNTransaction.begin()
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeOut)
        SCNTransaction.animationDuration = 0.7
        opacity = 0.6
        SCNTransaction.commit()

        // If you want pulsing:
        // runAction(pulseAction(), forKey: "pulse")
    }
}
