import CoreData
import StorageService
import Foundation

final class FavoriteService{
  
    private let coreDataService = CoreDataService.shared

    private (set) var favoriteItems = [FavoritesPostData]()

    init() {
        fetchItems()
    }
    
    private func fetchItems(){
        let request = FavoritesPostData.fetchRequest()
        do {
            favoriteItems = try coreDataService.context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func createItem(post: Post){
        let newItem = FavoritesPostData(context: coreDataService.context)
        newItem.author = post.author
        newItem.descriptions = post.description
        newItem.image = post.image
        newItem.favorive = true
        if let rowIndex = postExamples.firstIndex(where: {$0.description == newItem.descriptions}) {
            postExamples[rowIndex].favorite = true
        }
        
        coreDataService.saveContext()
        fetchItems()
        updateCell()
    }

    func deleteItem(at index:Int){
        let oldItem = favoriteItems[index]
        if let rowIndex = postExamples.firstIndex(where: {$0.description == oldItem.descriptions}) {
            postExamples[rowIndex].favorite = false
        }
        coreDataService.context.delete(favoriteItems[index])
        coreDataService.saveContext()
        fetchItems()
        updateCell()
    }
   
    func getAllItems() -> [FavoritesPostData] {
        fetchItems()
        return favoriteItems
    }

    private func updateCell(){
        DispatchQueue.main.async {
            ProfileViewController.postTableView.reloadData()
        }
    }
}
