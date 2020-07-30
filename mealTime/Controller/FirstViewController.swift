//
//  FirstViewController.swift
//  mealTime
//
//  Created by Madhavan on 29/07/20.
//  Copyright © 2020 myApp. All rights reserved.
//

import UIKit
class FirstViewController: UIViewController {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tbl_hotelList: UICollectionView!
    let cellIdentifier = "RestaurantCell"
    var restaurant = [Restaurant]()
    var contact = [Contact]()
    var location = [Location]()
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonParser()
        
    }
    
    
}

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}

extension FirstViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurant.count
    }
}

extension FirstViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! RestaurantCell
        let data = restaurant[indexPath.row]
        cell.lbl_ResName.text = data.name
        cell.lbl_categ.text = data.category
        
        
        var temp1 : String!
        temp1 = data.backgroundImageURL!
        print("temp1: \(temp1!)")
        let url = URL(string: temp1!)
        print("url: \(url!)")
        cell.img_Bck.load(url: url!)
        return cell
    }
    
}


extension FirstViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width:(UIScreen.main.bounds.size.width/2), height: 195)
        }
        return CGSize(width:UIScreen.main.bounds.size.width, height: 195)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
        let data = restaurant[indexPath.row]
        let data1 = location[indexPath.row]
        let data2 = contact[indexPath.row]
        print(data1.lat!)
        newViewController.restName = data.name!
        newViewController.category = data.category!
        newViewController.lat = data1.lat!
        newViewController.lon = data1.lng!
        newViewController.addr = "\(data1.address ?? ""), \(data1.city ?? ""), \(data1.state ?? "") \(data1.postalCode ?? "")"
        print(newViewController.lat)
        newViewController.mobl = (data2.formattedPhone)!
        newViewController.twitter = (data2.twitter)!
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
extension FirstViewController{
    func jsonParser() {
        let urlPath = "https://s3.amazonaws.com/br-codingexams/restaurants.json"
        guard let endpoint = NSURL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        let request = NSMutableURLRequest(url:endpoint as URL)
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            do {
                
                let json = try JSONSerialization.jsonObject(with: (data ?? data)!, options: []) as? NSDictionary
                DispatchQueue.main.async {
                    if let datas = json!.value(forKey: "restaurants") as? NSArray {
                        self.restaurant = Restaurant.modelsFromDictionaryArray(array: datas)
                        self.delegate.latArr = json! .value(forKeyPath: "restaurants.location.lat") as! NSArray
                        self.delegate.lonArr = json! .value(forKeyPath: "restaurants.location.lng") as! NSArray
                        self.delegate.restaurantName = json! .value(forKeyPath: "restaurants.name") as! NSArray
                    }
                    
                    if let datas = json!.value(forKeyPath: "restaurants.location") as? NSArray {
                        self.location = Location.modelsFromDictionaryArray(array: datas)
                    }
                    if let datas = json!.value(forKeyPath: "restaurants.contact") as? NSArray {
                        self.contact = Contact.modelsFromDictionaryArray(array: datas)
                    }
                    self.tbl_hotelList.reloadData()
                }
            } catch {
                
            }
            
        }.resume()
    }
    
}

