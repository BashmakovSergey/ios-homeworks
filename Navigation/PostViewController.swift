import UIKit

class PostViewController: UIViewController {
    
    var titlePost: String = "Привет"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .lightGray
        navigationItem.title = titlePost
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
