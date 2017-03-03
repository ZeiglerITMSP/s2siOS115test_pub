//
//  FZURefreshExtension.swift
//  FZURefresh
//
//  Created by 吴浩文 on 15/8/2.
//  Copyright (c) 2015年 吴浩文. All rights reserved.
//

import UIKit

let kFZURefreshHeadTag = 101
let kFZURefreshFootTag = 102

let kFZURefreshHeadViewHeight: CGFloat = 50
let kFZURefreshFootViewHeight: CGFloat = 80

public extension UIScrollView {
    
    //下拉刷新
    func toRefresh(_ action :@escaping (() -> ())) {
        self.alwaysBounceVertical = true
        
        let headView:FZURefreshHead = FZURefreshHead(action: action,frame: CGRect(x: 0, y: -kFZURefreshHeadViewHeight, width: frame.size.width, height: kFZURefreshHeadViewHeight),scrollView: self)
        headView.tag = kFZURefreshHeadTag
        addSubview(headView)
        headView.autoresizingMask = .flexibleWidth
    }
    
    //上拉加载更多
    func toLoadMore(_ action :@escaping (() -> ())) {
        alwaysBounceVertical = true
        
        let footView = FZURefreshFoot(action: action, scrollView: self)
        footView.tag = kFZURefreshFootTag
        addSubview(footView)
    }
    
    //MARK: 立即下拉刷新
    func nowRefresh(_ action :(() -> ())? = nil)
    {
        guard let headerView = self.viewWithTag(kFZURefreshHeadTag) as? FZURefreshHead else {
            if let action = action {
                toRefresh(action)
                self.nowRefresh(action)
            }
            return
        }
        
        headerView.start()
    }
    
    //MARK: 数据加载完毕
    func endLoadMore() {
        if let footView = self.viewWithTag(kFZURefreshFootTag) as? FZURefreshFoot {
            footView.refreshStatus = .end
            footView.isHidden = true    // MARK: - APPIT
        }
    }
    
    //MARK: 完成刷新
    func doneRefresh() {
        if let headerView = self.viewWithTag(kFZURefreshHeadTag) as? FZURefreshHead {
            headerView.stopAnimation()
        }
        if let footView = self.viewWithTag(kFZURefreshFootTag) as? FZURefreshFoot {
            footView.refreshStatus = .normal
            footView.activityView.stopAnimating()
        }
    }
    
}

