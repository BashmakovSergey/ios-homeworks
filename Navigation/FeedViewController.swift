import UIKit

class FeedViewController: UIViewController {

    var post = Post(title: "Мой пост")
    
    @objc private lazy var actionButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = .blue
            button.layer.cornerRadius = 12
            button.setTitle("Перейти на пост", for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
    }()
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemPink
            view.addSubview(self.actionButton)
            setupContraints()
            actionButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    private func setupContraints() {
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,constant: 20.0),
            actionButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,constant: -20.0),
            actionButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 44.0)
        ])
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
            let postViewController = PostViewController()
            navigationController?.pushViewController(postViewController, animated: true)
        }

}


