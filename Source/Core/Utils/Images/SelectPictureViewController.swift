//
//  SelectPictureViewController.swift
//  QuShow
//
//  Created by daolang.huang on 16/8/22.
//  Copyright © 2016年 DL. All rights reserved.
//

import UIKit
import AssetsLibrary

class SelectPictureViewController: IBCBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {
    //预览图
    private var collection: UICollectionView!
    private let cellId = "cellId"
    //每个预览图片的宽度
    private let itemWidth = (ScreenWidth - 9*5 - 1)/4
    //预览图数据
    private var imageArray = NSMutableArray()
    //相册列表
    private var imageGroupArray = NSMutableArray(capacity: 1)
    //资源库管理类
    private var assetsLibrary = ALAssetsLibrary()
    //相片群组选择
    private var groupSelectView: UIVisualEffectView!
    //选中索引
    private var selectIndexs = NSMutableArray()
    //tableViewCell id
    private let tableCellId = "tableCellId"
    //回调
    var callBack: (([UIImage]) -> Void)?
    //选择类型
    var isSelectPhoto = true
    //最大选择张数
    var maxCount = 9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
        assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupAll, usingBlock: {[weak self] (group: ALAssetsGroup?, stop: UnsafeMutablePointer<ObjCBool>?) in
            if group != nil{
                self?.imageGroupArray.add(group!)
            }else{
                self?.groupSelectInit()
            }
            
            }, failureBlock:  { (fail) in
                print(fail ?? "")
        })
        navigatorInit()
        collectionInit()
    }
    deinit {
        print("选择照片控制器释放了")
    }
    
    func navigatorInit(){
        
        let cancel = UIButton()
        cancel.frame = CGRect(x: 0, y: StatusHeight, width: 40, height: 44)
        cancel.setImage(UIImage.bundleImage(bundleClass: SelectPictureViewController.self, bundleName: "Core", imageName: "cancle@2x"), for: UIControlState())
        cancel.addTarget(self, action: #selector(SelectPictureViewController.cancel), for: UIControlEvents.touchUpInside)
        view.addSubview(cancel)
        
        let next = UIButton()
        next.frame = CGRect(x: ScreenWidth - 70, y: StatusHeight, width: 70, height: 44)
        next.setTitle("完成", for: UIControlState())
        next.setTitleColor(UIColor.white, for: UIControlState())
        next.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        next.addTarget(self, action: #selector(SelectPictureViewController.nextStep), for: UIControlEvents.touchUpInside)
        
        view.addSubview(next)
    }
    
    func groupSelectInit(){
        if imageGroupArray.count == 0{
            return
        }
        if self.view.viewWithTag(1002) != nil{
            return
        }
        
        var numberOfAsset = 0
        var group_now: ALAssetsGroup!
        for i in 0 ..< imageGroupArray.count {
            let group = imageGroupArray.object(at: i) as! ALAssetsGroup
            
            if group.numberOfAssets() > numberOfAsset{
                numberOfAsset = group.numberOfAssets()
                group_now = group
            }
        }
        if group_now != nil{
            getPhotos(group_now)
            
            groupSelectView = iOS8blurAction(CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
            self.view.addSubview(groupSelectView)
            groupSelectView.isHidden = true
            
            let tableView = UITableView()
            tableView.frame = CGRect(x: 0, y: NavigationBarHeight, width: ScreenWidth, height: ScreenHeight - NavigationBarHeight)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorColor = UIColor.clear
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCellId)
            tableView.backgroundColor = UIColor.clear
            
            groupSelectView.contentView.addSubview(tableView)
            
            let btn = UIButton()
            btn.frame = CGRect(x: ScreenWidth/2 - 100, y: StatusHeight, width: 200, height: 44)
            btn.setTitle(group_now.value(forProperty: ALAssetsGroupPropertyName) as? String, for: UIControlState())
            btn.setTitleColor(UIColor.white, for: UIControlState())
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.tag = 1002
            btn.addTarget(self, action: #selector(self.showSelect), for: UIControlEvents.touchUpInside)
            self.view.addSubview(btn)
        }else{
            cancel()
        }
    }
    
    func collectionInit(){
        //头部图片轮播
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 9, 0, 9)
        flowLayout.minimumLineSpacing = 9//每个相邻layout的上下
        flowLayout.minimumInteritemSpacing = 9//每个相邻layout的左右
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        collection = UICollectionView(frame: CGRect(x: 0, y: NavigationBarHeight, width: ScreenWidth, height: ScreenHeight - NavigationBarHeight), collectionViewLayout: flowLayout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.clear
        collection.scrollsToTop = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        self.view.addSubview(collection)
    }
    //获取所有相册图片
    func getPhotos(_ group: ALAssetsGroup){
        self.imageArray.removeAllObjects()
        //ALAssetsGroupSavedPhotos表示只读取相机胶卷（ALAssetsGroupAll则读取全部相簿）
        let assetBlock : ALAssetsGroupEnumerationResultsBlock = { [weak self]
            (result: ALAsset?, index: Int, stop) in
            if result != nil
            {
                if self!.isSelectPhoto{
                    if !self!.isVideo(result!){
                        self?.imageArray.add(result!)
                    }
                }else{
                    self?.imageArray.add(result!)
                }
                
            }
        }
        group.enumerateAssets(assetBlock)
        imageArray = NSMutableArray(array: imageArray.reversed())
        //collectionView网格重载数据
        self.collection.reloadData()
    }
    //MARK: 点击事件
    @objc func cancel(){
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //下一步
    @objc func nextStep(){
        DispatchQueue.global().async(execute: {
            var imgs = [UIImage]()
            for i in 0 ..< self.selectIndexs.count{
                let index = self.selectIndexs.object(at: i) as! Int
                let myAsset = self.imageArray.object(at: index)
                //获取原图
                //获取文件名
                let representation = (myAsset as AnyObject).defaultRepresentation()
                let imageBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: Int((representation?.size())!))
                let bufferSize = representation?.getBytes(imageBuffer, fromOffset: Int64(0),
                                                          length: Int((representation?.size())!), error: nil)
                let data = Data(bytesNoCopy: UnsafeMutablePointer<UInt8>(imageBuffer) ,count:bufferSize!, deallocator: .free)
                
                let img = UIImage.init(data: data)
                
                if img != nil{
                    imgs.append(img!)
                }
            }
            DispatchQueue.main.async(execute: {
                self.callBack?(imgs)
                self.cancel()
            })
        })
    }
    
    //显示隐藏相册群组选择
    @objc func showSelect(){
        if groupSelectView.isHidden{
            groupSelectView.alpha = 0
            groupSelectView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.groupSelectView.alpha = 1
            })
        }else{
            groupSelectView.isHidden = true
        }
    }
    //MARK: collection delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var imageView: UIImageView?
        var img_selected: UIImageView?
        var videoLogo: UIImageView!
        //顶部轮播
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        if(cell.viewWithTag(100001) == nil){
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: itemWidth, height: itemWidth))
            //            imageView?.backgroundColor = SpaceColor
            imageView?.tag = 100001
            imageView?.contentMode = UIViewContentMode.scaleAspectFill
            imageView?.clipsToBounds = true
            imageView?.layer.cornerRadius = 3
            cell.addSubview(imageView!)
            
            videoLogo = UIImageView()
            videoLogo.frame = CGRect(x: 0,y: 0,width: itemWidth,height: itemWidth)
            videoLogo.contentMode = .center
            videoLogo.image = UIImage.bundleImage(bundleClass: SelectPictureViewController.self, bundleName: "Core", imageName: "video@2x")
            videoLogo.tag = 100003
            videoLogo.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            videoLogo.isHidden = true
            
            cell.addSubview(videoLogo)
            
            img_selected = UIImageView()
            img_selected?.frame = CGRect(x: itemWidth - 25, y: itemWidth - 25, width: 22, height: 22)
            img_selected?.image = UIImage.bundleImage(bundleClass: SelectPictureViewController.self, bundleName: "Core", imageName: "pitch@2x")
            img_selected?.tag = 100002
            img_selected?.isHidden = true
            
            cell.addSubview(img_selected!)
            
        }else{
            imageView = cell.viewWithTag(100001) as? UIImageView
            img_selected = cell.viewWithTag(100002) as? UIImageView
            videoLogo = cell.viewWithTag(100003) as! UIImageView
        }
        
        if selectIndexs.contains(indexPath.row){
            img_selected?.isHidden = false
        }else{
            img_selected?.isHidden = true
        }
        
        //取缩略图
        let myAsset = imageArray.object(at: (indexPath as NSIndexPath).row)
        let image = UIImage(cgImage:(myAsset as AnyObject).thumbnail().takeUnretainedValue())
        // 从界面查找到控件元素并设置属性
        imageView?.image = image
        if isVideo(myAsset as! ALAsset){
            videoLogo.isHidden = false
        }else{
            videoLogo.isHidden = true
        }
        
        return cell
    }
    
    func isVideo(_ asset: ALAsset) -> Bool{
        if let key = asset.value(forProperty: ALAssetPropertyType) as? String{
            if key == ALAssetTypeVideo{
                return true
            }
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //选中
        if selectIndexs.index(of: (indexPath as NSIndexPath).row) != NSNotFound{
            let cell = collectionView.cellForItem(at: indexPath)
            if let img_select = cell?.viewWithTag(100002) as? UIImageView{
                img_select.isHidden = true
            }
            
            selectIndexs.remove((indexPath as NSIndexPath).row)
        }else{
            if selectIndexs.count >= maxCount{
                IBCDialogUtil.init(with: IBCHintDialogType.handhide, hintMessage: "最多选择\(maxCount)张").show()

                return
            }
            let cell = collectionView.cellForItem(at: indexPath)
            if let img_select = cell?.viewWithTag(100002) as? UIImageView{
                img_select.isHidden = false
            }
            
            selectIndexs.add((indexPath as NSIndexPath).row)
        }
    }
    //MARK: table delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageGroupArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellId)
        cell?.selectionStyle = .none
        cell?.backgroundColor = UIColor.clear
        
        var imageView: UIImageView?
        var label_name: UILabel?
        var label_count: UILabel?
        
        if cell?.viewWithTag(101) == nil{
            imageView = UIImageView()
            imageView?.frame = CGRect(x: 15, y: 15, width: 50, height: 50)
            imageView?.layer.cornerRadius = 4
            imageView?.clipsToBounds = true
            imageView?.tag = 101
            
            cell?.addSubview(imageView!)
            
            label_name = UILabel()
            label_name?.frame = CGRect(x: 75, y: 15, width: ScreenWidth - 85, height: 25)
            label_name?.font = UIFont.systemFont(ofSize: 15)
            label_name?.textColor = UIColor.white
            label_name?.tag = 102
            
            cell?.addSubview(label_name!)
            
            label_count = UILabel()
            label_count?.frame = CGRect(x: 75, y: 40, width: ScreenWidth - 85, height: 25)
            label_count?.font = UIFont.systemFont(ofSize: 13)
            label_count?.textColor = UIColor.lightGray
            label_count?.tag = 103
            
            cell?.addSubview(label_count!)
        }else{
            imageView = cell?.viewWithTag(101) as? UIImageView
            label_name = cell?.viewWithTag(102) as? UILabel
            label_count = cell?.viewWithTag(103) as? UILabel
        }
        
        let group = imageGroupArray.object(at: (indexPath as NSIndexPath).row) as! ALAssetsGroup
        
        imageView?.image = UIImage(cgImage: group.posterImage().takeUnretainedValue())
        
        label_name?.text = group.value(forProperty: ALAssetsGroupPropertyName) as? String
        
        label_count?.text = "\(group.numberOfAssets())"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let group = imageGroupArray.object(at: (indexPath as NSIndexPath).row) as? ALAssetsGroup{
            getPhotos(group)
            
            if let btn = self.view.viewWithTag(1002) as? UIButton{
                btn.setTitle(group.value(forProperty: ALAssetsGroupPropertyName) as? String, for: UIControlState())
                
                showSelect()
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

