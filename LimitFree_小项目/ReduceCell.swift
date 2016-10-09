//
//  ReduceCell.swift
//  LimitFree_小项目
//
//  Created by 豆豆毛 on 2016/10/8.
//  Copyright © 2016年 豆豆毛vjgj. All rights reserved.
//

import UIKit

class ReduceCell: UITableViewCell {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var lastPriceLabel: UILabel!
    @IBOutlet weak var myStarView: StarView!
 
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    @IBOutlet weak var shareLabel: UILabel!
    
    
    @IBOutlet weak var favoriteLabel: UILabel!
    
    @IBOutlet weak var downloadLabel: UILabel!
    
    //显示数据
    func config(model:LimitModel,atIndex index:Int) {
        
        if index % 2 == 0 {
            bgImageView.image = UIImage(named: "cate_list_bg1")
        }else{
            bgImageView.image = UIImage(named: "cate_list_bg2")
        }
        //2.应用的图片
        let url = NSURL(string: model.iconUrl!)
        appImageView.kf_setImageWithURL(url!)
        //3.名字
        nameLabel.text = "\(index)."+model.name!
        //4.现价
        priceLabel.text = "现价:"+(model.currentPrice!)
        //5.原价
        let priceStr = "¥:"+model.lastPrice!

        let attrStr = NSAttributedString(string: priceStr, attributes: [NSStrikethroughStyleAttributeName: NSNumber(int : 1)])
        lastPriceLabel.attributedText = attrStr
        
        //6.星级
        
        if model.starCurrent != nil{
            
            myStarView.setRating(model.starCurrent!)
            
        }else{
            myStarView.setRating("0.0")
        }
        
        //7.类型
        categoryLabel.text = MyUtil.transferCateName(model.categoryName!)
        
        //shareLabel.text = "分享:"+model.shares!+"次"
        shareLabel.text = "分享:"+model.shares!+"次"
        favoriteLabel.text = "收藏:"+model.favorites!+"次"
        downloadLabel.text = "下载:"+model.downloads!+"次"
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
