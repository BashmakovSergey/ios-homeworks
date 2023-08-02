import UIKit

final class Photos {
    
    static let shared = Photos()
    
    let examples: [UIImage]
    
    private init() {
        var photos = [UIImage]()
        for i in 1...20 { photos.append((UIImage(named: "photo\(i)") ?? UIImage())) }
        examples = photos.shuffled()
    }
}
