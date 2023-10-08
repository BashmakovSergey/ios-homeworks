import UIKit

final class MainTabBarController: UITabBarController {
    
    private let feedViewController = MainFactory(flow: .feed)
    private let profileViewController = MainFactory(flow: .profile)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setControllers()
    }
    
    private func setControllers() {
        viewControllers = [feedViewController.navigationController, profileViewController.navigationController]
        selectedIndex = 0
    }
}
