//
//  LimitFreeViewController.swift
//  LimitFree_小项目
//
//  Created by 豆豆毛 on 2016/9/27.
//  Copyright © 2016年 豆豆毛vjgj. All rights reserved.
//

import UIKit

class LimitFreeViewController: LFBaseViewController {
    
    //分类的类型
    private var cateId:String?

    
     //var curPage :Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.redColor()
        //导航
        createMyNav()
        

        //分页
        addRefresh()
    
    }
    //下载
    override func downloadData(){
        //进入加载状态
        ProgressHUD.showOnView(view)
        var urlString = String(format: kLimitUrl,curPage)
        //表示有分类
        if cateId != nil {
            urlString = urlString.stringByAppendingString("&category_id=\(cateId!)")
            
        }
        
        let d = LFDownloader()
        d.delegate = self
        d.downloadWithURLString(urlString)
    }
    
    //创建导航
    func createMyNav(){
        addNavButton("分类", target: self, action: #selector(gotoCategory), isLeft: true)
        //标题
        addNavTitle("限免")
        addNavButton("设置", target: self, action: #selector(gotoSetPage), isLeft: false)
        
    }
    //分类
    func gotoCategory(){
      let cateCtrl = CategoryViewController()
        
        cateCtrl.type = .LimitFree
        
        cateCtrl.delegate = self
        
       hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(cateCtrl, animated: true)
        hidesBottomBarWhenPushed = false
    }
    //设置
    func gotoSetPage(){
        
        let setCtrl = SettingViewController()
        
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(setCtrl, animated: true)
        
        hidesBottomBarWhenPushed = false
        
        
        
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


extension LimitFreeViewController: LFDownloaderDelegate{
    //下载失败
    func downloader(downloder: LFDownloader, didFailWithError error: NSError) {
        
        ProgressHUD.hideAfterFailOnView(view)
    }
    
    func downloader(downloader: LFDownloader, didFinishWithData data: NSData) {
        
        if curPage == 1 {
            dataArray.removeAllObjects()
            
        }
        
        
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        if result.isKindOfClass(NSDictionary){
            let dict = result as! Dictionary<String,AnyObject>
            let array = dict["applications"] as! Array<Dictionary<String,AnyObject>>
            //print(dict)
            for appDict in array{
                let model = LimitModel()
                model.setValuesForKeysWithDictionary(appDict)
                dataArray.addObject(model)
                
            }
            //回到主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), { 
                self.tbView?.reloadData()
                
                self.tbView?.headerView?.endRefreshing()
                self.tbView?.footerView?.endRefreshing()
                
                ProgressHUD.hideAfterSuccessOnView(self.view)
            })
        }
        
    }
    
}

extension LimitFreeViewController{
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "limitCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? LimitCell
        if nil == cell {
            cell = NSBundle.mainBundle().loadNibNamed("LimitCell", owner: nil, options: nil).last as? LimitCell
        }
        
        cell?.selectionStyle = .None
        //显示数据
        let model = dataArray[indexPath.row] as! LimitModel
        cell?.config(model, atIndex: indexPath.row+1 )
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailCtrl = DetailViewController()
        let model = dataArray[indexPath.row] as! LimitModel
        detailCtrl.appId = model.applicationId
        
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailCtrl, animated: true)
        
        hidesBottomBarWhenPushed = false
        
    }
    
    
}

extension LimitFreeViewController:CategoryViewControllerDelegate {
    
    func didClickCate(cateId: String, cateName: String) {
        //标题
        var titleStr = "限免-"+cateName
        
        if cateName == "全部" {
            titleStr = "限免"
        }
        addNavTitle(titleStr)
        
        self.cateId = cateId
        
        curPage = 1
        downloadData()
        
    }
    
    
}


