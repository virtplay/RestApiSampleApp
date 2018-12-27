//
//  ListTableViewController.swift
//  RestApiSampleApp
//
//  Created by Karthik on 27/12/18.
//  Copyright © 2018 k4. All rights reserved.
//

import UIKit

class ListTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    
    var emailid:String?
    var userInfoArray = [UserInfo]()
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        
        tblView.backgroundView = activityIndicatorView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userInfoArray = PersistantService.getSavedObjets()
        if userInfoArray.count == 0 {
            activityIndicatorView.startAnimating()
        }
        
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
        
        DispatchQueue.global().async {
            self.postNFetchJsondata()
        }
    }
    
    
    // MARK: - TableView delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("array count: \(userInfoArray.count)")
        return userInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath) as? CustomTableViewCell {
            if let img = userInfoArray[indexPath.row].image{
                cell.imgView?.image = UIImage(data:img)
            }else{
                cell.imgView.image = UIImage(named: "placehoder.png")
            }
            cell.nameLabel?.text = String("\(userInfoArray[indexPath.row].firstName!)  \(userInfoArray[indexPath.row].lastName!)")
            cell.emailidLabel?.text = userInfoArray[indexPath.row].emailId
            return cell
        }
        return UITableViewCell()
    }
    
    func postNFetchJsondata() {
        // prepare json data
        
        let json: [String: String] = ["emailId": emailid!]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://surya-interview.appspot.com/list")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                if let itemsData = responseJSON!.value(forKey: "items"){
                    let decoder = JSONDecoder()
                    do {
                        let userInfoData = try JSONSerialization.data(withJSONObject: itemsData, options: JSONSerialization.WritingOptions.prettyPrinted)
                        // Decode an array of Posts from this Data
                        
                        let posts = try decoder.decode([UserInfo].self, from: userInfoData)
                        for obj in posts{
                            print(obj)
                            PersistantService.saveObj(userObj: obj)
                        }
                        
                        if self.userInfoArray.count == 0 {
                            DispatchQueue.main.async {
                                self.activityIndicatorView.stopAnimating()
                            }
                        }
                        
                        self.userInfoArray = PersistantService.getSavedObjets()
                        DispatchQueue.main.async {
                            self.tblView.reloadData()  // refresh after POST request
                        }
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
            
        }
        
        task.resume()
        
    }
    

}
