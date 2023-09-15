import UIKit

final class InfoViewController: UIViewController {

    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Посмотреть", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Инфо"
        view.backgroundColor = .systemMint
        view.addSubview(actionButton)
        setupContraints()
        actionButton.addTarget(self, action: #selector(alertViewController(_:)), for: .touchUpInside)
        
    }
    
    private func setupContraints(){
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,constant: 20.0),
            actionButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,constant: -20.0),
            actionButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 44.0)
        ])
    }
    
    @objc func alertViewController(_ sender: UIAlertController) {
        let alertController = UIAlertController(title: "Информация первая", message: "Информация вторая, сообщение", preferredStyle: .alert)

        let actionFirst = UIAlertAction(title: "Левый", style: .default, handler: nil)
        let actionSecond = UIAlertAction(title: "Правый", style: .default, handler: nil)
        
        alertController.addAction(actionFirst)
        print("Нажал на кнопку \(actionFirst)")
        alertController.addAction(actionSecond)
        print("Нажал на кнопку \(actionSecond)")
        self.present(alertController, animated: true)
        }
}
