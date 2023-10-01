import UIKit

final class CustomButton: UIButton {
    
    var someAction: (() -> Void)?
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped(){
        someAction?()
    }
    
}
