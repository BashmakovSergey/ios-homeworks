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
    
    func presentMedia(navigationController: UINavigationController?){
        let mediaViewController = MediaViewController(coordinator: self)
        navigationController?.pushViewController(mediaViewController, animated: true)
    }
    
    func presentVoiceRecorder(navigationController: UINavigationController?){
        let voiceRecorderViewController = VoiceRecorderViewController()
        navigationController?.pushViewController(voiceRecorderViewController, animated: true)
    }
    
    func presentMap(navigationController: UINavigationController?){
        let mapViewController = MapViewController(coordinator: self)
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
}
