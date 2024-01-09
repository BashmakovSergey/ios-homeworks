import CoreLocation
import MapKit
import UIKit

final class MapViewController: UIViewController {
    let coordinator: FeedCoordinator
    
    private let locationManager = CLLocationManager()
    private var nowCoordinate: CLLocationCoordinate2D?
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 17.0, *) {
            mapView.showsUserTrackingButton = true
        } else {
            // Fallback on earlier versions
        }
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressMap))
        mapView.addGestureRecognizer(longGesture)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(pressMap))
        mapView.addGestureRecognizer(gesture)
        return mapView
    }()
    
    private lazy var transportType: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.contentVerticalAlignment = .center
        segmentedControl.insertSegment(with: UIImage(systemName: "car")?.rotate(radians: -.pi/2), at: 0, animated: true)
        segmentedControl.insertSegment(with: UIImage(systemName: "figure.walk")?.rotate(radians: -.pi/2), at: 1, animated: true)
        segmentedControl.transform = CGAffineTransform(rotationAngle: .pi / 2.0)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private lazy var mapType: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.contentVerticalAlignment = .center
        segmentedControl.insertSegment(with: UIImage(systemName: "map")?.rotate(radians: -.pi/2), at: 0, animated: true)
        segmentedControl.insertSegment(with: UIImage(systemName: "binoculars")?.rotate(radians: -.pi/2), at: 1, animated: true)
        segmentedControl.insertSegment(with: UIImage(systemName: "text.viewfinder")?.rotate(radians: -.pi/2), at: 2, animated: true)
        segmentedControl.transform = CGAffineTransform(rotationAngle: .pi / 2.0)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(switchMapType), for:.allEvents)
        return segmentedControl
    }()
    
    private lazy var trackButton = CustomButton(mapTitle: "Set a route".localized, tapAction: self.trackButtonPressed)
    
    private lazy var removeAnnotationsButton = CustomButton(mapImage: "mappin.slash", tapAction: self.removeAnnotationsButtonPressed )
    
    init(coordinator: FeedCoordinator){
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupMap()
    }
    
    private func setupMap() {
        locationManager.delegate = self
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        mapView.delegate = self
    }
    
    private func setupView() {
        view.addSubviews(mapView, transportType, mapType, trackButton, removeAnnotationsButton)
        trackButton.isHidden = true
    }
    
    func setupConstraints() {
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            
            trackButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            trackButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40),
            trackButton.heightAnchor.constraint(equalToConstant: 35),
            trackButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            trackButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            transportType.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            transportType.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 10),
            
            mapType.topAnchor.constraint(equalTo: transportType.bottomAnchor, constant: 70),
            mapType.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 25),
            
            removeAnnotationsButton.topAnchor.constraint(equalTo: mapType.bottomAnchor, constant: 50),
            removeAnnotationsButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    private func trackButtonPressed() {
        trackButton.isHidden = true
        guard let annotation = mapView.selectedAnnotations.first else { return }
        createRoute(to: annotation.coordinate)
    }
    
    private func removeAnnotationsButtonPressed() {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
    }
    
    private func createRoute(to coordinateTo: CLLocationCoordinate2D) {
        mapView.removeOverlays(mapView.overlays)
        guard let coordinateFrom = nowCoordinate else { return }
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinateFrom))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinateTo))
        switch transportType.selectedSegmentIndex {
        case 0:
            request.transportType = .automobile
        default:
            request.transportType = .walking
        }
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] responce, error in
            guard let responce, let route = responce.routes.first else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            self?.mapView.addOverlay(route.polyline)
            self?.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }
    
    func addAnnotation(latitude: Double, longitude: Double, title: String) {
        let alert = UIAlertController(title: "New point".localized, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Label name".localized
        }
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
        alert.addAction(UIAlertAction(title: "Create".localized, style: .default, handler: { [weak self] _ in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.title = alert.textFields?.first?.text
            self?.mapView.addAnnotation(annotation)
        }))
        self.present(alert, animated: true)
    }
    
    @objc private func longPressMap(_ gr: UILongPressGestureRecognizer) {
        let point = gr.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        addAnnotation(latitude: coordinate.latitude, longitude: coordinate.longitude, title: "newPoint")
    }
    
    @objc private func pressMap(_ gr: UILongPressGestureRecognizer) {
        trackButton.isHidden = true
    }
    
    @objc private func switchMapType() {
        switch mapType.selectedSegmentIndex {
        case 0:
            self.mapView.mapType = .standard
        case 1:
            self.mapView.mapType = .satellite
        case 2:
            self.mapView.mapType = .hybrid
        default:
            self.mapView.mapType = .standard
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = locations.first else { return }
        nowCoordinate = CLLocationCoordinate2D(latitude: coordinates.coordinate.latitude, longitude: coordinates.coordinate.longitude)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        trackButton.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .tintColor
        renderer.lineWidth = 4.0
        return renderer
    }
    
}
