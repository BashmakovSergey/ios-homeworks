import UIKit
import StorageService
import MobileCoreServices

final class ProfileViewController: UIViewController {
    
    static let headerIdent = "header"
    static let postIdent = "post"
    static let photoIdent = "photo"
    
    private var currentUser: User?
    let coordinator: ProfileCoordinator?
    
    static var postTableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: ProfileViewController.headerIdent)
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: ProfileViewController.photoIdent)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: ProfileViewController.postIdent)
        tableView.dragInteractionEnabled = true
        return tableView
    }()
    
    init(userService: User?, coordinator: ProfileCoordinator?) {
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
        view.backgroundColor = ColorPalette.whiteBackgroundColor
        #endif
        
        view.addSubview(ProfileViewController.postTableView)
        ProfileViewController.postTableView.dataSource = self
        ProfileViewController.postTableView.delegate = self
        ProfileViewController.postTableView.dragDelegate = self
        ProfileViewController.postTableView.dropDelegate = self
        setupConstraint()
        self.tabBarItem = UITabBarItem(title: "Profile".localized, image: UIImage(systemName: "person.circle"), tag: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ProfileViewController.postTableView.reloadData()
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
            coordinator?.presentPhoto(navigationController: self.navigationController)
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

extension ProfileViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let post = postExamples[indexPath.row]
        let imageProvider = NSItemProvider(object: post.image as NSItemProviderWriting)
        let imageDragItem = UIDragItem(itemProvider: imageProvider)
        imageDragItem.localObject = post.image
        let descriptionProvider = NSItemProvider(object: post.description as NSString)
        let descriptionDragItem = UIDragItem(itemProvider: descriptionProvider)
        descriptionDragItem.localObject = post.description
        return [imageDragItem, descriptionDragItem]
    }
}

extension ProfileViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // get from last row
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
         
        let rowInd = destinationIndexPath.row
        let group = DispatchGroup()

        var postDescription = String()
        group.enter()
        coordinator.session.loadObjects(ofClass: NSString.self) { objects in
            let uStrings = objects as! [String]
            for uString in uStrings {
                postDescription = uString
                break
            }
            group.leave()
        }

        var postImage = UIImage()
        group.enter()
        coordinator.session.loadObjects(ofClass: UIImage.self) { objects in
            let uImages = objects as? [UIImage] ?? []
            for uImage in uImages {
                postImage = uImage
                break
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            // delete moved post if moved
            if coordinator.proposal.operation == .move {
                //postExamples.remove(at: self.postDragAtIndex)
            }
            // insert new post
            let newPost = Post(author: "Drag&Drop", description: postDescription, image: postImage, imageString: "" , likes: 0, views: 0, favorite: false)
            postExamples.insert(newPost, at: rowInd)
            tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        session.canLoadObjects(ofClass: UIImage.self) && session.canLoadObjects(ofClass: NSString.self)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {

        guard session.items.count == 2 else {
            return UITableViewDropProposal(operation: .cancel)
        }

        if tableView.hasActiveDrag {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }

    }
}
