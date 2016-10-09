//
//  CollectViewController.swift
//  LimitFree_小项目
//
//  Created by 豆豆毛 on 2016/10/8.
//  Copyright © 2016年 豆豆毛vjgj. All rights reserved.
//

import UIKit

class CollectViewController: LFNavViewController {
    
    private var dataArray : NSMutableArray?
    
    private var scrollView:UIScrollView?
    private var pageCtrl:UIPageControl?
    private var isDelete = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        automaticallyAdjustsScrollViewInsets = false
        
        createScrollView()
        
        createPageCtrl()
        
        
        
        
    }
    //创建滚动视图
    func createScrollView(){
        scrollView = UIScrollView(frame: CGRectMake(0,64,kScreenWidth,kScreenHeight-64))
        scrollView?.backgroundColor = UIColor(white: 0.9,alpha: 1.0)
        scrollView?.pagingEnabled = true
        view.addSubview(scrollView!)
    }
    //创建分页视图
    func createPageCtrl(){
        pageCtrl = UIPageControl(frame: CGRectMake(80,kScreenHeight-60,200,20))
        pageCtrl?.pageIndicatorTintColor = UIColor.blackColor()
        
        view.addSubview(pageCtrl!)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let dbManager = LFDBManager()
        dbManager.searchAllCollectData { (array) in
            
            self.dataArray = NSMutableArray(array:array)
            
            //显示UI
            dispatch_async(dispatch_get_main_queue(), { 
               self.showCollectData()
            })
        }
    }
    
    //显示收藏的数据
    func showCollectData(){
       //清空之前的子视图
        for tmpView in (scrollView?.subviews)!{
            
            if tmpView.isKindOfClass(CollectButton) {
                tmpView.removeFromSuperview()
            }
        }
        
        if dataArray?.count > 0 {
            let cnt = dataArray?.count
            
            let colNum = 3
            let btnW:CGFloat = 80
            let btnH :CGFloat = 100
            
            let offsetX :CGFloat = 30
            let spaceX = (kScreenWidth-CGFloat(colNum)*btnW-offsetX*2-20)/(CGFloat(colNum-1))
            let offsetY:CGFloat = 120-64
            let spaceY:CGFloat = 80
            
            for i in 0..<cnt! {
                
                let page = i/9
                
                let rowAndCol = i%9
                let row = rowAndCol/colNum
                let col = rowAndCol%colNum
                
                let btnX = offsetX + CGFloat(col)*(btnW+spaceX)+CGFloat(page)*kScreenWidth
                let btnY = offsetY+CGFloat(row)*(btnH+spaceY)
                
                let btn = CollectButton(frame: CGRectMake(btnX,btnY,btnW,btnH))
                btn.model = dataArray![i] as? CollectModel
                btn.isDelete = isDelete
                scrollView?.addSubview(btn)
                btn.addTarget(self, action: #selector(clickBtn(_:)), forControlEvents: .TouchUpInside)
                btn.delegate = self
                btn.btnIndex = i
                
            }
            //设置滚动范围
            var pageCnt = cnt! / 9
            if cnt! % 9 > 0 {
                pageCnt += 1
            }
            
            scrollView?.contentSize = CGSizeMake(CGFloat(pageCnt)*kScreenWidth, 0)
            
            scrollView?.delegate = self
            
            pageCtrl?.numberOfPages = pageCnt
            pageCtrl?.currentPage = 0
        }else{
            MyUtil.showAlertMsg("还没有任何收藏的数据", onViewController: self)
        }
    }
    
    func clickBtn(btn:CollectButton) {
        //如果不是出于删除状态
        if isDelete == false {
            let detailCtrl = DetailViewController()
            
            detailCtrl.appId = btn.model?.applicationId
            navigationController?.pushViewController(detailCtrl, animated: true)
            
        }
    }
    
    func createMyNav(){
        addBackButton()
        
        addNavTitle("我的收藏")
        
        addNavButton("编辑", target: self, action: #selector(editAction(_:)), isLeft: false)
        
    }
    //编辑
    
    func editAction(btn:UIButton){
        
        if isDelete == false {
        
            
            btn.setTitle("完成", forState: .Normal)
            //显示删除按钮
            for tmpView in (scrollView?.subviews)! {
                
                if tmpView.isKindOfClass(CollectButton){
                    let btn = tmpView as! CollectButton
                    btn.isDelete = true
                }
            }
            //3.修改属性
            isDelete = true
        }else {
            //退出删除状态
            btn.setTitle("编辑", forState: .Normal)
            //显示删除按钮
            for tmpView in (scrollView?.subviews)! {
                
                if tmpView.isKindOfClass(CollectButton) {
                    let btn = tmpView as! CollectButton
                    btn.isDelete = false
                }
            }
            
            isDelete = true
        }
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

extension CollectViewController:CollectButtonDelegate{
    
    func didDeleteBtnAtIndex(index: Int) {
        
        let model = dataArray![index] as! CollectModel
        
        let dbManager = LFDBManager()
        dbManager.deleteWithAppId(model.applicationId!) { (flag) in
            
            if flag == true {
                self.dataArray?.removeObjectAtIndex(index)
                //重新显示
                self.showCollectData()
            }else{
                MyUtil.showAlertMsg("删除失败", onViewController: self)
            }
        }
    }
}

//MARK:UIScrollView的代理

extension CollectViewController:UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let index = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
        pageCtrl?.currentPage = index
    }
}


