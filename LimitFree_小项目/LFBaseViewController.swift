//
//  LFBaseViewController.swift
//  LimitFree_小项目
//
//  Created by 豆豆毛 on 2016/9/28.
//  Copyright © 2016年 豆豆毛vjgj. All rights reserved.
//

import UIKit

class LFBaseViewController: LFNavViewController {
    
    
    var tbView:UITableView?
    
    lazy var dataArray = NSMutableArray()
    //当前页数
    var curPage:Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        createTableView()
        
        downloadData()
    }
    
    //创建表格
    func createTableView(){
        automaticallyAdjustsScrollViewInsets = false
        
        tbView = UITableView(frame: CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49))
        tbView?.delegate = self
        tbView?.dataSource = self
        view.addSubview(tbView!)
    }
    //分页
    func addRefresh(){
        //下拉刷新
        tbView?.headerView = XWRefreshNormalHeader(target: self, action: #selector(loadFirstPage))
        
        //上拉加载更多
        tbView?.footerView = XWRefreshAutoNormalFooter(target: self, action: #selector(loadNextPage))
    }
    
    func downloadData(){
        //print("子类必须实现这个方法,\(#function)")
    }
    //下拉刷新
    func loadFirstPage(){
        curPage = 1
        downloadData()
    }
    //上拉加载
    func loadNextPage(){
        curPage += 1
        downloadData()
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


extension LFBaseViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("子类必须实现这个方法,\(#function)")
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       // print("子类必须实现这个方法,\(#function)")
        return UITableViewCell()
    }
    
    
    
    
}





