import UIKit

final class LogInViewController: UIViewController {
    
    var loginDelegate: LoginViewControllerDelegate?
    let coordinator: ProfileCoordinator

    private lazy var vkLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var loginScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loginStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.layer.borderColor = UIColor.lightGray.cgColor
        stack.layer.borderWidth = 0.5
        stack.layer.cornerRadius = 12
        stack.distribution = .fillProportionally
        stack.backgroundColor = .systemGray6
        stack.clipsToBounds = true
        return stack
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if let pixel = UIImage(named: "blue_pixel") {
            button.setBackgroundImage(pixel.image(alpha: 1), for: .normal)
            button.setBackgroundImage(pixel.image(alpha: 0.8), for: .selected)
            button.setBackgroundImage(pixel.image(alpha: 0.6), for: .highlighted)
            button.setBackgroundImage(pixel.image(alpha: 0.4), for: .disabled)
        }

        button.setTitle("Login".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(nil, action: #selector(touchLoginButton), for: .touchUpInside)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var loginField: UITextField = {
        let login = UITextField()
        login.translatesAutoresizingMaskIntoConstraints = false
        login.placeholder = "email: test@test.com"
        login.layer.borderColor = UIColor.lightGray.cgColor
        login.layer.borderWidth = 0.25
        login.leftViewMode = .always
        login.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: login.frame.height))
        login.keyboardType = .emailAddress
        login.textColor = .black
        login.font = UIFont.systemFont(ofSize: 16)
        login.autocapitalizationType = .none
        login.returnKeyType = .done
        login.isSecureTextEntry = false
        login.addTarget(self, action: #selector(loginOrPasswordChanged), for: .editingChanged)
        return login
    }()
    
    private lazy var passwordField: UITextField = {
        let password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.leftViewMode = .always
        password.placeholder = "Password".localized + ": 123456"
        password.layer.borderColor = UIColor.lightGray.cgColor
        password.layer.borderWidth = 0.25
        password.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: password.frame.height))
        password.textColor = .black
        password.font = UIFont.systemFont(ofSize: 16)
        password.autocapitalizationType = .none
        password.returnKeyType = .done
        password.isSecureTextEntry = true
        password.addTarget(self, action: #selector(loginOrPasswordChanged), for: .editingChanged)
        return password
    }()
    
    private lazy var signUpButton: CustomButton = {
        let button = CustomButton(vkTitleText: "Register".localized, titleColor: .white, backgroundColor: .systemBlue, tapAction: signUpAction)
        return button
    }()
    
    init(coordinator: ProfileCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupUI(){
        view.addSubview(loginScrollView)
        loginScrollView.addSubview(contentView)
        contentView.addSubviews(vkLogo, loginStackView, loginButton, signUpButton)
        loginStackView.addArrangedSubview(loginField)
        loginStackView.addArrangedSubview(passwordField)
        convenientNotification()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        loginField.delegate = self
        passwordField.delegate = self
        #if DEBUG
        loginField.text = "test@test.test"
        passwordField.text = "123456"
        loginButton.isEnabled = true
        #endif
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loginScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loginScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loginScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loginScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: loginScrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: loginScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: loginScrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: loginScrollView.leadingAnchor),
            contentView.centerXAnchor.constraint(equalTo: loginScrollView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: loginScrollView.centerYAnchor),

            vkLogo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            vkLogo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            vkLogo.heightAnchor.constraint(equalToConstant: 100),
            vkLogo.widthAnchor.constraint(equalToConstant: 100),

            loginStackView.topAnchor.constraint(equalTo: vkLogo.bottomAnchor, constant: 120),
            loginStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginStackView.heightAnchor.constraint(equalToConstant: 100),

            loginButton.topAnchor.constraint(equalTo: loginStackView.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            
        ])
    }
    
    private func loginErrorNotification(caseOf error: LoginError) {
        var errorMassage: String
        switch error {
            case .userNotFound:
            errorMassage = "There is no such user".localized
            case .wrongPassword:
            errorMassage = "The password was entered incorrectly".localized
            case .userNotFoundAndWrongPassword:
            errorMassage = "The username and password were entered incorrectly".localized
            case .tooStrongPassword:
            errorMassage = "The password is too complicated and takes a long time to select".localized
            case .suchUserAlreadyExists:
            errorMassage = "Such a user has already been registered".localized
            case .authorized:
            errorMassage = "A new user has been successfully registered".localized + " \(loginField.text ?? "")"
            case .successful:
            errorMassage = "Successful login".localized
        }
        let alertController = UIAlertController(title: "Warning".localized, message: errorMassage, preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "ОК", style: .default, handler: nil)
        alertController.addAction(actionAlert)
        self.present(alertController, animated: true)
    }

    @objc private func touchLoginButton() {
        Task{
            do {
                let currentUser = try await loginDelegate?.checkCredentials(email: loginField.text ?? "", password: passwordField.text ?? "")
                coordinator.presentProfile(navigationController: navigationController, user: currentUser)
            } catch {
                loginErrorNotification(caseOf: .wrongPassword)
            }
        }
    }
  
    @objc private func signUpAction() {
        Task{
            do{
                _ = try await loginDelegate?.SignUp(email: loginField.text ?? "", password: passwordField.text ?? "")
                loginErrorNotification(caseOf: .authorized)
            } catch{
                loginErrorNotification(caseOf: .suchUserAlreadyExists)
            }
        }
    }
    
    @objc func loginOrPasswordChanged() {
        guard let resultLogin = loginDelegate?.isValidEmail(loginField.text ?? "") else {return}
        let resultPassword = passwordField.text ?? ""
        self.loginButton.isEnabled = resultLogin && resultPassword.count > 5
    }
    
    func convenientNotification() {
        let alertController = UIAlertController(title: "Warning".localized, message: "For convenience, you can set the correct Username and Password automatically".localized, preferredStyle: .alert)
        let actionAlertYes = UIAlertAction(title: "ОК", style: .default, handler: { action in
            self.loginField.text = "test@test.test"
            self.passwordField.text = "123456"
        })
        let actionAlertNo = UIAlertAction(title: "No".localized, style: .default, handler: nil)
        alertController.addAction(actionAlertYes)
        alertController.addAction(actionAlertNo)
        self.present(alertController, animated: true)
        loginButton.isEnabled = true
        }

    @objc private func keyboardShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            loginScrollView.contentOffset.y = keyboardSize.height - (loginScrollView.frame.height - loginButton.frame.minY)
            loginScrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func keyboardHide(notification: NSNotification) {
        loginScrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
}

extension LogInViewController: UITextFieldDelegate {
    
    // tap 'done' on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
