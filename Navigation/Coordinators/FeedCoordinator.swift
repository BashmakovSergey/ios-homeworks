import UIKit

final class FeedCoordinator: FlowCoordinatorProtocol {
    
    func createViewController() -> UINavigationController {
        let viewModel = FeedViewModel()
        let feedViewController = FeedViewController(viewModel: viewModel)
        feedViewController.title = "Лента"
        feedViewController.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(systemName: "doc.richtext"), tag: 0)
        return UINavigationController(rootViewController: feedViewController)
    }
    
}
