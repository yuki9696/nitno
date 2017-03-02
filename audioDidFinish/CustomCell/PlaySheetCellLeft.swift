//
//  PlaySheetCell.swift
//  audioDidFinish
//
//  Created by Nitin Gohel on 27/02/17.
//  Copyright © 2017 Nitin Gohel. All rights reserved.
//

import UIKit

class PlaySheetCellLeft: UITableViewCell {
    @IBOutlet var LBLTitle:UILabel!
    @IBOutlet var LBLDetail:UILabel!
    @IBOutlet var bubbleView:UIView!
    @IBOutlet var widthConstraint: NSLayoutConstraint!
    @IBOutlet var IMGView:UIImageView!
    
    var animate = false {
        didSet{
            if self.animate == true {
                self.IMGView.startAnimating()
                self.bubbleView.backgroundColor = UIColor(red: 255.0/255.0, green: 238.0/255.0, blue: 42.0/255.0, alpha: 1)
            }else {
                self.IMGView.stopAnimating()
                self.bubbleView.backgroundColor = UIColor.groupTableViewBackground
            }
        }
    }
    
    
    var message:[String:Any]? {
        didSet{
            guard let msg = self.message else { return  }
            let title = msg["title"] as! String
            self.LBLTitle.text = title
            let details = msg["detail"] as! String
            self.LBLDetail.text = details
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        let width = UIScreen.main.bounds.width
        self.separatorInset = UIEdgeInsets(top: 0, left: width, bottom: 0, right: 0)
        self.bubbleView.layer.cornerRadius = 12
        self.bubbleView.layer.masksToBounds = true
        let width75 = self.get(75, ofWidth: width)
        print("Left Cell Title Width: = \(width75)")
        self.widthConstraint.constant = width75
        self.LBLTitle.layoutIfNeeded()
        self.IMGView.animationImages = [#imageLiteral(resourceName: "ic_speaker_0"),#imageLiteral(resourceName: "ic_speaker_1"),#imageLiteral(resourceName: "ic_speaker_3")]
        self.IMGView.animationDuration = 0.25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func get(_ percent:CGFloat,ofWidth width:CGFloat) -> CGFloat {
//        1)Choose a number.
//        2)Multiply the number by 3.
//        3)Divide this product by 4.
        var value = width * 3
        value = value / 4
        return value
    }
}
