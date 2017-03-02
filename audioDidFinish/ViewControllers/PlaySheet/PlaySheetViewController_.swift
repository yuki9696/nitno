//
//  PlaySheetViewController_.swift
//  audioDidFinish
//
//  Created by Nitin Gohel on 27/02/17.
//  Copyright © 2017 Nitin Gohel. All rights reserved.
//

import UIKit
let kLeftCell = "PlaySheetCellLeft"
let kRightCell = "PlaySheetCellRight"
let kHeaderView = "PlaySheetHeader"
class PlaySheetViewController_: UIViewController {
    var messages = Array<[String:Any]>()
    var currentIndex = -2
    var object = [String:Any]() {
        didSet{
            let arr = self.object["chats"] as! [[String:Any]]
            self.messages = arr
        }
    }
    
    @IBOutlet var table:UITableView!
    var player:AudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let leftNib = UINib(nibName: kLeftCell, bundle: nil)
        self.table.register(leftNib, forCellReuseIdentifier: kLeftCell)
        let rightNib = UINib(nibName: kRightCell, bundle: nil)
        self.table.register(rightNib, forCellReuseIdentifier: kRightCell)
        let headerNib = UINib(nibName: kHeaderView, bundle: nil)
        self.table.register(headerNib, forHeaderFooterViewReuseIdentifier: kHeaderView)
        
        self.table.rowHeight = UITableViewAutomaticDimension
        self.table.estimatedRowHeight = 44
        self.table.tableFooterView = UIView()
        self.table.dataSource = self
        self.table.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapTable(_:)))
        self.table.addGestureRecognizer(tap)
//        for i in 0...39 {
//            
//            
//            if(i % 2 == 0) {
//                let text = "Hello Nitin this is test \nWhatup ,Hello Nitin this is test \nWhatup"
//                let sender = "vatsal"
//                let time = Date().timeIntervalSince1970
//                var message = Message(withId: i, sender, time)
//                message.text = text
//                self.messages.append(message)
//                
//            } else if(i % 3 == 0) {
//                let text = "Hello Valtsal this is test \nWhatup goood ,Hello Valtsal this is test \nWhatup goood"
//                let sender = "Nitin"
//                let time = Date().timeIntervalSince1970
//                var message = Message(withId: i, sender, time)
//                message.text = text
//                self.messages.append(message)
//                
//            }else if(i % 5 == 0) {
//                let text = "Hello Nitin this is test Whatup goood ,Hello Valtsal this is test \nWhatup goood \nWhatup goood ,Whatup goood"
//                let sender = "Vatsal"
//                let time = Date().timeIntervalSince1970
//                var message = Message(withId: i, sender, time)
//                message.text = text
//                self.messages.append(message)
//            }else {
//                let text = "Hello Valtsal this is test Whatup goood ,Hello Valtsal this is test \nWhatup goood \nWhatup goood ,Whatup goood"
//                let sender = "Nitin"
//                let time = Date().timeIntervalSince1970
//                var message = Message(withId: i, sender, time)
//                message.text = text
//                self.messages.append(message)
//            }
//            
//        }
        self.table.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player = nil
    }
    deinit {
        self.player = nil
        self.table = nil
    }
}
extension PlaySheetViewController_ : UITableViewDataSource, UITableViewDelegate {
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let msg = self.messages[row]
        if row % 2 == 0 {
            //Left Side
            var cell = tableView.dequeueReusableCell(withIdentifier: kLeftCell) as? PlaySheetCellLeft
            if cell == nil {
                cell = PlaySheetCellLeft(style: .default, reuseIdentifier: kLeftCell)
            }
            cell?.tag = row
            cell?.bubbleView.tag = row
            cell?.message = msg
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapLeft(_:)))
            cell?.addGestureRecognizer(tap)
            cell?.animate = (self.currentIndex == row)
            return cell!
        }
//        else if row % 3 == 0 {
//            //Right Side
//            var cell = tableView.dequeueReusableCell(withIdentifier: kRightCell) as? PlaySheetCellRight
//            if cell == nil {
//                cell = PlaySheetCellRight(style: .default, reuseIdentifier: kRightCell)
//            }
//            cell?.message = msg
//            return cell!
//        }else if row % 5 == 0 {
//            //Left Side
//            var cell = tableView.dequeueReusableCell(withIdentifier: kLeftCell) as? PlaySheetCellLeft
//            if cell == nil {
//                cell = PlaySheetCellLeft(style: .default, reuseIdentifier: kLeftCell)
//            }
//            cell?.message = msg
//            return cell!
//        }
        else {
            //Right Side
            var cell = tableView.dequeueReusableCell(withIdentifier: kRightCell) as? PlaySheetCellRight
            if cell == nil {
                cell = PlaySheetCellRight(style: .default, reuseIdentifier: kRightCell)
            }
            cell?.tag = row
            cell?.bubbleView.tag = row
            cell?.message = msg
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapRight(_:)))
            cell?.addGestureRecognizer(tap)
            cell?.animate = (self.currentIndex == row)
            return cell!
        }
    }
    
    //MARK: UITableViewDelegate
    func tapLeft(_ gesture:UITapGestureRecognizer){
        if gesture.state == .recognized {
            let cell = gesture.view as! PlaySheetCellLeft
            let bubbleView = cell.bubbleView
            let location = gesture.location(in: cell)
            if bubbleView?.frame.contains(location) == true {
                let msg = self.messages[cell.tag]
                print(msg)
                player = AudioPlayer(withStartingClosure: { (dict, index) in
                    self.currentIndex = index
                    self.table.reloadData()
                }, andStopingClosure: { (index) in
                    self.currentIndex = -2
                    self.table.reloadData()
                })
                player.object = msg
            }else {
                player = AudioPlayer(withStartingClosure: { (dict, index) in
                    self.currentIndex = index
                    self.table.reloadData()
                }, andStopingClosure: { (index) in
                    self.currentIndex = -2
                    self.table.reloadData()
                })
                player.object = self.object
            }
        }
    }
    func tapRight(_ gesture:UITapGestureRecognizer){
        if gesture.state == .recognized {
            let cell = gesture.view as! PlaySheetCellRight
            let bubbleView = cell.bubbleView
            let location = gesture.location(in: cell)
            if bubbleView?.frame.contains(location) == true {
                let msg = self.messages[cell.tag]
                print(msg)
                player = AudioPlayer(withStartingClosure: { (dict, index) in
                    self.currentIndex = index
                    self.table.reloadData()
                }, andStopingClosure: { (index) in
                    self.currentIndex = -2
                    self.table.reloadData()
                })
                player.object = msg
            }else {
                player = AudioPlayer(withStartingClosure: { (dict, index) in
                    self.currentIndex = index
                    self.table.reloadData()
                }, andStopingClosure: { (index) in
                    self.currentIndex = -2
                    self.table.reloadData()
                })
                player.object = self.object
            }
        }
    }
    func tapHeader(_ gesture:UITapGestureRecognizer){
        if gesture.state == .recognized {
            let header = gesture.view as! PlaySheetHeader
            let bubbleView = header.bubbleView
            let location = gesture.location(in: header)
            if bubbleView?.frame.contains(location) == true {
                var temp = self.object
                temp.removeValue(forKey: "chats")
                //temp["id"] = -1
                //print(temp)
                player = AudioPlayer(withStartingClosure: { (dict, index) in
                    self.currentIndex = index
                    self.table.reloadData()
                }, andStopingClosure: { (index) in
                    self.currentIndex = -2
                    self.table.reloadData()
                })
                player.isFromHeader = true
                player.object = temp
            }
        }
    }
    func tapTable(_ gesture:UITapGestureRecognizer){
        if gesture.state == .recognized {
            let tbl = gesture.view as! UITableView
            let point = gesture.location(in: tbl)
            let indexPath = self.table.indexPathForRow(at: point)
            if indexPath == nil {
                player = AudioPlayer(withStartingClosure: { (dict, index) in
                    self.currentIndex = index
                    self.table.reloadData()
                }, andStopingClosure: { (index) in
                    self.currentIndex = -2
                    self.table.reloadData()
                })
                player.object = self.object
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: kHeaderView) as? PlaySheetHeader
        if view == nil {
            view = PlaySheetHeader(reuseIdentifier: kHeaderView)
        }
        let msg = self.object
        view?.message = msg
        view?.animate = (self.currentIndex == -1)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapHeader(_:)))
        view?.addGestureRecognizer(tap)
        return view!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
}
