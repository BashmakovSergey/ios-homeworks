import UIKit

class ProfileViewController: UIViewController {
    
    private lazy var profileHeaderView = ProfileHeaderView()
    
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Кнопка из ДЗ 2.2", for: .normal)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4.0
        button.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4.0
        button.layer.shadowColor = UIColor.black.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.addSubview(self.profileHeaderView)
        view.addSubview(profileButton)
        setupConstraint()
    }
    
   // override func viewWillLayoutSubviews() {
   //         super.viewWillLayoutSubviews()
   //         profileHeaderView.frame = view.frame
   // }
     
    private func setupConstraint() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        profileHeaderView.translatesAutoresizingMaskIntoConstraints =
            false
        
        NSLayoutConstraint.activate([
            profileHeaderView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: 0),
            profileHeaderView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 0),
            profileHeaderView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            profileHeaderView.heightAnchor.constraint(equalToConstant: 220),
            
            
            profileButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 0),
            profileButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: 0),
            profileButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            profileButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
}
