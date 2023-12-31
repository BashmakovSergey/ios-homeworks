import CoreLocation
import MapKit
import UIKit

class MapViewController: UIViewController {
    let coordinator: FeedCoordinator
    
    init(coordinator: FeedCoordinator){
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
