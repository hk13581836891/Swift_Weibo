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
//MARK: - 解除动画协议
protocol HKPhotoBrowserDismissDelegate:NSObjectProtocol {
    
    //解除转场图像视图（包含起始位置）
    func imageViewForDismiss() -> UIImageView
    //解除转场图像索引
    func indexPathForDismiss() -> IndexPath
}
//MARK: - 提供动画转场的‘代理’
class HKPhotoBrowserAnimator: NSObject, UIViewControllerTransitioningDelegate {
    
    //展现代理
    weak var presentDelegate: HKPhotoBrowserPresentDelegate?
    //解除动画转场代理
    weak var dismissDelegate: HKPhotoBrowserDismissDelegate?
    //动画图像索引
    var indexPath:IndexPath?
    //是否 modal展现的标记
    private var isPresented = false
    
    
    /// 设置代理相关参数
    ///
    /// - Parameters:
    ///   - presentDelegate: 展现代理对象
    ///   - indexPath: 图像索引
    func setDelegateParams(presentDelegate:HKPhotoBrowserPresentDelegate,
                           indexPath:IndexPath,
                           dismissDelegate: HKPhotoBrowserDismissDelegate) {
        
        self.presentDelegate = presentDelegate
        self.dismissDelegate = dismissDelegate
        self.indexPath = indexPath
    }
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
        return 0.5
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
        
        guard let presentDelegate = presentDelegate , let dismissDelegate = dismissDelegate else {
            return
        }
        //1.获取要 dismiss的控制器的视图
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        fromView?.removeFromSuperview()
        
        //2 获取图像视图
        let iv = dismissDelegate.imageViewForDismiss()
        transitionContext.containerView.addSubview(iv)
        
        //3 获取 dismiss的 indexPath
        let indexPath = dismissDelegate.indexPathForDismiss()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            //让 iv运动到目标位置
            iv.frame = presentDelegate.photoBrowserPresentFromRect(indexPath: indexPath)
        }) { (_) in
            //将iv从父视图中移除
            iv.removeFromSuperview()
            //告诉系统转场动画完成
            transitionContext.completeTransition(true)
        }
    }
    //展现动画
    private func presenAnimation(transitionContext: UIViewControllerContextTransitioning) {
        
        //判断参数是否存在
        guard let presentDelegate = presentDelegate, let indexPath = indexPath else {
            return
        }
        //目标视图
        //1.获取 modal 要展现的控制器的视图
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        //2.将视图添加到容器视图中
        transitionContext.containerView.addSubview(toView)
        
        //图像视图
        //0 能够拿到参与动画的图像视图、、目标位置
        let iv = presentDelegate.imageViewForPresent(indexPath: indexPath)
        //起始位置
        iv.frame = presentDelegate.photoBrowserPresentFromRect(indexPath: indexPath)
        transitionContext.containerView.addSubview(iv)
        
        toView.alpha = 0
        
        //3 开始动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            iv.frame = presentDelegate.photoBrowserPresentToRect(indexPath: indexPath)
            toView.alpha = 1
        }) { (_) in
            //将图像视图删除
            iv.removeFromSuperview()
            //告诉系统转场动画完成
            transitionContext.completeTransition(true)
        }
    }
}
