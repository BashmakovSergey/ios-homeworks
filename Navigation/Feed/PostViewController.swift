import UIKit
import StorageService

final class PostViewController: UIViewController {

    var post: PostFeed?
    
    var coordinator: FeedCoordinator
    
    init(postTitle: String, coordinator: FeedCoordinator) {
        post?.title = postTitle
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        self.view.backgroundColor = .darkGray
        navigationItem.title = post?.title
        
        let barButtonItem = UIBarButtonItem(title: "Info".localized, style: .plain, target: self, action: #selector(openInfo))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc private func openInfo() {
        coordinator.presentInfo(navigationController: self.navigationController)
    }
    
}
