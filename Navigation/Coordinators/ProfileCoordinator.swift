import UIKit

final class ProfileCoordinator: Coordinator {
    
    func createViewController() -> UINavigationController {
        let loginFactory = MainFactory()
        let profileViewController = LogInViewController()
        profileViewController.loginDelegate = loginFactory.makeLoginInspector()
        profileViewController.title = "Профиль"
        profileViewController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.circle"), tag: 1)
        return UINavigationController(rootViewController: profileViewController)
    }
    
    
    
    
    func openProfile(navigationController: UINavigationController?, user: User){
        let profileViewController = ProfileViewController(user: user)
        navigationController?.pushViewController(profileViewController, animated: true)

    }
    
   
}
    

