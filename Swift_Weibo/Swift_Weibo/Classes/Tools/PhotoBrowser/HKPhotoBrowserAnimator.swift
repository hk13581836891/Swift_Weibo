//
//  HKPhotoBrowserAnimator.swift
//  Swift_Weibo
//
//  Created by houke on 2018/12/25.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
//MARK: - 展现动画协议
protocol HKPhotoBrowserPresentDelegate:NSObjectProtocol {
    
    /// 指定 indexPath 对应的 imageView,用来做动画效果
    func imageViewForPresent(indexPath:IndexPath) -> UIImageView
    
    /// 动画转场的起始位置
    func photoBrowserPresentFromRect(indexPath:IndexPath) ->CGRect
    
    /// 动画转场的目标位置
    func photoBrowserPresentToRect(indexPath:IndexPath) ->CGRect
}

//MARK: - 提供动画转场的‘代理’
class HKPhotoBrowserAnimator: NSObject, UIViewControllerTransitioningDelegate {
    
    //是否 modal展现的标记
    private var isPresented = false
    
    //返回提供（modal 展现）‘动画的对象’ - UIViewControllerAnimatedTransitioning
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    //返回提供dismiss‘动画的对象’
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
//实现具体的动画方法
extension HKPhotoBrowserAnimator : UIViewControllerAnimatedTransitioning{
    //动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
    ///实现具体动画效果 - 一旦实现了此方法，所有的动画代码都交由程序员负责
    ///
    /// - Parameter transitionContext: 转场动画的上下文 - 提供动画所需要的素材
    /**
     转场动画的上下文 提供的素材
     1.容器视图containerView - 会将 modal要展现的视图包装在容器视图中
        存放的视图要显示-必须自己制定大小，不会通过自动布局填满屏幕
     2. viewControllerForKey: fromVC / toVC
     3. viewForKey:fromView / toView
     4. completeTransition:无论转场是否被取消，都必须调用，否则，系统不做其他事件处理
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //自动布局系统不会对根视图做任何约束,如果 view 没有指定 frame,视图则不会显示
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        print(fromVC as Any)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        print(toVC as Any)
        
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        print(fromView as Any)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        print(toView as Any)
        
        isPresented ? presenAnimation(transitionContext: transitionContext) : dismissAnimation(transitionContext: transitionContext)
        
    }
    //解除转场动画
    private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {
        //1.获取要 dismiss的控制器的视图
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView?.alpha = 0
        }) { (_) in
            //将 from从父视图中移除
            fromView?.removeFromSuperview()
            //告诉系统转场动画完成
            transitionContext.completeTransition(true)
        }
    }
    private func presenAnimation(transitionContext: UIViewControllerContextTransitioning) {
        
        //1.获取 modal 要展现的控制器的视图
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        //2.将视图添加到容器视图中
        transitionContext.containerView.addSubview(toView)
        toView.alpha = 0
        
        //3 开始动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.alpha = 1
        }) { (_) in
            //告诉系统转场动画完成
            transitionContext.completeTransition(true)
        }
    }
}
