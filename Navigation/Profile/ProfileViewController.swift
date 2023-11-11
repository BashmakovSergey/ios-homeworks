import UIKit
import StorageService

final class ProfileViewController: UIViewController {
    
    static let headerIdent = "header"
    static let postIdent = "post"
    static let photoIdent = "photo"
    
    private var currentUser: User?
    let coordinator: ProfileCoordinator
    
    static var postTableView: UITableView = {
        let tableView = UITableView.init(frame: .zero,style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileViewController.headerIdent)
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: ProfileViewController.photoIdent)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: ProfileViewController.postIdent)
        return tableView
    }()
    
    init(userService: User?, coordinator: ProfileCoordinator) {
        self.currentUser = userService
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
        view.backgroundColor = .red
        #else
        view.backgroundColor = .lightGray
        #endif
        
        view.addSubview(ProfileViewController.postTableView)
        ProfileViewController.postTableView.dataSource = self
        ProfileViewController.postTableView.delegate = self
        setupConstraint()
        self.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.circle"), tag: 1)
    }
     
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            ProfileViewController.postTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            ProfileViewController.postTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            ProfileViewController.postTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ProfileViewController.postTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return postExamples.count
        default:
            assertionFailure("no registered section")
            return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

}

extension ProfileViewController: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = ProfileViewController.postTableView.dequeueReusableCell(withIdentifier: ProfileViewController.photoIdent, for: indexPath) as! PhotosTableViewCell
            return cell
        case 1:
            let cell = ProfileViewController.postTableView.dequeueReusableCell(withIdentifier: ProfileViewController.postIdent, for: indexPath) as! PostTableViewCell
            cell.update(model: postExamples[indexPath.row])
            return cell
        default:
            assertionFailure("no registered section")
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Self.headerIdent) as! ProfileHeaderView
        let user = currentUser
        headerView.avatarImageView.image = UIImage(named: user?.userAvatar ?? "logo")
        headerView.fullNameLabel.text = user?.userFullName
        headerView.statusLabel.text = user?.userStatus
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 270 : 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            tableView.deselectRow(at: indexPath, animated: false)
            coordinator.presentPhoto(navigationController: self.navigationController)
        case 1:
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            if let post = cell as? PostTableViewCell {
                post.incrementPostViewsCounter()
            }
        default:
            assertionFailure("no registered section")
        }
     }
    
}
