//
//  ViewController.swift
//  CarouselApp
//
//  Created by Palak on 16/04/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    var response: UserData? = nil
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgPlaceholder: UIImageView!
    
    @IBOutlet weak var segmentValue: UISegmentedControl!
    let defaults = UserDefaults.standard
    var favourites: [UserData] = []
    var aView :UIView?
    var name: String = ""
    var address: String = ""
    var email: String = ""
    var phone: String = ""
    var dob: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let data = UserDefaults.standard.value(forKey: "Favourites") as? Data{
            
            favourites = try! PropertyListDecoder().decode([UserData].self, from: data)
            
        }
        
        myView.backgroundColor = .white
        lblDescription.textColor = .black
        imgPlaceholder.layer.cornerRadius = imgPlaceholder.frame.size.width/2
        showData()
        showIndicator()
//        print("The document folder path is \(documentDirectoryPath())")
//        print("The favourite folder path is \(dataFilePath())")
//        loadData()
//
        //        let left = UISwipeGestureRecognizer(target: self, action: #selector(showData))
        //        left.direction = .left
        //        self.myView.addGestureRecognizer(left)
        //
        //        let right = UISwipeGestureRecognizer(target: self, action: #selector(showData))
        //        right.direction = .right
        //        self.myView.addGestureRecognizer(right)
        
    }
    
    // getting the document directory path
//    func documentDirectoryPath()-> URL{
//
//        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return path[0]
//    }
    
    // appending plist file path
//    func dataFilePath()-> URL{
//
//        return documentDirectoryPath().appendingPathComponent("Favourite.plist")
//    }
    
    // save data to user default
//    func saveData(){
//
//        print("save data called")
//
//        let encoder = PropertyListEncoder()
//
//        do{
//            let data = try encoder.encode(favourites)
//            try data.write(to: dataFilePath(), options: .atomic)
//
//        }
//        catch{
//            print("Error while encoding is \(error)")
//        }
//
//    }
    
    // get data from user default
//    func loadData(){
//
//        let path = dataFilePath()
//
//        if let data = try? Data(contentsOf: path){
//
//            let decoder = PropertyListDecoder()
//            do{
//                favourites = try decoder.decode([UserData].self, from: data)
//                print(favourites)
//            }
//            catch{
//                print("Error while loading data is \(error)")
//            }
//        }
//
//    }
    
    
    // swipe left and right for new content
    @IBAction func swipeView(_ sender: UIPanGestureRecognizer) {
        
        let card = sender.view!
        let point = sender.translation(in: view)
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        //let movementFromxCenter = card.center.x - view.center.x
        //let movementFromYCenter = card.center.y - view.center.y
        
        //        if movementFromCenter != 0{
        //            print("hello")
        //        }
        
        if sender.state == UIGestureRecognizer.State.ended{
            
            if (card.center.x > view.center.x*2){
                
                showData()
                showIndicator()
                favourites.append(response!)
                defaults.set(try? PropertyListEncoder().encode(favourites), forKey: "Favourites")
               // saveData()
                
            }
            else if card.center.x < 0{
                
                showData()
                showIndicator()
                
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                card.center = self.view.center
            })
        }
        
        
    }
    
    
    // getting data from API
    @objc func showData(){
        
        let url = URL(string: "https://randomuser.me/api/0.4/?randomapi")
        
        URLSession.shared.dataTask(with: url!) { (responseData, responseCode, responseError) in
            if responseError == nil && responseData != nil{
                
                do{
                    self.response = try JSONDecoder().decode(UserData.self, from: responseData!)
                    print(self.response!)
                    self.setData(result: self.response!)
                    
                }
                catch{
                    print("Error is:\(error)")
                }
                
            }
        }.resume()
        
    }
    
    
    // On selecting different segment
    @IBAction func didChangeSegment(_ sender: UISegmentedControl){
        
        if sender.selectedSegmentIndex == 0{
            lblTitle.text = "Hi, My name is"
            lblDescription.text = name
        }else if sender.selectedSegmentIndex == 1{
            lblTitle.text = "My email is"
            lblDescription.text = email
        }else if sender.selectedSegmentIndex == 2{
            lblTitle.text = "My address is"
            lblDescription.text = address
        }else if sender.selectedSegmentIndex == 3{
            lblTitle.text = "My birthdate is"
            lblDescription.text = dob
        }else if sender.selectedSegmentIndex == 4{
            lblTitle.text = "My phone number is"
            lblDescription.text = phone
        }
        
    }
    
    // setting data after getting repsonse from API
    func setData(result: UserData){
        
        //segmentValue.selectedSegmentIndex = 0
        //lblTitle.text = "Hi, My name is"
        name = String("\(result.results[0].user.name.title) \(result.results[0].user.name.fname) \(result.results[0].user.name.lname)")
        //lblDescription.text = name
        //imgPlaceholder.image = UIImage(
        //result.results[0].user.picture
        
        address = String("\(response!.results[0].user.location.street), \(response!.results[0].user.location.city)")
        email = response!.results[0].user.email
        
        let date = Date(timeIntervalSince1970: Double(response!.results[0].user.dob)!)
        let myFormatter = DateFormatter()
        myFormatter.dateStyle = .long
        
        dob = "\(myFormatter.string(from: date))"
        
        phone = response!.results[0].user.phone
        
        
        let imageURL = URL(string: result.results[0].user.picture)!
        
        URLSession.shared.downloadTask(with: imageURL) { (url, response, error) in
            
            if error == nil, let url = url, let data = try? Data(contentsOf: url),
               let image = UIImage(data: data){
                
                DispatchQueue.main.async {
                    self.segmentValue.selectedSegmentIndex = 0
                    self.imgPlaceholder.image = image
                    self.lblTitle.text = "Hi, My name is"
                    self.lblDescription.text = self.name
                }
            }
            
        }.resume()
        
    }
    
    //    @IBAction func homeClicked(_ sender: UIButton) {
    //
    //        lblTitle.text = "My address is"
    //        lblDescription.text = String("\(response!.results[0].user.location.street), \(response!.results[0].user.location.city)")
    //    }
    
    // Loading icon
    func showIndicator(){
        
        print("indicator called")
        aView = UIView(frame: self.view.bounds)
        aView!.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.center = view.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
        ai.hidesWhenStopped = true
        
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (t) in
            
            print("show data")
            //self.removeIndicator()
            self.aView?.removeFromSuperview()
            ai.stopAnimating()
        }
    }
    
    //On clicking my favourite, data pass to new view controller
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("segue called")
//
//        if segue.identifier == "showFavourite"{
//
//            let controller = segue.destination as! FavouriteViewController
//            //controller.favourite = favourites
//        }
//    }
//
    //    func removeIndicator(){
    //
    //            print("remove indicator")
    //                DispatchQueue.main.async {
    //                    self.aView?.removeFromSuperview()
    //                    self.aView = nil
    //                }
    //            }
    
}

struct UserData: Codable {
    let results:[Result]
}

struct Result: Codable {
    let user: User
    
}

struct User: Codable {
    let location: Location
    let email: String
    let dob: String
    let phone: String
    let picture: String
    let name: Name
    
    enum Codingkeys: String, CodingKey{
        case phone = "cell"
        case email, dob, picture, name, location
        
    }
}

struct Name: Codable {
    let title: String
    let fname: String
    let lname: String
    
    enum CodingKeys: String, CodingKey{
        
        case title
        case fname = "first"
        case lname = "last"
        
    }
}

struct Location: Codable {
    let street: String
    let city: String
}



