//
//  UIButton+Util.swift
//  LimitFree_小项目
//
//  Created by 豆豆毛 on 2016/9/27.
//  Copyright © 2016年 豆豆毛vjgj. All rights reserved.
//

import UIKit

extension UIButton{

    class func createBtn(frame:CGRect,title:String?,bgImageName:String?,target:AnyObject?,action:Selector) ->UIButton{
        let btn = UIButton(type: .Custom)
        btn.frame = frame
        if let tmpTitle = title {
            btn.setTitle(tmpTitle, forState: .Normal)
            btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
        
        if let imageName = bgImageName{
            btn.setBackgroundImage(UIImage(named: imageName), forState: .Normal)
        }
        
        if target != nil && action != nil {
            btn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        }
        return btn
    }
    
}
