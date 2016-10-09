//
//  NearByButton.swift
//  LimitFree_小项目
//
//  Created by 豆豆毛 on 2016/10/6.
//  Copyright © 2016年 豆豆毛vjgj. All rights reserved.
//

import UIKit

class NearByButton: UIControl {


    private var imageView :UIImageView?
    private var textLabel:UILabel?
    
    
    var model : LimitModel? {
    
        didSet {
            //显示数据
            let url = NSURL(string: (model?.iconUrl)!)
            imageView?.kf_setImageWithURL(url!)
            
            textLabel?.text = model?.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let titleH:CGFloat = 20
        
        let w = bounds.size.width
        let h = bounds.size.height
        
        //初始化子视图
        imageView = UIImageView(frame: CGRectMake(0, 0, w, h-titleH))
        
        addSubview(imageView!)
        
        textLabel = UILabel.createLabelFrame(CGRectMake(0, h-titleH, w, titleH), title: nil, textAlignment: .Center)
        textLabel?.font = UIFont.systemFontOfSize(12)
        addSubview(textLabel!)
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
