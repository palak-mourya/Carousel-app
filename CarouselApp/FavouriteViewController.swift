//
//  FavouriteViewController.swift
//  CarouselApp
//
//  Created by Palak on 21/04/21.
//

import UIKit
import Alamofire
import AlamofireImage

class FavouriteViewController: UITableViewController{
    
    let cachedImage = AutoPurgingImageCache(memoryCapacity: 100_000_000, preferredMemoryUsageAfterPurge: 60_000_000)
    
    var favourite: [UserData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("section created")
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("rows created")
        return favourite?.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("cell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "fav", for: indexPath)
        
        let lblName = cell.viewWithTag(100) as! UILabel
        let lblDOB = cell.viewWithTag(101) as!UILabel
        let lblPhone = cell.viewWithTag(102) as! UILabel
      //  let lblEmail = cell.viewWithTag(103) as! UILabel
        let lblEmail = cell.viewWithTag(103) as! UILabel

        let lblAddress = cell.viewWithTag(104) as! UILabel
        let imgProfile = cell.viewWithTag(105) as! UIImageView
        
        if let favourite = favourite{
            lblName.text = "\(favourite[indexPath.row].results[0].user.name.title) \(favourite[indexPath.row].results[0].user.name.fname) \(favourite[indexPath.row].results[0].user.name.lname)"
            
            let date = Date(timeIntervalSince1970: Double(favourite[indexPath.row].results[0].user.dob)!)
            let myFormatter = DateFormatter()
            myFormatter.dateStyle = .long
            lblDOB.text = "\(myFormatter.string(from: date))"
            
            lblPhone.text = favourite[indexPath.row].results[0].user.phone
            lblEmail.text = favourite[indexPath.row].results[0].user.email
            //lblEmail.text = "PALAK.MOURYA@CAPILLAYTHJBGBUIJKBIUHIUNIUGUIFUHVHBYUFUYBBUGUIFUYECH.COM"

            lblAddress.text = "\(favourite[indexPath.row].results[0].user.location.street), \(favourite[indexPath.row].results[0].user.location.city)"
            
            
            
            let imageURL = URL(string: favourite[indexPath.row].results[0].user.picture)!
            
            imgProfile.af.setImage(withURL: imageURL)
            //loadData(url: imageURL)
            
            //imgProfile.image = cachedImage.image(withIdentifier: "\(imageURL)")
            
            //            if let img = cachedImage.image(withIdentifier: "\(imageURL)"){
            //                imgProfile.image = img
            //            }
            
            
            
            //            URLSession.shared.downloadTask(with: imageURL) { (url, response, error) in
            //
            //                if error == nil, let url = url, let data = try? Data(contentsOf: url),
            //                   let image = UIImage(data: data){
            //
            //                    DispatchQueue.main.async {
            //                        imgProfile.image = image
            //                    }
            //                }
            //
            //            }.resume()
            
            
        }
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func loadData(url: URL){
        
        if let image = cachedImage.image(withIdentifier: "\(url)"){
            print("from cache- \(image)")
        }
        else{
            AF.request(url).responseImage { (response) in
                
                print("from af")
                let img = response.value
                self.cachedImage.add(img!, withIdentifier: "\(url)")
                print(self.cachedImage.image(withIdentifier: "\(url)")!)
                
                
            }
        }
    }
    
}


