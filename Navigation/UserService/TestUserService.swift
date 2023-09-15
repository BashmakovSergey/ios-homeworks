import UIKit

final class TestUserService: UserService {
    
    let testUser = User(userLogin: "test", userFullName: "test", userAvatar: UIImage(systemName: "person.circle") ?? UIImage(), userStatus: "test")
    
    func authorization(userLogin: String) -> User? {
            return userLogin == testUser.userLogin ? testUser : nil
        }
    
}