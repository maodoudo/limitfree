import UIKit

protocol CollectButtonDelegate: NSObjectProtocol {
    
    //删除
    func didDeleteBtnAtIndex(index: Int)
    
}


class CollectButton: UIControl {
    
    //代理属性
    weak var delegate: CollectButtonDelegate?
    
    //图片
    private var imageView: UIImageView?
    //标题
    private var titleLabel: UILabel?
    //删除按钮
    private var deleteBtn: UIButton?
    
    //按钮的序号
    var btnIndex: Int?
    
    //数据
    var model: CollectModel? {
        didSet {
            //显示数据
            //1.图片
            imageView?.image = model?.headImage
            //2.文字
            titleLabel?.text = model?.name
        }
    }
    
    
    //删除状态
    var isDelete: Bool? {
        didSet {
            if isDelete == true {
                //进入删除状态
                deleteBtn?.hidden = false
            }else if isDelete == false {
                //退出删除状态
                deleteBtn?.hidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        
        var tmpFrame = frame
        tmpFrame.size = CGSizeMake(80, 100)
        super.init(frame: tmpFrame)
        
        //1.图片
        imageView = UIImageView(frame: CGRectMake(20, 20, 60, 60))
        addSubview(imageView!)
        
        //2.文字
        titleLabel = UILabel.createLabelFrame(CGRectMake(20, 80, 60, 20), title: nil, textAlignment: .Center)
        titleLabel?.font = UIFont.systemFontOfSize(12)
        addSubview(titleLabel!)
        
        //3.删除按钮
        deleteBtn = UIButton.createBtn(CGRectMake(0, 0, 40, 40), title: nil, bgImageName: "close", target: self, action: #selector(deleteAction))
        addSubview(deleteBtn!)
        //默认隐藏
        deleteBtn?.hidden = true
    }
    
    //删除操作
    func deleteAction(){
        
        delegate?.didDeleteBtnAtIndex(btnIndex!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


