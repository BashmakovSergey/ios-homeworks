import UIKit
import iOSIntPackage

final class PhotosViewController: UIViewController {
    
    let photoIdent = "photoCell"
    private var timer: Timer?
    private let imageProcessor = ImageProcessor()
    private var collectionImages: [UIImage] = {Photos.shared.examples}()
    
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
        filterImage(filter: .noir)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "0.0", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
        disableTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func disableTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func filterImage(filter: ColorFilter) {
        let timerInterval = 0.01
        var filterDuration = 0.00
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true, block: { _ in
            filterDuration += timerInterval
            let totalTime = String( format: "%.2f sec", filterDuration)
            self.navigationItem.rightBarButtonItem?.title = totalTime
        })
        imageProcessor.processImagesOnThread(sourceImages: collectionImages, filter: filter, qos: .default) { [weak self] filteredImage in
            guard let self else { return }
            self.collectionImages = filteredImage.compactMap { UIImage(cgImage: $0!) }
            DispatchQueue.main.sync {
                self.photosCollectionView.reloadData()
                self.disableTimer()
            }
        }
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
        return collectionImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoIdent, for: indexPath) as? PhotosCollectionViewCell else { return UICollectionViewCell()}
        cell.update(model: collectionImages[indexPath.item])
        return cell
    }
}
