import UIKit

protocol FactoryProtocol {
    func makeLoginInspector() -> LoginInspector
}

class MainFactory: FactoryProtocol {
    
    private let inspector = LoginInspector()
    private let flow: Flow
    var navigationController = UINavigationController()
    
    enum Flow {
        case feed
        case profile
        case defaulf
    }
    
    init(flow: Flow) {
        self.flow = flow
        startModule()
    }
    
    convenience init() {
        self.init(flow: .defaulf)
    }
    
    func makeLoginInspector() -> LoginInspector {
        return inspector
    }
    
    private func startModule() {
        switch flow {
        case .feed:
            let feedCoordinator = FeedCoordinator()
            navigationController = feedCoordinator.createViewController()
        case .profile:
            let profileCoordinator = ProfileCoordinator()
            navigationController = profileCoordinator.createViewController()
        case .defaulf:
            return
        }
    }
    
}
