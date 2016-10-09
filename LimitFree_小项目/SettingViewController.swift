//
//  SettingViewController.swift
//  LimitFree_小项目
//
//  Created by 豆豆毛 on 2016/10/8.
//  Copyright © 2016年 豆豆毛vjgj. All rights reserved.
//

import UIKit

class SettingViewController: LFNavViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBtn()
        
        createMyNav()
        
        
        
    }
    
    func createMyNav(){
        addBackButton()
        addNavTitle("设置")
    }
    //创建按钮
    func createBtn (){
        
        let imageArray = ["account_setting","account_favorite","account_user","account_collect","account_download","account_comment","account_help","account_candou"]
        let titleArray = ["我的设置","我的关注","我的账号","我的收藏","我的下载","我的评论","我的帮助","蚕豆应用"]
        
        let colNum = 3
        let btnW :CGFloat = 60
        let btnH :CGFloat = 60
        let titleH:CGFloat = 20
        let offsetX:CGFloat = 50
        let offsetY:CGFloat = 160
        let spaceX : CGFloat = (kScreenWidth-offsetX*2-btnW*CGFloat(colNum))/(CGFloat(colNum)-1)
        let spaceY:CGFloat = 80
        
        for i in 0..<imageArray.count{
            //计算行号和列号
            let row = i/colNum
            let col = i%colNum
            
            let btnX = offsetX + (btnW+spaceX)*CGFloat(col)
            let btnY = offsetY + (btnH+titleH+spaceY)*CGFloat(row)
            //按钮
            let btn = UIButton.createBtn(CGRectMake(btnX, btnY, btnW, btnH), title: nil, bgImageName: imageArray[i], target: self, action: #selector(clickBtn(_:)))
            btn.tag = 200+i
            view.addSubview(btn)
            
            let label = UILabel.createLabelFrame(CGRectMake(btnX, btnY+btnW, btnW, titleH), title: titleArray[i], textAlignment: .Center)
            label.font = UIFont.systemFontOfSize(12)
            view.addSubview(label)
        }
    }
    
    
    func clickBtn(btn:UIButton){
        let index = btn.tag - 200
        
        if index == 3 {
            let collectCtrl = CollectViewController()
            hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(collectCtrl, animated: true)
        }
    }
}
