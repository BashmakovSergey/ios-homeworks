import UIKit
import StorageService

final class PostViewController: UIViewController {
    
    var post: PostFeed
    
    init(post: PostFeed) {
        self.post = post
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
        navigationItem.title = post.title
        let barButtonItem = UIBarButtonItem(title: "Инфо", style: .plain, target: self, action: #selector(infoViewController))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func infoViewController(_ sender: UIButton) {
        let infoViewController = InfoViewController()
        let navigationUIContoller = UINavigationController(rootViewController: infoViewController)
        navigationUIContoller.modalPresentationStyle = .pageSheet
        present(navigationUIContoller, animated: true)
    }
    
}
