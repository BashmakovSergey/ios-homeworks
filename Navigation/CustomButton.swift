import UIKit

final class CustomButton: UIButton {
    
    var someAction: (() -> Void)?
    
    init(vkTitleText title: String, titleColor color: UIColor, backgroundColor backGroundColor: UIColor, tapAction: (() -> Void)?){
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        backgroundColor = backGroundColor
        self.someAction = tapAction
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        if let pixel = UIImage(named: "blue_pixel") {
            setBackgroundImage(pixel.image(alpha: 1), for: .normal)
            setBackgroundImage(pixel.image(alpha: 0.8), for: .selected)
            setBackgroundImage(pixel.image(alpha: 0.6), for: .highlighted)
            setBackgroundImage(pixel.image(alpha: 0.4), for: .disabled)
        }
        layer.cornerRadius = 12.0
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    init(titleText title: String, titleColor color: UIColor, backgroundColor backGroundColor: UIColor, tapAction: (() -> Void)?){
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        backgroundColor = backGroundColor
        self.someAction = tapAction
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        layer.cornerRadius = 12.0
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    init(mapTitle title: String, tapAction: (() -> Void)?) {
        super.init(frame: .zero)
        self.someAction = tapAction
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        backgroundColor = .white
        setTitleColor(.tintColor, for: .normal)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        layer.cornerRadius = 10
    }
    
    init(mapImage image: String, tapAction: (() -> Void)?) {
        super.init(frame: .zero)
        self.someAction = tapAction
        translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        layer.cornerRadius = 5
        backgroundColor = .white
        guard let imageUI = UIImage(systemName: image) else { return }
        setImage(imageUI.imageWith(newSize: CGSize(width: 25, height: 30)).withTintColor(.lightGray), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped(){
        someAction?()
    }
    
}
