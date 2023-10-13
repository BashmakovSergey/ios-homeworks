import UIKit
import StorageService

final class FeedCoordinator: Coordinator {
    
    func presentPost(navigationController: UINavigationController? , title: String) {
        let postViewController = PostViewController(postTitle: title, coordinator: self)
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    func presentInfo(navigationController: UINavigationController?){
        let infoViewController = InfoViewController()
        infoViewController.modalTransitionStyle = .flipHorizontal
        infoViewController.modalPresentationStyle = .pageSheet
        navigationController?.present(infoViewController, animated: true)
    }
    
}
