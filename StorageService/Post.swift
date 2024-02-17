import Foundation
import UIKit

public struct PostFeed {
    //title only for old homework with PostViewController
    public var title: String
    
    public init(title: String) {
        self.title = title
    }
}

public struct Post {
    public var author: String
    public var description: String
    public var image: UIImage
    public var imageSting: String
    public var likes: Int
    public var views: Int
    public var favorite: Bool
    
    public init(author: String, description: String, image: UIImage, imageString: String, likes: Int, views: Int, favorite: Bool) {
        self.author = author
        self.description = description
        self.image = image
        self.imageSting = imageString
        self.likes = likes
        self.views = views
        self.favorite = favorite
    }
}

public var postExamples: [Post] = [
    Post(author: "Иван Пеньков",
         description: "Мы спасали родные края, сжигая все на своем пути",
         image: UIImage(named: "post1") ?? UIImage(),
         imageString: "post1",
         likes: 20,
         views: 22,
         favorite: false),
    Post(author: "Петр Поворито",
         description: "Я знаю как правильно лечиться огурцами",
         image: UIImage(named: "post2") ?? UIImage(),
         imageString: "post2",
         likes: 10,
         views: 22,
         favorite: false),
    Post(author: "Гном Седой",
         description: "За монету и песню на многое готов",
         image: UIImage(named: "post3") ?? UIImage(),
         imageString: "post3",
         likes: 30,
         views: 33,
         favorite: false),
    Post(author: "Майор Кудрин",
         description: "Наш банк будет вечно работать на территории СИ. Наш банк будет вечно работать на территории СИ",
         image: UIImage(named: "post4") ?? UIImage(),
         imageString: "post4",
         likes: 40,
         views: 44,
         favorite: false)
]
