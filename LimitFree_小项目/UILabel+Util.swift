//
//  UILabel+Util.swift
//  LimitFree_小项目
//
//  Created by 豆豆毛 on 2016/9/27.
//  Copyright © 2016年 豆豆毛vjgj. All rights reserved.
//

import UIKit

extension UILabel{
        
        class func createLabelFrame(frame:CGRect,title:String?,textAlignment:NSTextAlignment?) -> UILabel{
            
            let label = UILabel(frame:frame)
            label.text = title
            
            if let tmpAlignment = textAlignment{
                label.textAlignment = tmpAlignment
            }
            return label
            
        }
        
    }

    
    
    


