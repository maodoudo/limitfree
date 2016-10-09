//
//  MainTabBarController.swift
//  LimitFree_小项目
//
//  Created by 豆豆毛 on 2016/9/27.
//  Copyright © 2016年 豆豆毛vjgj. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //修改选中文字的颜色   
        
        tabBar.tintColor = UIColor(red: 83.0/255.0, green: 156.0/255.0, blue: 255.0/255.0, alpha: 1.0)

        // Do any additional setup after loading the view.
        
        createViewControllers()
//        tabBar.barTintColor = UIColor.blackColor()
    }
    
    func createViewControllers(){
        let titleArray = ["限免","降价","免费","专题","热榜"]
        let imageArray = ["tabbar_limitfree",
                          "tabbar_reduceprice",
                          "tabbar_appfree",
                          "tabbar_subject",
                          "tabbar_rank"]
        let ctrlArray = [
            "LimitFree_小项目.LimitFreeViewController",
            "LimitFree_小项目.ReduceViewController",
            "LimitFree_小项目.FreeViewController",
            "LimitFree_小项目.SubjectViewController",
            "LimitFree_小项目.RankViewController"]
        
        var array = Array<UINavigationController>()
        for i in 0..<titleArray.count{
            
            let ctrlName = ctrlArray[i]
            let cls = NSClassFromString(ctrlName) as! UIViewController.Type
            let ctrl = cls.init()
            //设置文字和图片 
            ctrl.tabBarItem.title = titleArray[i]
            
        
            let imageName = imageArray[i]
            
            ctrl.tabBarItem.image = UIImage(named: imageName)
            ctrl.tabBarItem.selectedImage = UIImage(named: (imageName+"_press"))?.imageWithRenderingMode(.AlwaysOriginal)
            
            let navCtrl = UINavigationController(rootViewController: ctrl)
            array.append(navCtrl)
        }
        
        viewControllers = array
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
