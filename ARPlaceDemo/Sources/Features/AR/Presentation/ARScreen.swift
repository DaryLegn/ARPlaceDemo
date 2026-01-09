import SwiftUI

struct ARScreen: View {
    @StateObject var viewModel: ARViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            ARSceneView(viewModel: viewModel)
                .ignoresSafeArea()

            HStack(spacing: 12) {
                Button("Grid") {
                    viewModel.showGridInfo()
                }
                .buttonStyle(.borderedProminent)

                Text(statusText)
                    .font(.footnote)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
            }
            .padding(.bottom, 20)
        }
        .onAppear { viewModel.onAppear() }
        .navigationTitle("AR Demo")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var statusText: String {
        switch viewModel.state {
        case .emptyScene: return "Point the camera at a surface"
        case .preparedForPlacement: return "Tap to place"
        case .placed: return "Placed"
        }
    }
}
