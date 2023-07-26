import UIKit

class ProfileViewController: UIViewController {
    
    private lazy var profileHeaderView = ProfileHeaderView()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .lightGray
            view.addSubview(profileHeaderView)
    }
    
    override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            profileHeaderView.frame = view.frame
    }

}
