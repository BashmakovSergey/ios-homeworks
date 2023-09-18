import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let loginFactory = MyLogInFactory()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        
        func createFeedViewController() -> UINavigationController {
            let feedViewController = FeedViewController()
            feedViewController.title = "Лента"
            feedViewController.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(systemName: "doc.richtext"), tag: 0)
            return UINavigationController(rootViewController: feedViewController)
        }
        
        func createProfileViewController() -> UINavigationController {
            let profileViewController = LogInViewController()
            
//            для использования синглтона напрямую
//            profileViewController.loginDelegate = LoginInspector()
            
//            использование фабрики
            profileViewController.loginDelegate = loginFactory.makeLoginInspector()
            
            profileViewController.title = "Профиль"
            profileViewController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.circle"), tag: 1)
            return UINavigationController(rootViewController: profileViewController)
        }
        
        func createTabBarController() -> UITabBarController {
            let tabBarController = UITabBarController()
            UITabBar.appearance().backgroundColor = .systemBackground
            tabBarController.viewControllers = [createFeedViewController(), createProfileViewController()]
            tabBarController.selectedIndex = 0
            return tabBarController
        }
        
        window.rootViewController = createTabBarController()
        window.makeKeyAndVisible()
        self.window = window
    }
}
