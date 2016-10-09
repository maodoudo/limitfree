//
//  DetailViewController.swift
//  LimitFree_小项目
//
//  Created by 豆豆毛 on 2016/9/28.
//  Copyright © 2016年 豆豆毛vjgj. All rights reserved.
//

import UIKit

import CoreLocation


class DetailViewController: LFNavViewController {
    
    
    
    var appId :String?
    
    
    @IBOutlet weak var appImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var lastPriceLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var favoriteBtn: UIButton!
    
    @IBOutlet weak var downloadBtn: UIButton!
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet weak var nearByScrollView: UIScrollView!
    

    @IBOutlet weak var descLabel: UILabel!
    
    
    
    
    //详情的数据
    private var detailModel : DetailModel?
    
    
    //定位对象
    private var manager:CLLocationManager?
    
    //下载详情是否成功
    private var detailSuccess:Bool?
    
    //下载附近数据是否下载成功
    private var nearBySuccess:Bool?
    
    
    private var isNearbyDownload:Bool?
    
    //分享
    @IBAction func shareAction() {
    }
    //收藏
    @IBAction func favoriteAction(){
        //创建收藏的数据对象
        if appImageView.image != nil {
        
            let model = CollectModel()
            model.applicationId = detailModel?.applicationId!
            model.name = detailModel?.categoryName!
            model.headImage = appImageView.image
            
            let dbManager = LFDBManager()
            dbManager.addCollect(model, finishClosure: { (flag) in
                
                if flag == true {
                    MyUtil.showAlertMsg("收藏成功", onViewController: self)
                    self.refreshAppState()
                    
                }else{
                    MyUtil.showAlertMsg("收藏失败", onViewController: self)
                }
            })
            
        }else{
            MyUtil.showAlertMsg("数据正在下载,    请稍后再试", onViewController: self)
        }
        
        
    }
    //下载
    @IBAction func dowanloadAction() {
        
        if detailModel?.itunesUrl != nil {
            
            let url = NSURL(string:(detailModel?.itunesUrl)!)
            if UIApplication.sharedApplication().canOpenURL(url!) {
                
                UIApplication.sharedApplication().openURL(url!)
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
         //下载详情数据
        downloadDetailData()
        
        //定位
        locate()
        
        
        //导航
        createMyNav()
       
        //判断是否已经收藏
        verifyAppState()
        
    }
    
    func verifyAppState(){
        
        let dbManager = LFDBManager()
        
        dbManager.isAppFavorite(appId!) {
            (flag) in
            //如果已经收藏，不然后用户在收藏
            if flag == true {
                self.refreshAppState()
            }
        }
    }
    //如果已经收藏，修改收藏按钮的状态
    func refreshAppState(){
        dispatch_async(dispatch_get_main_queue()) { 
            
            self.favoriteBtn.setTitle("已收藏", forState: .Normal)
            self.favoriteBtn.setTitleColor(UIColor.grayColor(), forState: .Normal)
            self.favoriteBtn.enabled = false
        }
    }
    
    
    //下载
    func downloadDetailData(){
        
        let urlString = String(format: kDetailUrl,appId!)
        
        let d = LFDownloader()
        d.delegate = self
        
        d.type = .Detail
        
        d.downloadWithURLString(urlString)
        
        print(appId!)
        
    }
    //定位
    func locate(){
        
        manager = CLLocationManager()
        manager?.distanceFilter = 10
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        //请求定位
        if manager?.respondsToSelector(#selector(CLLocationManager.requestWhenInUseAuthorization)) == true {
            manager?.requestWhenInUseAuthorization()
            
        }
        
        manager?.delegate = self
        //开始定位
        manager?.startUpdatingLocation()
        
        
    }
    
    //导航
    func createMyNav(){
        addNavTitle("应用详情")
        //返回按钮
        addBackButton()
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func  showDetail(){
        //图片
        let url = NSURL(string: (detailModel?.iconUrl)!)
        appImageView.kf_setImageWithURL(url!)
        
        nameLabel.text = detailModel?.name
        
        lastPriceLabel.text = "原价:" + (detailModel?.lastPrice)!
        //状态
        if detailModel?.priceTrend == "limited" {
            statusLabel.text = "限免中"
        }
    
        sizeLabel.text = (detailModel?.fileSize)! + "MB"
        //类型
        categoryLabel.text = MyUtil.transferCateName((detailModel?.categoryName)!)
        
        rateLabel.text = "评分:" + (detailModel?.starCurrent)!
        
        //app的截图
        
        let cnt = detailModel?.photos?.count
        let imageH:CGFloat = 80
        let imageW:CGFloat = 80
        let marginX : CGFloat = 10  //图片的横向间距
        //循环创建图片 ，显示到滚动视图上面去
        for i in 0..<cnt!{
            let frame = CGRectMake((imageW+marginX)*CGFloat(i), 0, imageW, imageH)
            let tmpImageView = UIImageView(frame: frame)
            
            let pModel = detailModel?.photos![i]
            let url = NSURL(string: (pModel?.smallUrl)!)
            tmpImageView.kf_setImageWithURL(url!)
            
            //添加点击图片的收视
            
            let g = UITapGestureRecognizer(target: self, action: "tapImage:")
            tmpImageView.userInteractionEnabled = true
            tmpImageView.addGestureRecognizer(g)
            
            tmpImageView.tag = 100 + i
            
            imageScrollView.addSubview(tmpImageView)
        }
        
        //设置图片的滚动范围
        imageScrollView.contentSize = CGSizeMake((imageW+marginX)*CGFloat(cnt!), 0)
        //文字描述
        descLabel.text = detailModel?.desc
    }
    //实现手势的点击方法
    func tapImage(g:UIGestureRecognizer){
        let index = (g.view?.tag)! - 100
        
        let photoCtrl = PhotoViewController()
        photoCtrl.modalTransitionStyle = .FlipHorizontal
        photoCtrl.photoIndex = index
        photoCtrl.photoArray = detailModel?.photos
        presentViewController(photoCtrl, animated: true, completion: nil)
        
    }
    
    //解析详情界面的数据
    func parseDetailData(data:NSData) {
   
        let result  = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        
        if result.isKindOfClass(NSDictionary){
            let dict = result as! Dictionary<String,AnyObject>
            detailModel = DetailModel()
            detailModel?.setValuesForKeysWithDictionary(dict)
            print(dict)
            var pArray = Array<PhotoModel>()
            for pDict in (dict["photos"] as! NSArray) {
                let model = PhotoModel()
                model.setValuesForKeysWithDictionary(pDict as! [String:AnyObject])
                pArray.append(model)
            }
            detailModel?.photos = pArray
            //回到主线程刷新页面
            dispatch_async(dispatch_get_main_queue(), { 
                self.showDetail()
            })
        }
        
        
    }
    
    
    //显示附近的数据
    func showNearData(array:Array<LimitModel>) {
        
        let btnW :CGFloat = 60   //按钮的宽度
        let btnH :CGFloat = 80
        let marginX:CGFloat = 10
        
        for i in 0..<array.count{
            
            let model = array[i]
            //创建按钮对象
           let btn = NearByButton(frame: CGRectMake((btnW+marginX)*CGFloat(i),0,btnW,btnH))
            btn.addTarget(self, action: #selector(clickBtn(_:)), forControlEvents: .TouchUpInside)
            //显示数据
            btn.model = model
            nearByScrollView.addSubview(btn)
            
        }
        //设置滚动范围
        nearByScrollView.contentSize = CGSizeMake((btnW+marginX)*CGFloat(array.count), 0)
    }
    //点击手势
    func clickBtn(btn:NearByButton){
        
        //跳转详情界面
        let detailCtrl = DetailViewController()
        detailCtrl.appId = btn.model?.applicationId
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailCtrl, animated: true)
        
        
    }
    //解析附近的数据
    func parseNearByData(data:NSData) {
        
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
        if result.isKindOfClass(NSDictionary) {
            let dict = result as! Dictionary<String,AnyObject>
            let array = dict["applications"] as! Array<Dictionary<String,AnyObject>>
            
            var modelArray = Array<LimitModel>()
            
            for appDict in array {
                
                let model = LimitModel()
                
                model.setValuesForKeysWithDictionary(appDict)
                modelArray.append(model)
            }
            //显示数据
            dispatch_async(dispatch_get_main_queue(), { 
                self.showNearData(modelArray)
            })
            
            
            
        }
    }
}
//MARK:LFDownloader的代理
extension DetailViewController: LFDownloaderDelegate{
    
    func downloader(downloder: LFDownloader, didFailWithError error: NSError) {
        
        
        if downloder.type == .Detail {
            detailSuccess = false
        }else if downloder.type == .NearBy {
            
            nearBySuccess = false
        }
        //两个都下载失败。才算失败
        if detailSuccess == false && nearBySuccess == false {
            dispatch_async(dispatch_get_main_queue(), { 
                ProgressHUD.hideAfterFailOnView(self.view)
            })
        }
    }
    
    func downloader(downloader: LFDownloader, didFinishWithData data: NSData) {
        
        if downloader.type == .Detail {
            //详情数据
            self.parseDetailData(data)
            
            detailSuccess = true
            
        }else if downloader.type == .NearBy {
            //附近的数据
            self.parseNearByData(data)
            nearBySuccess = true
        }
        
        if detailSuccess == false && nearBySuccess == false {
            
        }else {
            
            dispatch_async(dispatch_get_main_queue(), { 
                ProgressHUD.hideAfterSuccessOnView(self.view)
            })
        }
        
    }
  
}
    
//MARK:CLLocationManager的代理

extension DetailViewController:CLLocationManagerDelegate{
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let loc = locations.last
        //如果有经纬度 ，就可以获取附近的数据
        if loc?.coordinate.latitude != nil && loc?.coordinate.longitude != nil && (isNearbyDownload != true ) {
            
            //请求附近数据
            let urlString = String(format: kNearByUrl, (loc?.coordinate.latitude)!,(loc?.coordinate.longitude)!)
            
            let d = LFDownloader()
            d.delegate = self
            d.type = .NearBy
            d.downloadWithURLString(urlString)
            //结束定位
            manager.stopUpdatingLocation()
            
            isNearbyDownload = true
            
            
        }
        
        
    }
    
    
}
       