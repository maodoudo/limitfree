//
//  ReduceViewController.swift
//  LimitFree_小项目
//
//  Created by 豆豆毛 on 2016/9/27.
//  Copyright © 2016年 豆豆毛vjgj. All rights reserved.
//

import UIKit

class ReduceViewController: LFBaseViewController {

    private var cateId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.blueColor()
        //分页
        addRefresh()
        
        //创建导航
        createMyNav()
        
    }
    
    func createMyNav(){
        
        addNavButton("分类", target: self, action: "gotoCategory", isLeft: true)
        addNavTitle("降价")
        addNavButton("设置", target: self, action: "gotoSetPage", isLeft: false)
        
    }
    //分类
    func gotoCategory(){
        
        let cateCtrl = CategoryViewController()
        
        cateCtrl.delegate = self
        //类型
        cateCtrl.type = .Reduce
        
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(cateCtrl, animated: true)
        hidesBottomBarWhenPushed = false
        
        
        
    }
    //设置
    func  gotoSetPage(){
    
        let setCtrl = SettingViewController()
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(setCtrl, animated: true)
        hidesBottomBarWhenPushed = false
    }
    
    override func downloadData() {
        ProgressHUD.showOnView(view)
        
        var urlString = String(format: kReduceUrl, curPage)
        
        if cateId != nil {
            
            urlString = urlString.stringByAppendingString("&category_id=\(cateId)")
        }
        
        let d = LFDownloader()
        d.delegate = self
        d.downloadWithURLString(urlString)
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

extension ReduceViewController:LFDownloaderDelegate{
    
    func downloader(downloder: LFDownloader, didFailWithError error: NSError) {
        
        ProgressHUD.hideAfterFailOnView(view)
    }
    
    func downloader(downloader: LFDownloader, didFinishWithData data: NSData) {
        
        //如果是下拉刷新，需要清空数据源数组
        
        if curPage == 1 {
            dataArray.removeAllObjects()
        }
        //JSON
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        
        if result.isKindOfClass(NSDictionary) {
            let dict = result as! Dictionary<String,AnyObject>
            let array = dict["applications"] as! Array<Dictionary<String,AnyObject>>
            
            for appDict in array {
                
                let model = LimitModel()
                model.setValuesForKeysWithDictionary(appDict)
                
                dataArray.addObject(model)
            }
            
            dispatch_async(dispatch_get_main_queue(), { 
                self.tbView?.reloadData()
                
                self.tbView?.headerView?.endRefreshing()
                self.tbView?.footerView?.endRefreshing()
                
                ProgressHUD.hideAfterFailOnView(self.view)
            })
            
        }
        
    }
}


extension ReduceViewController{
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "reduceCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? ReduceCell
        if nil == cell {
            
            cell = NSBundle.mainBundle().loadNibNamed("ReduceCell", owner: nil, options: nil).last as? ReduceCell
        }
        //显示数据
        let model = dataArray[indexPath.row] as! LimitModel
        cell?.config(model, atIndex: indexPath.row+1)
        
        return cell!
    
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //点击跳转详情页面
        let model = dataArray[indexPath.row] as! LimitModel
    
        let detailCtrl = DetailViewController()
        detailCtrl.appId = model.applicationId
        
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailCtrl, animated: true)
        
        hidesBottomBarWhenPushed = false
    }
    
}



extension ReduceViewController: CategoryViewControllerDelegate {
    
    func didClickCate(cateId: String, cateName: String) {
        
        var titleStr = "降价-"+cateName
        if cateName == "全部" {
            titleStr = "降价"
        }
        addNavTitle(titleStr)
        
        self.cateId = cateId
        curPage = 1
        
        downloadData()
    
        
    }
}


