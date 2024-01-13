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
        mainTabBarController.tabBar.backgroundColor = ColorPalette.lightGrayBackgroundColor
        addControllersToTabBar()
    }
    
    private func addControllersToTabBar(){
        mainTabBarController.viewControllers = [createFeed(), createProfile(), createFavorite()]
    }
    
    private func createFeed() -> UINavigationController {
        let feedCoordinator = FeedCoordinator()
        let feedNavigationController = UINavigationController(rootViewController: FeedViewController(coordinator: feedCoordinator))
        feedNavigationController.title = "Feed".localized
        feedNavigationController.tabBarItem = UITabBarItem(title: "Feed".localized, image: UIImage(systemName:"doc.richtext"), tag: 0)
        return feedNavigationController
    }

    private func createProfile() -> UINavigationController {
        let profileCoordinator = ProfileCoordinator()
        let loginFactory = MainFactory()
        let loginViewController = LogInViewController(coordinator: profileCoordinator)
        loginViewController.loginDelegate = loginFactory.makeLoginInspector()
        let profileNavigationController = UINavigationController(rootViewController: loginViewController)
        profileNavigationController.title = "Profile".localized
        profileNavigationController.tabBarItem = UITabBarItem(title: "Profile".localized, image: UIImage(systemName: "person.circle"), tag: 1)
        return profileNavigationController
    }
    
    private func createFavorite() -> UINavigationController {
        let favoriteViewController = FavoriteViewController()
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteViewController)
        favoriteNavigationController.title = "Favorites".localized
        favoriteNavigationController.tabBarItem = UITabBarItem(title: "Favorites".localized, image: UIImage(systemName: "link.circle"), tag: 2)
        return favoriteNavigationController
    }
    
}
