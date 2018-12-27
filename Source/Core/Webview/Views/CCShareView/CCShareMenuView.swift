//
//  CCShareMenuView.swift
//  CCAPPTest
//
//  Created by 廖望 on 2017/9/27.
//  Copyright © 2017年 Enn. All rights reserved.
//

import UIKit

enum ShareMenuBlockType {
    case WeiXinShareType
    case PenYouQuanShareType
    case QQShareType
    case QzoneShareType
    case SinaShareType
    case RefreshType
    case CopyUrlType
    case OpenUrlType
}

public class CCShareMenuView: UIView {
    // 回调
    var shareViewCallBackBlock: ((ShareMenuBlockType) -> Void)?
    
    let menuViewHeight = UIScreen.main.bounds.width/375.0*235.0
    var menuView: UIView!
    var collectionView1: UICollectionView!
    var collectionView2: UICollectionView!
    let dataArray1 = ["微信","朋友圈","QQ","QQ空间","微博"]
    let dataArray2 = ["刷新","复制链接","浏览器打开"]
    let imgArray1 = ["ccshare_weichat@2x","ccshare_friend@2x","ccshare_QQ@2x","ccshare_zone@2x","ccshare_weibo@2x"]
    let imgArray2 = ["ccshare_refresh@2x","ccshare_link@2x","ccshare_browser@2x"]
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let tapView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height-menuViewHeight))
        tapView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismissView)))
        self.addSubview(tapView)
        menuView = UIView.init(frame: CGRect.init(x: 0, y: self.frame.height, width: self.frame.width, height: menuViewHeight))
        menuView.backgroundColor = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        self.addSubview(menuView)
        self.customUI()
        self.alpha = 0
    }
    
    deinit {
        print("分享view释放了")
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 显示view
    public func showView() {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.addSubview(self)
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 1
                self.menuView.frame = CGRect.init(x: 0, y: self.frame.height-self.menuViewHeight, width: self.frame.width, height: self.menuViewHeight)
            }) { (finished: Bool) in
                
            }
        }
        
    }
    
    //MARK: 移除view
    @objc func dismissView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            self.menuView.frame = CGRect.init(x: 0, y: self.frame.height, width: self.frame.width, height: self.menuViewHeight)
        }) { (over) in
            if over{
                self.removeFromSuperview()
            }
        }
    }
    
    //MARK: 布局
    private func customUI() {
        let bl: CGFloat = UIScreen.main.bounds.width/375.0
        let itemWidth = bl*61.0
        let itemHeight = bl*79.0
        let layout1 = UICollectionViewFlowLayout.init()
        layout1.itemSize = CGSize.init(width: itemWidth, height: itemHeight)
        layout1.scrollDirection = .horizontal
        layout1.minimumInteritemSpacing = (ScreenWidth - 30.0*bl - itemWidth*5.0)/4.0
        layout1.sectionInset = UIEdgeInsets.init(top: 25.0*bl, left: 0, bottom: 0, right: 0)
        collectionView1 = UICollectionView.init(frame: CGRect.init(x: 15.0*bl, y: 0, width: self.frame.width-30.0*bl, height: itemHeight + 25.0*bl), collectionViewLayout: layout1)
        collectionView1.delegate = self
        collectionView1.dataSource = self
        collectionView1.register(CCShareCollectionViewCell.self, forCellWithReuseIdentifier: "CCShareCollectionViewCellIDE")
        menuView.addSubview(collectionView1)
        collectionView1.backgroundColor = UIColor.clear
        
        let layout2 = UICollectionViewFlowLayout.init()
        layout2.itemSize = CGSize.init(width: itemWidth, height: itemHeight)
        layout2.scrollDirection = .horizontal
        layout2.minimumInteritemSpacing = (ScreenWidth - 30.0*bl - itemWidth*5.0)/4.0
        layout2.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 25.0*bl, right: 0)
        collectionView2 = UICollectionView.init(frame: CGRect.init(x: 15.0*bl, y: menuViewHeight/2, width: self.frame.width-30.0*bl, height: menuViewHeight-collectionView1.height()), collectionViewLayout: layout2)
        collectionView2.delegate = self
        collectionView2.dataSource = self
        collectionView2.register(CCShareCollectionViewCell.self, forCellWithReuseIdentifier: "CCShareCollectionViewCellIDE")
        menuView.addSubview(collectionView2)
        collectionView2.backgroundColor = UIColor.clear
        
    }
    
}

extension CCShareMenuView: UICollectionViewDataSource, UICollectionViewDelegate {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === collectionView1 {
            return dataArray1.count
        } else {
            return dataArray2.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CCShareCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCShareCollectionViewCellIDE", for: indexPath) as! CCShareCollectionViewCell
        if collectionView === collectionView1 {
            cell.refreshShareCell(imgName: imgArray1[indexPath.item], textName: dataArray1[indexPath.item])
        } else {
            cell.refreshShareCell(imgName: imgArray2[indexPath.item], textName: dataArray2[indexPath.item])
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === collectionView1 {
            switch indexPath.item {
            case 0:
                self.shareViewCallBackBlock?(ShareMenuBlockType.WeiXinShareType)
            case 1:
                self.shareViewCallBackBlock?(ShareMenuBlockType.PenYouQuanShareType)
            case 2:
                self.shareViewCallBackBlock?(ShareMenuBlockType.QQShareType)
            case 3:
                self.shareViewCallBackBlock?(ShareMenuBlockType.QzoneShareType)
            case 4:
                self.shareViewCallBackBlock?(ShareMenuBlockType.SinaShareType)
            default:
                break
            }
        } else{
            switch indexPath.item {
            case 0:
                self.shareViewCallBackBlock?(ShareMenuBlockType.RefreshType)
            case 1:
                self.shareViewCallBackBlock?(ShareMenuBlockType.CopyUrlType)
            case 2:
                self.shareViewCallBackBlock?(ShareMenuBlockType.OpenUrlType)
            default:
                break
            }
        }
        self.dismissView()
    }
    
}

