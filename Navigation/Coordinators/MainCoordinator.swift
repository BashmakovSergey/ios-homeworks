import UIKit

final class MainCoordinator: MainCoordinatorProtocol {
    
    func startApplication() -> UIViewController {
        return MainTabBarController()
    }
    
}
