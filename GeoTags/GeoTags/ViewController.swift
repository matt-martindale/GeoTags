//
//  ViewController.swift
//  GeoTags
//
//  Created by Matthew Martindale on 7/15/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private var userTrackingButton: MKUserTrackingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: - Methods
    private func setupViews() {
        locationManager.requestWhenInUseAuthorization()
        // setup Tracking Button
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userTrackingButton)
        NSLayoutConstraint.activate([
            userTrackingButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            userTrackingButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20)
        ])
    }

}

