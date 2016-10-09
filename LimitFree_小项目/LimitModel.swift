//
//  LimitModel.swift
//  LimitFree_小项目
//
//  Created by 豆豆毛 on 2016/9/28.
//  Copyright © 2016年 豆豆毛vjgj. All rights reserved.
//

import UIKit

class LimitModel: NSObject {

    var applicationId :String?
    var slug:String?
    var name:String?
    
    var releaseDate:String?
    var version:String?
    var desc:String?
    
    var categoryId:NSNumber?
    var categoryName:String?
    var iconUrl:String?
    
    var itunesUrl :String?
    var starCurrent:String?
    var starOverall:String?
    
    var ratingOverall:String?
    var downloads:String?
    var currentPrice:String?
    
    var lastPrice:String?
    var priceTrend:String?
    var expireDatetime:String?
    
    var releaseNotes:String?
    var updateDate:String?
    var fileSize:String?
    
    var ipa:String?
    var shares:String?
    var favorites:String?
    
    
    
    func setDescription(desc:String){
        self.desc = desc
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    
    
    
    
}
