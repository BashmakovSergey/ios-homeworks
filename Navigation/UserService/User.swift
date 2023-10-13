import Foundation

final public class User {
    
    var userFullName: String
    var userAvatar: String
    var userStatus: String
    
    init(userFullName: String, userAvatar: String, userStatus: String) {
        self.userFullName = userFullName
        self.userAvatar = userAvatar
        self.userStatus = userStatus
    }
}

protocol UserService {
    func authorization() -> User?
    
}
