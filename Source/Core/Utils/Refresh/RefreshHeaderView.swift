//
//  RefreshHeaderView.swift
//  iOSBasisComponents
//
//  Created by 道浪 on 2017/8/25.
//  Copyright © 2017年 enn. All rights reserved.
//

import UIKit
class RefreshHeaderView: RefreshBaseView {
    class func footer(_ width: CGFloat)->RefreshHeaderView{
        let footer:RefreshHeaderView  = RefreshHeaderView(frame: CGRect(x: 0, y: 0, width: width,  height: CGFloat(RefreshViewHeight)))
        return footer
    }
    
    // 最后的更新时间
    var lastUpdateTime:Date = Date(){
    willSet{
        
    }
    didSet{
        UserDefaults.standard.set(lastUpdateTime, forKey: RefreshHeaderTimeKey as String)
        UserDefaults.standard.synchronize()
    }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func willMove(toSuperview newSuperview: UIView!) {
        super.willMove(toSuperview: newSuperview)
         // 设置自己的位置和尺寸
        var rect:CGRect = self.frame
        rect.origin.y = -self.frame.size.height
        self.frame = rect
    }
    
    
    //监听UIScrollView的contentOffset属性
    override  func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (!self.isUserInteractionEnabled || self.isHidden){
            return
        }
        if (self.State == RefreshState.refreshing) {
            return
        }
        if RefreshContentOffset.isEqual(to: keyPath!){
            self.adjustStateWithContentOffset()
        }
    }
    
   
    
   
    
    //调整状态
    func adjustStateWithContentOffset()
    {
        let currentOffsetY:CGFloat = self.scrollView.contentOffset.y
        let happenOffsetY:CGFloat = -self.scrollViewOriginalInset.top
        if (currentOffsetY >= happenOffsetY) {
            return
        }
        if self.scrollView.isDragging{
            let normal2pullingOffsetY:CGFloat = happenOffsetY - self.frame.size.height
            if  self.State == RefreshState.normal && currentOffsetY < normal2pullingOffsetY{
                self.State = RefreshState.pulling
            }else if self.State == RefreshState.pulling && currentOffsetY >= normal2pullingOffsetY{
                self.State = RefreshState.normal
            }
            
        } else if self.State == RefreshState.pulling {
            self.State = RefreshState.refreshing
        }
    }
    
    //设置状态
    override  var State:RefreshState {
    willSet {
        if  State == newValue{
            return;
        }
        oldState = State
        setState(newValue)
    }
    didSet{
        switch State{
        case .normal:
//            self.statusLabel.text = RefreshHeaderPullToRefresh as String
            if RefreshState.refreshing == oldState {
//                self.arrowImage.transform = CGAffineTransform.identity
                self.lastUpdateTime = Date()
                UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: {
                    var contentInset:UIEdgeInsets = self.scrollView.contentInset
                    contentInset.top = self.scrollViewOriginalInset.top
                    self.scrollView.contentInset = contentInset
                    },completion: { (over: Bool) -> Void in
                        if over{
                            if let collection = self.scrollView as? UICollectionView{
                                collection.reloadData()
                            }
                        }
                })
                
            }else {
                UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: {
//                     self.arrowImage.transform = CGAffineTransform.identity
                    })
            }
            break
        case .pulling:

            break
        case .refreshing:

            UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: {
                let top:CGFloat = self.scrollViewOriginalInset.top + self.frame.size.height
                var inset:UIEdgeInsets = self.scrollView.contentInset
                inset.top = top
                self.scrollView.contentInset = inset
                var offset:CGPoint = self.scrollView.contentOffset
                offset.y = -top
                self.scrollView.contentOffset = offset
            })

            break
        default:
            break
            
        }
    }
    }
    
    func addState(_ state:RefreshState){
        self.State = state
    }
}
    
