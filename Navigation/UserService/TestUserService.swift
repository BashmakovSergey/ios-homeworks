import UIKit

final class TestUserService: UserService {
    
    let testUser = User(userFullName: "test", userAvatar: UIImage(systemName: "person.circle") ?? UIImage(), userStatus: "test")
    
    func authorization() -> User? {
            return testUser
        }
    
}
