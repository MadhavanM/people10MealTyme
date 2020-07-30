//
//  MapViewController.swift
//  mealTime
//
//  Created by Madhavan on 29/07/20.
//  Copyright © 2020 myApp. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var mapVw: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Restaurant Map"
        
        for index in 0...delegate.latArr.count-1 {
            let annotation = MKPointAnnotation()
            annotation.title = (delegate.restaurantName[index]) as? String
            let lat = (delegate.latArr[index]) as! Double
            let lon = (delegate.lonArr[index]) as! Double
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            mapVw.addAnnotation(annotation)
        }
        
        let center = CLLocationCoordinate2D(latitude: (delegate.latArr[0]) as! Double, longitude: (delegate.lonArr[0]) as! Double)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapVw.setRegion(region, animated: true)
    }
}
