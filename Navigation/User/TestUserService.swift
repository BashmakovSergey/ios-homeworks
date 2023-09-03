import UIKit

class TestUserService: UserService {
    
    let testUser = User(userLogin: "test", userFullName: "test", userAvatar: UIImage(systemName: "person.circle") ?? UIImage(), userStatus: "test")
    
    func authorization(userLogin: String) -> User? {
        if userLogin == testUser.userLogin {
            return testUser
        } else {
            return nil
        }
    }
    
}
