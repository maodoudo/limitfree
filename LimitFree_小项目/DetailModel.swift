//
//  DetailModel.swift
//  LimitFree_小项目
//
//  Created by 豆豆毛 on 2016/9/27.
//  Copyright © 2016年 豆豆毛vjgj. All rights reserved.
//

import UIKit

class DetailModel :NSObject{
    
    var applicationId:String?
    var appurl:String?
    var categoryId:NSNumber?
    
    var categoryName:String?
    var currentPrice:String?
    var currentVersion:String?
    
    func setDescription(desc:String){
        self.desc = desc
    }

    var desc:String?
    var description_long: String?
    var downloads:NSObject?
    
    
    var expireDatetime:String?
    var fileSize:String?
    var iconUrl:String?
    
    var itunesUrl:String?
    var language:String?
    var lastPrice:String?
    
    var name:String?
    var newversion:String?
    var photos:Array<PhotoModel>?
    
    var priceTrend:String?
    var ratingOverall:String?
    var releaseDate:String?
    
    var releaseNotes:String?
    var sellerId:String?
    var sellerName:String?
    
    var slug:String?
    var starCurrent:String?
    var starOverall:String?
    
    var systemRequirements:String?
    var updatedate:String?
    
    
   
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
        
    }
    
}



class PhotoModel:NSObject{
    
    var originalUrl :String?
    var smallUrl:String?
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
        
    }
}

