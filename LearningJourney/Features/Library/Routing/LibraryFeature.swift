import SwiftUI

struct LibraryFeature<Coordinator> where Coordinator: LibraryCoordinating {
    
    // MARK: - Dependencies
    
    private let coordinator: Coordinator?
    private let sceneFactory: LibraryScenesFactoryProtocol
    
    // MARK: - Initialization
    
    public init() {
        let coordinator = LibraryCoordinator()
        let factory = LibraryScenesFactory(
            libraryAssembler: LibraryAssembler(coordinator: coordinator),
            objectivesListAssembler: ObjectivesListAssembler()
        )
        coordinator.scenesFactory = factory
        self.init(
            coordinator: coordinator as? Coordinator,
            sceneFactory: factory
        )
    }
    
    init(
        coordinator: Coordinator?,
        sceneFactory: LibraryScenesFactoryProtocol ) {
        self.coordinator = coordinator
        self.sceneFactory = sceneFactory
    }
    
    func resolve() -> AnyView {
        guard let coordinator = coordinator else {
            fatalError("Coordinator not configured for Library feature")
        }
        return coordinator.start()
    }
}
