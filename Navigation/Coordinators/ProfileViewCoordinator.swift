import UIKit

final class ProfileCoordinator: FlowCoordinatorProtocol {
    
    func createViewController() -> UINavigationController {
        let loginFactory = MainFactory()
        let profileViewController = LogInViewController()
        profileViewController.loginDelegate = loginFactory.makeLoginInspector()
        profileViewController.title = "Профиль"
        profileViewController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.circle"), tag: 1)
        return UINavigationController(rootViewController: profileViewController)
    }
    
   
}
    

