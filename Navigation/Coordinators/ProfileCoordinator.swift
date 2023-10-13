import UIKit

final class ProfileCoordinator: Coordinator {
    
    func presentPhoto(navigationController: UINavigationController?){
        let photoViewController = PhotosViewController()
        photoViewController.modalTransitionStyle = .flipHorizontal
        photoViewController.modalPresentationStyle = .pageSheet
        navigationController?.pushViewController(photoViewController, animated: true)
    }
    
    func presentProfile(navigationController: UINavigationController?, user: User?){
        let profileViewController = ProfileViewController(userService: user, coordinator: self)
        navigationController?.pushViewController(profileViewController, animated: true)
    }
   
}
