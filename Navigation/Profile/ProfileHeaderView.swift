import UIKit

class ProfileHeaderView: UIView {
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "avatar.jpeg"))
        imageView.backgroundColor = .green
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 60.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Имя профиля"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "В ожидании чего-то"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileStatusButton: UIButton = {
        let button = UIButton()
        button.setTitle("Показать статус", for: .normal)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4.0
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addTarget() {
        profileStatusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc private func buttonPressed() {
        if let buttonText = profileStatusButton.currentTitle {
            print(buttonText)
        }
    }
    
    private func setupUI() {
        addSubview(avatarImageView)
        addSubview(profileNameLabel)
        addSubview(profileStatusButton)
        addSubview(profileStatusLabel)
        
        let safeAreaGuide = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 16),
            avatarImageView.leftAnchor.constraint(equalTo: safeAreaGuide.leftAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarImageView.heightAnchor.constraint(equalToConstant: 120),
        ])
        
        profileNameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 50).isActive = true
        profileNameLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 27).isActive = true
        profileNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
       // profileNameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            profileStatusLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 50),
            profileStatusLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            profileStatusLabel.bottomAnchor.constraint(equalTo: profileStatusButton.topAnchor, constant: -34)
        ])
        
        NSLayoutConstraint.activate([
            profileStatusButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            profileStatusButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            profileStatusButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            profileStatusButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        profileStatusButton.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        profileStatusButton.layer.shadowOpacity = 0.7
        profileStatusButton.layer.shadowRadius = 4.0
        profileStatusButton.layer.shadowColor = UIColor.black.cgColor
    }
    
}
