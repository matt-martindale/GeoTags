//
//  ViewController.swift
//  GeoTags
//
//  Created by Matthew Martindale on 7/15/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import UIKit
import MapKit

class PostAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var author: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, author: String?) {
        self.coordinate = coordinate
        self.title = title
        self.author = author
    }
}

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private var userTrackingButton: MKUserTrackingButton!
    var pinTitle: String?
    var pinAuthor: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: - Methods
    private func setupViews() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = .greatestFiniteMagnitude
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // setup Tracking Button
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userTrackingButton)
        NSLayoutConstraint.activate([
            userTrackingButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            userTrackingButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20)
        ])
        // GestureRecognizer for adding annotations
        let addPinTap = UILongPressGestureRecognizer(target: self, action: #selector(addPin(_:)))
        addPinTap.minimumPressDuration = 1.5
        mapView.addGestureRecognizer(addPinTap)
    }
    
    @objc private func addPin(_ recognizer: UIGestureRecognizer) {
        self.addPinAlert()
        
        guard let title = self.pinTitle,
            let author = self.pinAuthor else { return }
        
        let touchedAt = recognizer.location(in: self.mapView)
        let touchedAtCoordinate: CLLocationCoordinate2D = self.mapView.convert(touchedAt, toCoordinateFrom: self.mapView)
        
        let newPin = PostAnnotation(coordinate: touchedAtCoordinate, title: title, author: author)
        self.mapView.addAnnotation(newPin)
        
    }
    
    func addPinAlert() {
        
        let alert = UIAlertController(title: "Add Pin", message: "Please add title and author of pin", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Add title"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Add author"
        }
        
        let okAction = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            guard let title = alert.textFields?[0].text,
                let author = alert.textFields?[1].text else { return }
            DispatchQueue.main.async {
                self?.pinTitle = title
                self?.pinAuthor = author
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}

