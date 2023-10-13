import UIKit

final class MainCoordinator: Coordinator {
    
    private var mainTabBarController: UITabBarController
    
    init() {
        mainTabBarController = UITabBarController()
    }
    
    func start() -> UIViewController {
        setTabBarController()
        return mainTabBarController
    }
    
    private func setTabBarController(){
        mainTabBarController.tabBar.backgroundColor = .systemBackground
        addControllersToTabBar()
    }
    
    private func addControllersToTabBar(){
        mainTabBarController.viewControllers = [createFeed(), createProfile()]
    }
    
    private func createFeed() -> UINavigationController {
        let feedCoordinator = FeedCoordinator()
        let feedNavigationController = UINavigationController(rootViewController: FeedViewController(coordinator: feedCoordinator))
        feedNavigationController.title = "Лента"
        feedNavigationController.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(systemName:"doc.richtext"), tag: 0)
        return feedNavigationController
    }

    private func createProfile() -> UINavigationController {
        let profileCoordinator = ProfileCoordinator()
        let loginFactory = MainFactory()
        let loginViewController = LogInViewController(coordinator: profileCoordinator)
        loginViewController.loginDelegate = loginFactory.makeLoginInspector()
        let profileNavigationController = UINavigationController(rootViewController: loginViewController)
        profileNavigationController.title = "Профиль"
        profileNavigationController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.circle"), tag: 1)
        return profileNavigationController
    }
    
}
