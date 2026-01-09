protocol ShowGridUseCase {
    func execute()
}

final class DefaultShowGridUseCase: ShowGridUseCase {
    private let router: ARRouter
    init(router: ARRouter) { self.router = router }
    func execute() { router.didRequestShowGridInfo() }
}
