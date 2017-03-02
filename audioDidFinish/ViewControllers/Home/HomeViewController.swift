//
//  HomeViewController.swift
//  audioDidFinish
//
//  Created by Nitin Gohel on 27/02/17.
//  Copyright © 2017 Nitin Gohel. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblStoryList: UITableView!
    var array = PLIST.shared.mainArray
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryTableviewCell", for: indexPath) as! StoryTableviewCell
        let dict = self.array[indexPath.row] 
        let title = dict["title"] as! String
        let detail = dict["description"] as! String
        
       cell.lblTitle.text = title
        cell.lblSubtitle.text = detail
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated:true)
        
        let messagesVc = self.storyboard?.instantiateViewController(withIdentifier: "PlaySheetViewController_") as! PlaySheetViewController_
        messagesVc.object = self.array[indexPath.row]
     //   messagesVc.reciverDetails = search as! PFUser
     //   messagesVc.SenderDetails = PFUser.currentUser()!
        
       // Navigation.viewControllers = [messagesVc]
        self.navigationController?.show(messagesVc, sender: self)
        //self.navigationController?.pushViewController(messagesVc, animated: true)
        //self.presentViewController(Navigation, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
