//
//  CategoryCell.swift
//  LimitFree_小项目
//
//  Created by 豆豆毛 on 2016/10/7.
//  Copyright © 2016年 豆豆毛vjgj. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    func configModel(model:CategoryModel,type:CategoryType) {
        
        categoryImageView.image = UIImage(named: "category_"+(model.categoryName)!+".jpg")
        nameLabel.text = MyUtil.transferCateName(model.categoryName!)
        
        
        var typeStr = ""
        
        if type == .LimitFree {
            typeStr = "限免"
        }else if type == .Reduce {
            typeStr = "降价"
            
        }else if type == .Free {
            typeStr = "免费"
        }
        
        descLabel.text = "共有\(model.lessenPrice!)款应用,其中\(typeStr)\(model.count!)款"
        descLabel.font = UIFont.systemFontOfSize(14)
        
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
