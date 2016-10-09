//
//  SubjectViewController.swift
//  LimitFree_小项目
//
//  Created by 豆豆毛 on 2016/9/27.
//  Copyright © 2016年 豆豆毛vjgj. All rights reserved.
//

import UIKit

class SubjectViewController: LFNavViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.yellowColor()
        
        createMyNav()
        
        
    }
    
    func createMyNav(){
        addNavButton("分类", target: self, action: #selector(gotoCategory), isLeft: true)
        addNavTitle("专题")
        addNavButton("设置", target: self, action: #selector(gotoSetPage), isLeft: false)
        
    }
    
    func gotoCategory(){
        
    }
    
    func gotoSetPage(){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
