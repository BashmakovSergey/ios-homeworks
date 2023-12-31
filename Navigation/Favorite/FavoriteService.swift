import CoreData
import StorageService
import Foundation

final class FavoriteService{
  
    private let coreDataService = CoreDataService.shared

    private (set) var favoriteItems = [FavoritesPostData]()

    func fetchItems(completion: @escaping ([FavoritesPostData]) -> Void) {
        coreDataService.backgroundContext.perform { [weak self] in
            guard let self else { return }
            let request = FavoritesPostData.fetchRequest()
            do {
                favoriteItems = try coreDataService.backgroundContext.fetch(request).map { $0 }
                coreDataService.mainContext.perform { [weak self] in
                    guard let self else { return }
                    completion(favoriteItems)
                }
            } catch {
                print(error)
                favoriteItems = []
                completion(favoriteItems)
            }
        }
        updateCell()
    }
    
    func createItem(with post: Post, completion: @escaping ([FavoritesPostData]) -> Void) {
        coreDataService.backgroundContext.perform { [weak self] in
            guard let self else { return }
            let newItem = FavoritesPostData(context: coreDataService.backgroundContext)
            newItem.author = post.author
            newItem.descriptions = post.description
            newItem.image = post.image
            newItem.favorive = true
            if let rowIndex = postExamples.firstIndex(where: {$0.description == newItem.descriptions}) {
                postExamples[rowIndex].favorite = true
            }
            if coreDataService.backgroundContext.hasChanges {
                do {
                    try coreDataService.backgroundContext.save()
                    coreDataService.mainContext.perform { [weak self] in
                        guard let self else { return }
                        favoriteItems.insert(newItem, at: 0)
                        completion(favoriteItems)
                    }
                } catch {
                    coreDataService.mainContext.perform { [weak self] in
                        guard let self else { return }
                        completion(favoriteItems)
                    }
                }
            }
        }
        updateCell()
    }
    
    func fetchPosts(withPredicate search: String, completion: @escaping ([FavoritesPostData]) -> Void) {
        let predicate = NSPredicate(format: "author == %@", search)
        coreDataService.backgroundContext.perform { [weak self] in
            guard let self else { return }
            let request = NSFetchRequest<FavoritesPostData>(entityName: "FavoritesPostData")
            request.predicate = predicate
            do {
                favoriteItems = try coreDataService.backgroundContext.fetch(request).map{$0}
                coreDataService.mainContext.perform { [weak self] in
                    guard let self else { return }
                    completion(favoriteItems)
                }
            } catch {
                print(error)
                favoriteItems = []
                completion(favoriteItems)
            }
        }
    }
    
    func deleteItem(_ favoriteItem: FavoritesPostData, completion: @escaping ([FavoritesPostData]) -> Void) {
        coreDataService.backgroundContext.perform { [weak self] in
            guard let self else { return }
            coreDataService.backgroundContext.delete(favoriteItem)
            do {
                try coreDataService.backgroundContext.save()
                favoriteItems.removeAll(where: { $0.description == favoriteItem.description })
                if let rowIndex = postExamples.firstIndex(where: {$0.description == favoriteItem.descriptions}) {
                    postExamples[rowIndex].favorite = false
                }
                coreDataService.mainContext.perform { [weak self] in
                    guard let self else { return }
                    completion(favoriteItems)
                }
            } catch {
                print(error)
                coreDataService.mainContext.perform { [weak self] in
                    guard let self else { return }
                    completion(favoriteItems)
                }
            }
        }
        updateCell()
    }

    private func updateCell(){
        DispatchQueue.main.async {
            ProfileViewController.postTableView.reloadData()
        }
    }
    
}
