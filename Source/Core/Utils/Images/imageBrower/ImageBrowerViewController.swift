//
//  ImageBrowerViewController.swift
//  QuShow
//
//  Created by daolang.huang on 16/8/30.
//  Copyright © 2016年 DL. All rights reserved.
//

import UIKit
import SDWebImage

class ImageBrowerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var imgs: [Any]!
    var imgType: CCImageType = .imageName
    var position = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
        
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: ScreenWidth, height: ScreenHeight)
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.minimumLineSpacing = 0//每个相邻layout的上下
        flowLayout.minimumInteritemSpacing = 0//每个相邻layout的左右
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        let collection_image = UICollectionView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), collectionViewLayout: flowLayout)
        collection_image.isPagingEnabled = true
        collection_image.delegate = self
        collection_image.dataSource = self
        collection_image.tag = 1001
        collection_image.backgroundColor = UIColor.clear
        collection_image.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
        collection_image.showsHorizontalScrollIndicator = false
        
        self.view.addSubview(collection_image)
        
        collection_image.contentOffset.x = CGFloat(position)*ScreenWidth
        
        addPageControl()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: collection 代理
    func addPageControl(){
        let pageControl = UIPageControl(frame: CGRect( x: 0, y: ScreenHeight - 30, width: ScreenWidth, height: 30))
        // 设置非选中页的圆点颜色
        pageControl.pageIndicatorTintColor = BackgroundColor
        // 设置选中页的圆点颜色
        pageControl.currentPageIndicatorTintColor = UIColor.colorWithHexString("49c6d8")
        pageControl.hidesForSinglePage = true
        pageControl.isEnabled = false
        pageControl.numberOfPages = imgs.count
        pageControl.tag = 101
        pageControl.currentPage = position
        pageControl.alpha = 0.6
        
        self.view.addSubview(pageControl)
        
//        let btn_save = UIButton()
//        btn_save.frame = CGRect(x: 0, y: ScreenHeight - 70, width: ScreenWidth, height: 40)
//        btn_save.setTitle("保存到相册", for: UIControlState())
//        btn_save.setTitleColor(UIColor.colorWithHexString("49c6d8"), for: UIControlState())
//        btn_save.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        btn_save.addTarget(self, action: #selector(ImageBrowerViewController.savePhoto), for: UIControlEvents.touchUpInside)
//        
//        self.view.addSubview(btn_save)
    }
    
    //保存照片
    @objc func savePhoto(){
        if let collection = self.view.viewWithTag(1001) as? UICollectionView{
            let util = ImageUtil()
            //当前索引
            let index = Int((collection.contentOffset.x)/ScreenWidth)
            var img: UIImage!
            switch imgType{
            case .imageName:
                guard let imageName = imgs[index] as? String else{
                    break
                }
                img = UIImage.init(named: imageName)
            case .imagePath:
                guard let imagePath = imgs[index] as? String else{
                    break
                }
                img = UIImage.init(contentsOfFile: imagePath)
            case .imageUrl:
                guard let imageUrlStr = imgs[index] as? String else{
                    break
                }
                var imgFromCache = SDImageCache.init().imageFromMemoryCache(forKey: imageUrlStr)
                
                if imgFromCache == nil{
                    imgFromCache = SDImageCache.init().imageFromDiskCache(forKey: imageUrlStr)
                }
                
                img = imgFromCache
            case .uiImage:
                guard let image = imgs[index] as? UIImage else{
                    break
                }
                img = image
            }
            if img != nil{
                util.saveImgs([img])
            }
        }
    }
    func getImage(_ url: String) -> UIImage{
        let image = UIImage(contentsOfFile: url)
        
        if image == nil{
            return UIImage()
        }
        
        return image!
    }
    
    
    //存储图片至指定相册中
    //MARK: collection delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        var img: YSZoomView!
        if cell.viewWithTag(10001) == nil{
            img = YSZoomView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
            img.tag = 10001
            img.back = {[weak self] in
                self?.pop()
            }
            
            cell.addSubview(img)
        }else{
            img = cell.viewWithTag(10001) as! YSZoomView
        }
        
        let index = indexPath.row
        
        switch imgType{
        case .imageName:
            guard let imageName = imgs[index] as? String else{
                break
            }
            img.image = UIImage.init(named: imageName)
        case .imagePath:
            guard let imagePath = imgs[index] as? String else{
                break
            }
            
            img.image = UIImage.init(contentsOfFile: imagePath)
        case .imageUrl:
            guard let imageUrlStr = imgs[index] as? String else{
                break
            }
            
            img.imageView?.sd_setImage(with: URL.init(string: imageUrlStr))
        case .uiImage:
            guard let image = imgs[index] as? UIImage else{
                break
            }
            img.image = image
        }
        
        return cell
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == 1001{
            let page: Int = Int((scrollView.contentOffset.x)/ScreenWidth)
            //    DLog(@"%d", page);
            // 设置页码
            if let pageControl = self.view.viewWithTag(101) as? UIPageControl{
                pageControl.currentPage = Int(page)
            }
        }
    }
    
    public func pop() {
        weak var weakself = self
        weakself?.modalTransitionStyle = .crossDissolve
        weakself?.dismiss(animated: true, completion: nil)
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

