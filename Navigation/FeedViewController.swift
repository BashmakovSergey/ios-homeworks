import UIKit
import StorageService

class FeedViewController: UIViewController {

    var post = PostFeed(title: "Мой пост")
    
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
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.clipsToBounds = true
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
            
        addPostButton(title: "Первый пост", color: .systemPurple, to: stackView, selector: #selector(buttonPressed))
        addPostButton(title: "Второй пост", color: .systemIndigo, to: stackView, selector: #selector(buttonPressed))
        
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        view.addSubview(stackView)
        setupContraints()
    }
    
    private func setupContraints() {
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 200),
            stackView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, constant: -32)
        ])
    }
    
    private func addPostButton(title: String, color: UIColor, to view: UIStackView, selector: Selector) {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12.0
        button.addTarget(self, action: selector, for: .touchUpInside)
        view.addArrangedSubview(button)
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        let postViewController = PostViewController(post: post)
            navigationController?.pushViewController(postViewController, animated: true)
        }

}
