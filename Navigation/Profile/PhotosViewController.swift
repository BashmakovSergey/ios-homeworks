import UIKit
import iOSIntPackage

final class PhotosViewController: UIViewController {
    
    let photoIdent = "photoCell"
    private var imagePublisherFacade = ImagePublisherFacade()
    private var collectionImages: [UIImage] = []
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }()

    lazy var photosCollectionView: UICollectionView = {
        let photos = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photos.translatesAutoresizingMaskIntoConstraints = false
        photos.backgroundColor = .white
        photos.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: photoIdent)
        return photos
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        imagePublisherFacade.subscribe(self)
        self.receive(images: collectionImages)
        imagePublisherFacade.addImagesWithTimer(time: 0.5, repeat: 40, userImages: Photos.shared.examples)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        imagePublisherFacade.removeSubscription(for: self)
        imagePublisherFacade.rechargeImageLibrary()
    }
    
    private func setupUI(){
        self.title = "Фотогалерея"
        self.view.addSubview(photosCollectionView)
        self.photosCollectionView.dataSource = self
        self.photosCollectionView.delegate = self
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            photosCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let countItem: CGFloat = 3
        let accessibleWidth = collectionView.frame.width - 32
        let widthItem = (accessibleWidth / countItem)
        return CGSize(width: widthItem, height: widthItem * 1)
    }
}

extension PhotosViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        решение без observer
//        return Photos.shared.examples.count
        
//        решение через observer
        return collectionImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoIdent, for: indexPath) as? PhotosCollectionViewCell else { return UICollectionViewCell()}
        
//        решение без observer
//        cell.update(model: Photos.shared.examples[indexPath.item])
        
//        решение через observer
        cell.update(model: collectionImages[indexPath.item])
        
        return cell
    }
}

extension PhotosViewController: ImageLibrarySubscriber {
    func receive(images: [UIImage]) {
        self.collectionImages = images
        photosCollectionView.reloadData()
    }
}
