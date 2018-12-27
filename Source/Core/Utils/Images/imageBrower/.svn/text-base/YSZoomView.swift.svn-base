//
//  YSZoomView.swift
//  图片浏览Swift
//
//  Created by 张延深 on 16/5/6.
//  Copyright © 2016年 宜信. All rights reserved.
//  图片预览控件

import UIKit

open class YSZoomView: UIControl, UIScrollViewDelegate {
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    private let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    private let maxScale: CGFloat = 3.0 // 最大的缩放比例
    private let minScale: CGFloat = 1.0 // 最小的缩放比例
    
    private let animDuration: TimeInterval = 0.2 // 动画时长
    
    // MARK: - Public property
    
    // 图片开始时的frame
    open var originFrame: CGRect = CGRect.zero
    
    //回调返回
    var back: (() -> Void)?
    // 要显示的图片
    open var image: UIImage? {
        didSet {
            if let _image = image {
                if self.originFrame == CGRect.zero {
                    let imageViewH = _image.size.height / _image.size.width * screenWidth
                    self.imageView?.bounds = CGRect(x: 0, y: 0, width: screenWidth, height: imageViewH)
                    self.imageView?.center = (mscrollView?.center)!
                } else {
                    self.imageView?.frame = self.originFrame
                }
                self.imageView?.image = image
            }
        }
    }

    // MARK: - Private property
    
    var mscrollView: UIScrollView?
    var imageView: UIImageView?
    
    private var scale: CGFloat = 1.0 // 当前的缩放比例
    private var touchX: CGFloat = 0.0 // 双击点的X坐标
    private var touchY: CGFloat = 0.0 // 双击点的Y坐标
    
    private var isDoubleTapingForZoom: Bool = false // 是否是双击缩放
    
    // MARK: - Life cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        // 初始化View
        self.initAllView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIScrollViewDelegate
    
    open func scrollViewDidZoom(_ scrollView: UIScrollView) {
        //当捏或移动时，需要对center重新定义以达到正确显示位置
        var centerX = scrollView.center.x
        var centerY = scrollView.center.y
        centerX = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width / 2 : centerX
        centerY = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height / 2 : centerY
        
        self.imageView?.center = CGPoint(x: centerX, y: centerY)
        
        // ****************双击放大图片关键代码*******************
        
        if isDoubleTapingForZoom {
            let contentOffset = self.mscrollView?.contentOffset
            let center = self.center
            let offsetX = center.x - self.touchX
//            let offsetY = center.y - self.touchY
            self.mscrollView?.contentOffset = CGPoint(x: (contentOffset?.x)! - offsetX * 2.2, y: (contentOffset?.y)!)
        }
        
        // ****************************************************
        
    }
    
    open func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.scale = scale
    }
    
    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView!
    }
    
    // MARK: - Event response
    // 单击手势事件
    @objc func singleTapClick(_ tap: UITapGestureRecognizer) {
        if scale == 1.0{
            back?()
        }else{
            self.mscrollView?.setZoomScale(self.minScale, animated: true)
        }

//        UIView.animateWithDuration(self.animDuration, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
//                self.imageView?.frame = self.originFrame
//                self.scrollView?.backgroundColor = UIColor.clearColor()
//                // 把keyWindow的windowLevel设置为UIWindowLevelNormal
//                UIApplication.sharedApplication().keyWindow?.windowLevel = UIWindowLevelNormal
//            }) { (finished) in
//                self.alpha = 0
//                self.scrollView?.backgroundColor = UIColor.blackColor()
//                self.originFrame = CGRectZero
//                self.scale = self.minScale
//                self.removeFromSuperview()
//                // 把keyWindow的windowLevel设置为UIWindowLevelNormal
////                UIApplication.sharedApplication().keyWindow?.windowLevel = UIWindowLevelNormal
//        }
    }
    
    // 双击手势事件
    @objc func doubleTapClick(_ tap: UITapGestureRecognizer) {
        self.touchX = tap.location(in: tap.view).x
        self.touchY = tap.location(in: tap.view).y
        
        if self.scale > 1.0 {
            self.scale = 1.0
            self.mscrollView?.setZoomScale(self.scale, animated: true)
        } else {
            self.scale = maxScale
            self.isDoubleTapingForZoom = true
            self.mscrollView?.setZoomScale(maxScale, animated: true)
        }
        self.isDoubleTapingForZoom = false
        
    }
    
    // MARK: - Private methods
    
    private func initAllView() {
        // UIScrollView
        self.mscrollView = UIScrollView()
        self.mscrollView?.showsVerticalScrollIndicator = false
        self.mscrollView?.showsHorizontalScrollIndicator = false
        self.mscrollView?.maximumZoomScale = maxScale // scrollView最大缩放比例
        self.mscrollView?.minimumZoomScale = minScale // scrollView最小缩放比例
        self.mscrollView?.backgroundColor = UIColor.black
        self.mscrollView?.delegate = self
        self.mscrollView?.frame = self.bounds
        self.addSubview(self.mscrollView!)
        
        // 添加手势
        // 1.单击手势
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(YSZoomView.singleTapClick(_:)))
        singleTap.numberOfTapsRequired = 1
        self.mscrollView?.addGestureRecognizer(singleTap)
        // 2.双击手势
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(YSZoomView.doubleTapClick(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.mscrollView?.addGestureRecognizer(doubleTap)
        // 必须加上这句，否则双击手势不管用
        singleTap.require(toFail: doubleTap)
        
        // UIImageView
        self.imageView = UIImageView()
        self.imageView?.contentMode = .scaleAspectFit
        self.imageView?.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        self.mscrollView?.addSubview(self.imageView!)
    }
    
    // MARK: - Public methods
    
    open func show() {
        if self.image == nil{
            return
        }
        
        self.mscrollView?.setZoomScale(self.minScale, animated: false)

        
        self.imageView?.bounds = CGRect(x: 0, y: 0, width: self.screenWidth, height: self.image!.size.height / self.image!.size.width * self.screenWidth)
        self.imageView?.center = (self.mscrollView?.center)!
    }
}
