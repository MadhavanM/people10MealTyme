//
//  RestaurantDetailViewController.swift
//  mealTime
//
//  Created by Madhavan on 29/07/20.
//  Copyright © 2020 myApp. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController {
    var restName:String = ""
    var category:String = ""
    var lat: Double = 0.0
    var lon: Double = 0.0
    var addr:String = ""
    var mobl:String = ""
    var twitter:String = ""
    
    @IBOutlet weak var mapVw: MKMapView!
    @IBOutlet weak var lbl_RestName: UILabel!
    @IBOutlet weak var lbl_category: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var lbl_mobl: UILabel!
    @IBOutlet weak var lbl_twitter: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = restName
        lbl_RestName.text = restName
        lbl_category.text = category
        lbl_address.text = addr
        lbl_mobl.text = mobl
        lbl_twitter.text = "@\(twitter)"
        let initialLocation = CLLocation(latitude: lat, longitude: lon)
        self.centerMapOnLocation(location: initialLocation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        DispatchQueue.main.async {
            self.mapVw.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            self.mapVw.addAnnotation(annotation)
        }
    }
}
