import CoreData
import StorageService
import UIKit

final class FavoriteViewController: UIViewController {
    
    let favoriteService = FavoriteService()
    var favoriteBase = [FavoritesPostData]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites".localized
        view.backgroundColor = .systemMint
        view.addSubviews(tableView)
        setupContraints()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialFetch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func initialFetch() {
        favoriteService.fetchItems { [weak self] newFavoriteBase in
            self?.favoriteBase = newFavoriteBase
            self?.tableView.reloadData()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Favorites posts".localized
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "vkBrandColor") ?? .blue]
        let setFilterBarButton = UIBarButtonItem(image: UIImage(systemName: "doc.text.magnifyingglass"), style: .plain, target: self, action: #selector(showFilterByAuthorAlert))
        let clearFilterButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(clearFilter))
        navigationItem.rightBarButtonItems = [setFilterBarButton, clearFilterButton]
    }
    
    @objc private func showFilterByAuthorAlert() {
        let alert = UIAlertController(title: "Enter the author".localized, message: "Sorting posts by author".localized, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Author's name".localized
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .words
            textField.becomeFirstResponder()
        }
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Search".localized, style: .default, handler: { [weak self] _ in
            guard let self, let textField = alert.textFields?.first, let author = textField.text else { return }
            favoriteService.fetchPosts(withPredicate: author) { [weak self] newFavoriteBase in
                self?.favoriteBase = newFavoriteBase
                self?.tableView.reloadData()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func clearFilter() {
        initialFetch()
        }
    
    private func setupContraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}

extension FavoriteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteBase.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseIdentifier, for: indexPath) as? FavoriteCell else {
            return UITableViewCell()
        }
        let favoriteItem = favoriteBase[indexPath.row]
        if favoriteItem.author != nil {
            cell.update(model: favoriteItem)
        }
        cell.selectionStyle = .none
        return cell
    }

}

extension FavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favoriteService.deleteItem(favoriteBase[indexPath.row]) { [weak self] newFavoriteBase in
                self?.favoriteBase = newFavoriteBase
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let oldItem = favoriteBase[indexPath.row]
            if let rowIndex = postExamples.firstIndex(where: {$0.description == oldItem.descriptions}) {
                postExamples[rowIndex].favorite = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete".localized) { [weak self] _,_,_ in
            guard let self else { return }
            favoriteService.deleteItem(favoriteBase[indexPath.row]) { [weak self] newFavoriteBase in
                self?.favoriteBase = newFavoriteBase
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let oldItem = favoriteBase[indexPath.row]
            if let rowIndex = postExamples.firstIndex(where: {$0.description == oldItem.descriptions}) {
                postExamples[rowIndex].favorite = false
            }
        }
        deleteAction.image = UIImage(systemName: "star.slash")
        deleteAction.backgroundColor = UIColor(named: "vkBrandColor")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
