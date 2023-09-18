import UIKit

final class ProfileHeaderView: UITableViewHeaderFooterView {
    
    private var statusText: String = "Установить статус"
    
    var returnAvatarButton = UIButton()
    var avatarBackground = UIView()
    private var avatarOriginPoint = CGPoint()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "avatar"))
        imageView.backgroundColor = .green
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 60.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Имя профиля"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "В ожидании чего-то"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var statusTextField: UITextField = {
        var textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.textColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Установить новый статус"
        textField.textAlignment = .center
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    private let setStatusButton: UIButton = {
        let button = UIButton()
        button.setTitle("Установить статус", for: .normal)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4.0
        button.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4.0
        button.layer.shadowColor = UIColor.black.cgColor
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstrain()
        addTarget()
        statusTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addTarget() {
        setStatusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        statusTextField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
    }
    
    @objc private func buttonPressed() {
        if let buttonText = setStatusButton.currentTitle {
            print(buttonText)
        }
        statusLabel.text = statusText
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text ?? ""
    }
    
    private func setupUI() {
        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(setStatusButton)
        addSubview(statusLabel)
        addSubview(statusTextField)
        addSubviews(avatarBackground, avatarImageView, returnAvatarButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnAvatar))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGesture)
        
        // cancel an animation mode
        returnAvatarButton.translatesAutoresizingMaskIntoConstraints = false
        returnAvatarButton.alpha = 0
        returnAvatarButton.backgroundColor = .clear
        returnAvatarButton.contentMode = .scaleToFill
        returnAvatarButton.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22))?.withTintColor(.black, renderingMode: .automatic), for: .normal)
        returnAvatarButton.tintColor = .black
        returnAvatarButton.addTarget(self, action: #selector(returnAvatarToOrigin), for: .touchUpInside)
        
        // translucent background for the modal animation mode
        avatarBackground = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        avatarBackground.backgroundColor = .darkGray
        avatarBackground.isHidden = true
        avatarBackground.alpha = 0
    }
    
    private func setupConstrain(){
        let safeAreaGuide = self.safeAreaLayoutGuide
        
        fullNameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 50).isActive = true
        fullNameLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 27).isActive = true
        fullNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 16),
            avatarImageView.leftAnchor.constraint(equalTo: safeAreaGuide.leftAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 120),
            avatarImageView.heightAnchor.constraint(equalToConstant: 120),

            statusLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 50),
            statusLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            statusLabel.bottomAnchor.constraint(equalTo: statusTextField.topAnchor, constant: -14),

            setStatusButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 56),
            setStatusButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            setStatusButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            setStatusButton.heightAnchor.constraint(equalToConstant: 50),
            
            statusTextField.heightAnchor.constraint(equalToConstant: 40),
            statusTextField.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 50),
            statusTextField.rightAnchor.constraint(equalTo: safeAreaGuide.rightAnchor, constant: -16),
            statusTextField.bottomAnchor.constraint(equalTo: setStatusButton.topAnchor, constant: -34),
            
            returnAvatarButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            returnAvatarButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    @objc private func didTapOnAvatar() {
        // create an animation
        avatarImageView.isUserInteractionEnabled = false
        
        ProfileViewController.postTableView.isScrollEnabled = false
        ProfileViewController.postTableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isUserInteractionEnabled = false
        
        avatarOriginPoint = avatarImageView.center
        let scale = UIScreen.main.bounds.width / avatarImageView.bounds.width
        
        UIView.animate(withDuration: 0.5) {
            self.avatarImageView.center = CGPoint(x: UIScreen.main.bounds.midX,
                                                  y: UIScreen.main.bounds.midY - self.avatarOriginPoint.y)
            self.avatarImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.avatarImageView.layer.cornerRadius = 0
            self.avatarBackground.isHidden = false
            self.avatarBackground.alpha = 0.7
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.returnAvatarButton.alpha = 1
            }
        }
    }
    
    @objc private func returnAvatarToOrigin() {
        UIImageView.animate(withDuration: 0.5) {
            UIImageView.animate(withDuration: 0.5) {
                self.returnAvatarButton.alpha = 0
                self.avatarImageView.center = self.avatarOriginPoint
                self.avatarImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2
                self.avatarBackground.alpha = 0
            }
        } completion: { _ in
            ProfileViewController.postTableView.isScrollEnabled = true
            ProfileViewController.postTableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isUserInteractionEnabled = true
            self.avatarImageView.isUserInteractionEnabled = true
        }
    }
   
}

extension ProfileHeaderView: UITextFieldDelegate {
    
    // tap 'done' on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
