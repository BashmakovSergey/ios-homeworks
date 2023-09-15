import UIKit

final public class User {
    
    var userFullName: String
    var userAvatar: UIImage
    var userStatus: String
    
    init(userFullName: String, userAvatar: UIImage, userStatus: String) {
        self.userFullName = userFullName
        self.userAvatar = userAvatar
        self.userStatus = userStatus
    }
}

protocol UserService {
    func authorization() -> User?
    
}
