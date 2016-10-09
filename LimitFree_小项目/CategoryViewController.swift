//
//  CategoryViewController.swift
//  LimitFree_小项目
//
//  Created by 豆豆毛 on 2016/10/7.
//  Copyright © 2016年 豆豆毛vjgj. All rights reserved.
//

import UIKit


protocol CategoryViewControllerDelegate:NSObjectProtocol {
    func didClickCate(cateId:String,cateName:String)
}
//分类的类型
public enum CategoryType : Int {
    
    case LimitFree
    case Reduce
    case Free
}

class CategoryViewController: LFBaseViewController {
    
    var type: CategoryType?
    
    //（代理的属性）
    weak var delegate : CategoryViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //修改表格的高度
        tbView?.frame.size.height = kScreenHeight-64
        
        //导航
        createMyNav()
        
        
        
    }
    //创建导航
    func createMyNav() {
        
        addBackButton()
        
        
        var titeStr = ""
        
        if type == .LimitFree {
            
            titeStr = "限免-分类"
        }else if type == .Reduce {
            titeStr = "降价-分类"
        }else if type == .Free {
            titeStr = "免费-分类"
        }
        addNavTitle(titeStr)
    }
    
    
    override func downloadData() {
        //加载条
        ProgressHUD.showOnView(view)
        
        var urlString : String? = nil
        //限免
        if type == .LimitFree {
            urlString = kCategoryLimitUrl
        }else if  type == .Reduce {
            urlString = kCategoryReduceUrl
        }else if type == .Free {
            urlString = kCategoryFreeUrl
        }
        
        
        if urlString != nil {
            
            let d = LFDownloader()
            d.delegate = self
            d.downloadWithURLString(urlString!)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
//MARK:LFDownloader的代理
extension CategoryViewController:LFDownloaderDelegate{
    
    
    func downloader(downloder: LFDownloader, didFailWithError error: NSError) {
        
        ProgressHUD.hideAfterFailOnView(view)
    }
    
    
    func downloader(downloader: LFDownloader, didFinishWithData data: NSData) {
        
        //JSON解析
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        if result.isKindOfClass(NSDictionary){
            let dict = result as! Dictionary<String,AnyObject>
            let array = dict["category"] as! Array<Dictionary<String,AnyObject>>
            
            for cateDict in array {
                let cateId = cateDict["categoryId"]
                let cateIdStr = "\(cateId!)"
                
                if cateIdStr == "0" {
                    continue
                }
                
                let model = CategoryModel()
                
                model.setValuesForKeysWithDictionary(cateDict)
            
                dataArray.addObject(model)
                
            }
           //刷新表格
            dispatch_async(dispatch_get_main_queue(), { 
                self.tbView?.reloadData()
                
                ProgressHUD.hideAfterSuccessOnView(self.view)
            })
            
        }
    }
}

//MARK:UITableView的代理

extension CategoryViewController{
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "categoryCellId"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? CategoryCell
        
        if nil == cell {
            
            cell = NSBundle.mainBundle().loadNibNamed("CategoryCell", owner: nil, options: nil).last as? CategoryCell
            
        }
        //显示数据
        let model = dataArray[indexPath.row] as! CategoryModel
    
        cell?.configModel(model , type : type!)
        
      return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = dataArray[indexPath.row] as! CategoryModel
        
        let cateId = "\(model.categoryId!)"
        let cateName = MyUtil.transferCateName(model.categoryName!)
        
        delegate?.didClickCate(cateId, cateName: cateName)
        //返回上一页面
        navigationController?.popViewControllerAnimated(true)
    }
    
    
}

