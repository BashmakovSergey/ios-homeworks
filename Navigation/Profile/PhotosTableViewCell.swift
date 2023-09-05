import UIKit

final class PhotosTableViewCell: UITableViewCell {
    
    var labelPhotos: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Photos"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    var arrowImage: UIImageView = {
        let arrow = UIImageView()
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.image = UIImage(systemName: "arrow.right")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        return arrow
    }()
    
    var stackViewImage: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(labelPhotos, arrowImage, stackViewImage)
        setupPreviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelPhotos.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            labelPhotos.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            labelPhotos.widthAnchor.constraint(equalToConstant: 80),
            labelPhotos.heightAnchor.constraint(equalToConstant: 40),

            arrowImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            arrowImage.centerYAnchor.constraint(equalTo: labelPhotos.centerYAnchor),
            arrowImage.heightAnchor.constraint(equalToConstant: 40),
            arrowImage.widthAnchor.constraint(equalToConstant: 40),

            stackViewImage.topAnchor.constraint(equalTo: labelPhotos.bottomAnchor, constant: 12),
            stackViewImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackViewImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stackViewImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
    
    func getPreviewImage(index: Int) -> UIImageView {
        let preview = UIImageView()
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.image = Photos.shared.examples[index]
        preview.contentMode = .scaleAspectFill
        preview.layer.cornerRadius = 6
        preview.clipsToBounds = true
        return preview
    }
    
    private func setupPreviews() {
        for ind in 0...3 {
            let image = getPreviewImage(index: ind)
            stackViewImage.addArrangedSubview(image)
            NSLayoutConstraint.activate([
                image.widthAnchor.constraint(greaterThanOrEqualToConstant: (contentView.frame.width - 24) / 4),
                image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 0.56),
            ])
        }
    }

}
