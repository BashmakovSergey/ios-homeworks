import Foundation

struct PostFeed {
    //title only for old homework with PostViewController
    var title: String
}

struct Post {
    let author: String
    let description: String
    let image: String
    let likes: Int
    let views: Int
}

let postExamples: [Post] = [
    Post(author: "Иван Пеньков",
         description: "Мы спасали родные края, сжигая все на своем пути",
         image: "post1",
         likes: 20,
         views: 22),
    Post(author: "Петр Поворито",
         description: "Я знаю как правильно лечиться огурцами",
         image: "post2",
         likes: 10,
         views: 22),
    Post(author: "Гном Седой",
         description: "За монету и песню на многое готов",
         image: "post3",
         likes: 30,
         views: 33),
    Post(author: "Майор Кудрин",
         description: "Наш банк будет вечно работать на территории СИ. Наш банк будет вечно работать на территории СИ",
         image: "post4",
         likes: 40,
         views: 44)
]
