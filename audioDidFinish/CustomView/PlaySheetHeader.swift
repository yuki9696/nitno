//
//  PlaySheetHeader.swift
//  audioDidFinish
//
//  Created by Nitin Gohel on 01/03/17.
//  Copyright © 2017 Nitin Gohel. All rights reserved.
//

import UIKit

class PlaySheetHeader: UITableViewHeaderFooterView {
    
    @IBOutlet var bubbleView:UIView!
    @IBOutlet var LBLTitle:UILabel!
    @IBOutlet var LBLDetail:UILabel!
    @IBOutlet var IMGView:UIImageView!
    @IBOutlet var IMGTitle:UIImageView!
    
    var animate = false {
        didSet{
            if self.animate == true {
                self.IMGView.startAnimating()
                self.bubbleView.backgroundColor = UIColor.cyan
            }else {
                self.IMGView.stopAnimating()
                self.bubbleView.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 239.0/255.0, alpha: 1)
            }
        }
    }
    
    //??
    var message:[String:Any]? {
        didSet{
            guard let msg = self.message else { return  }
            let title = msg["title"] as! String
            self.LBLTitle.text = title
            let details = msg["description"] as! String
            self.LBLDetail.text = details
        }
    }
    
    //awakefrom nibとは？　nibファイルから読み込まれたあとに、サービスに必要なレシーバを用意する。
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bubbleView.layer.cornerRadius = 3
        self.bubbleView.layer.masksToBounds = true
        
        self.IMGTitle.layer.cornerRadius = 8
        self.IMGTitle.layer.masksToBounds = true
        
        let view = UIView()
        view.backgroundColor = UIColor.white
        self.backgroundView = view
        self.IMGView.animationImages = [#imageLiteral(resourceName: "speaker1"),#imageLiteral(resourceName: "speaker2"),#imageLiteral(resourceName: "speaker3"),#imageLiteral(resourceName: "speaker4")]
        self.IMGView.animationDuration = 0.9
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
