//
//  HomeTableViewController.swift
//  Swift_Weibo
//
//  Created by houke on 2018/8/20.
//  Copyright © 2018年 houke. All rights reserved.
//

import UIKit
import SVProgressHUD
import ReactiveCocoa
import RxSwift
import RxAtomic
import RxCocoa

/// 微博 cell可重用标识符
private let StatusCellNormalId = "StatusCellNormalId"

class HomeTableViewController: VisitorTableViewController {
    
    /// 微博数据列表模型
    private lazy var listViewModel = StatusListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
//                let disposeBag = DisposeBag()
        
//        let btn:UIButton = UIButton()
//        let observer:Binder<String> = Binder(btn) { (btn, text) in
//
//        }
//
//        let observable = Observable<Int>.timer(1, period: 1, scheduler: MainScheduler.instance)
//        observable.map { (n) -> String in
//            return "当前索引是\(n)"
//            }.bind { (_) in
//                btn.isEnabled
//        }
        
//        //这个block有一个回调参数observer就是订阅这个Observable对象的订阅者
//        //当一个订阅者订阅这个Observable对象的时候，就会将订阅者作为参数传入这个block来执行一些内容
//        let observable = Observable<String>.create{observer in
//            //对订阅者发出了.next事件，且携带了一个数据"hangge.com"
//            observer.onNext("hangge.com")
////            //对订阅者发出了.completed事件
////            observer.onCompleted()
////            //因为一个订阅行为会有一个Disposable类型的返回值，所以在结尾一定要returen一个Disposable
//            return Disposables.create()
//            }.subscribe{
//                print($0)
//        }
        
//        let o = Observable.generate(initialState: 0, condition: { (n) -> Bool in
//            n <= 10
//        }) { (m) -> Int in
//            m+3
//            }.subscribe(onNext: { (n) in
//                print(n)
//            })
//
//        let observable = Observable.generate(
//             initialState: 0,
//            condition: { $0 <= 10 },
//             iterate: { $0 + 2 }
//            ).subscribe(onNext: { (n) in
//                print(n)
//            })
        
        
                //Observable序列（每隔1秒钟发出一个索引数）
//                let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        //        let ob = Observable.of("a")
//               let r  = observable.map { print("当前索引数：\($0 )")}
//        print(r)
        //        observable
        //            .map { "当前索引数：\($0 )"}
        //            .bind { [weak self](text) in
        //                //收到发出的索引数后显示到label上
        //                self?.label.text = text
        //            }
        //            .disposed(by: disposeBag)
//    }
    
    /*
     let observable = Observable.of("a", "b", "c")
     
     observable
     .do(onNext: { element in
     print("Intercepted Next：", element)
     }, onError: { error in
     print("Intercepted Error：", error)
     }, onCompleted: {
     print("Intercepted Completed")
     }, onDispose: {
     print("Intercepted Disposed")
     })
     .subscribe(onNext: { element in
     print(element)
     }, onError: { error in
     print(error)
     }, onCompleted: {
     print("completed")
     }, onDisposed: {
     print("disposed")
     })
     
     let r = observable.subscribe(onNext: { (element) in
     print(element)
     }, onError: { (error) in
     print(error)
     }, onCompleted: {
     print("complete")
     }) {
     print("disposed")
     }
     print(r)
     print("--------")
     
     let r1 = observable.subscribe(onNext: { (element) in
     print(element)
     })
     print(r1)
     
     
     observable.subscribe { (event) in
     print(event)
     }.disposed(by: disposeBag)
     //        print(res)
     */
    

        print(Date.sinaDate(string: "Thu Jan 17 16:29:49 +0800 2019")?.dateDescription as Any)
        print(Date.sinaDate(string: "Thu Jan 17 16:10:49 +0800 2019")?.dateDescription as Any)
        print(Date.sinaDate(string: "Thu Jan 17 11:52:49 +0800 2019")?.dateDescription as Any)
        
        print(Date.sinaDate(string: "Thu Jan 16 11:52:49 +0800 2019")?.dateDescription as Any)
        print(Date.sinaDate(string: "Thu Oct 30 11:52:49 +0800 2018")?.dateDescription as Any)
        print(Date.sinaDate(string: "Thu Jan 10 11:52:49 +0800 2018")?.dateDescription as Any)
        
        if !UserAccountViewModel.sharedUserAccount.userLogon {
            visitorView?.setupInfo(imageName: nil, title: "关注一些人，回这里看看有什么惊喜")
            return
        }
        prepareTableView()
        loadData()
        clickEvent()
        
//
//        let tv1 = UITextField(frame: CGRect(x: 50, y: 50, width: 200, height: 30))
//        tv1.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
//        tv1.placeholder = "用户名"
//        view.addSubview(tv1)
//
//        tv1.reactive.signal(for: <#T##Selector#>)
//        tv1.rac_textSignal().subscribeNext { (text) in
//            print(text)
//        }
        
        //注册通知 - 如果使用 block监听，一定需要弱引用
        NotificationCenter.default.addObserver(forName: NSNotification.Name(WBStatusSelectedPhotoNotification), object: nil, queue: nil) { [weak self](n) in
            
            guard let indexPath = n.userInfo?[WBStatusSelectedPhotoIndexPathKey] as? IndexPath else{
                return
            }
            guard let urls = n.userInfo?[WBStatusSelectedPhotoURLsKey] as? [URL] else {
                return
            }
            guard let picView = n.object as? HKPhotoBrowserPresentDelegate else {
                return
            }
            let vc = HKPhotoBrowserViewController(urls: urls, indexPath: indexPath)
            
            //💕💗💕💗💕💗💕💗自定义转场
            //1 设置modal的类型是自定义类型
            vc.modalPresentationStyle = UIModalPresentationStyle.custom
            //2 设置动画代理
            vc.transitioningDelegate = self?.photoBrowserAnimator
            //设置 animator的代理参数
            self?.photoBrowserAnimator.setDelegateParams(presentDelegate: picView, indexPath: indexPath, dismissDelegate:vc)
            //3 modal显示
            self?.present(vc, animated: true, completion: nil)
        }
    }
    deinit {
        //注销通知
        NotificationCenter.default.removeObserver(self)
    }
    
    func prepareTableView()  {
        
//        tableView.register(StatusCell.self, forCellReuseIdentifier: "\(StatusCell.self)")
        tableView.register(StatusRetweetedCell.self, forCellReuseIdentifier: "\(StatusRetweetedCell.self)")
        tableView.register(StatusNormalCell.self, forCellReuseIdentifier: "\(StatusNormalCell.self)")
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        //预估行高
        tableView.estimatedRowHeight = 300
        //自动计算行高 - 需要一个自上而下的自动布局的控件，指定一个向下的约束
//        tableView.rowHeight = UITableViewAutomaticDimension
        
        //下拉刷新控件默认没有 - 高度60
        refreshControl = WBRefreshControl()
        //添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)

        //上拉刷新视图
        tableView.tableFooterView = pullupView
    }
  
    @objc private func loadData()  {
        
        refreshControl?.beginRefreshing()
        listViewModel.loadStatus(isPullup: pullupView.isAnimating) { (isSuccessed) in
            
//            //关闭刷新控件
            self.refreshControl?.endRefreshing()
            //关闭上拉刷新
            self.pullupView.stopAnimating()
            
            if !isSuccessed {
               SVProgressHUD.showInfo(withStatus: "加载数据错误，稍后再试")
                return
            }
            //显示下拉刷新提示
            self.showPulldownTip()
            
            self.tableView.reloadData()
        }
    }
    
    //显示下拉刷新
    func showPulldownTip()  {
        //如果不是下拉刷新直接返回
        guard let count = listViewModel.pulldownCount else {
            return
        }
        let message = count == 0 ? "没有新微博" : "刷新到\(count)条微博"
        pulldownTipLable.text = message
        let height:CGFloat = 44
        let rect = CGRect(x: 0, y: 0, width: view.bounds.width, height: height)
        pulldownTipLable.frame = rect.offsetBy(dx: 0, dy: -2 * height)
        
        UIView.animate(withDuration: 1, animations: {
            self.pulldownTipLable.frame = rect.offsetBy(dx: 0, dy: height)
        }) { (_) in
            UIView.animate(withDuration: 1){
                self.pulldownTipLable.frame = rect.offsetBy(dx: 0, dy: -2 * height)
            }
        }
    }

    //MARK: - 懒加载控件
    //下拉刷新提示标签
    lazy var pulldownTipLable:UILabel = {
        let lab = UILabel(title: "", color: UIColor.white, fontSize: 18, screenInset: 0)
        lab.backgroundColor = UIColor.orange
        navigationController?.navigationBar.insertSubview(lab, at: 0)
        
        return lab
    }()
    //上拉刷新提示图
    private lazy var pullupView:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        indicator.color = UIColor.lightGray
        return indicator
    }()
    //照片查看转场动画代理
    private lazy var photoBrowserAnimator:HKPhotoBrowserAnimator = HKPhotoBrowserAnimator()
}

// MARK: - 数据源方法
extension HomeTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listViewModel.statusList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //修改可重用标识符
        //1、获取视图模型
        let vm:StatusViewModel = listViewModel.statusList[indexPath.row]
        
        var cell:StatusCell
        if vm.status.retweeted_status != nil {
            cell = tableView.dequeueReusableCell(withIdentifier: "\(StatusRetweetedCell.self)", for: indexPath) as! StatusCell
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "\(StatusNormalCell.self)", for: indexPath) as! StatusCell
        }
        cell.viewModel = vm
        cell.viewModel!.validateSubject.subscribe { (event) in
            
            let vc = DetaliViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: cell.viewModel!.disposeBag)
        
        //判断是否最后一条微博
        if indexPath.row == listViewModel.statusList.count - 1 && !pullupView.isAnimating {
            //开始动画
            pullupView.startAnimating()
            //上拉刷新数据
            loadData()
        }
        return cell
    }
    
    /*
     行高
     -- 设置了预估行高，
     当前显示的行高方法会调用三次（每个版本 xcode 调用次数可能不同）
    问题：预估行高如果不同，计算的次数不同
     1、使用预估行高，先计算出预估的 contentSize
     2、根据预估行高，判断计算次数，顺序计算每一行的行高，更新 contentSize
     3、如果预估行高过大，超出预估范围，顺序计算后续行高，一直到填满屏幕退出，同时更新 contentSize
     4、使用预估行高，每个 cell的显示前需要计算，单个 cell的效率是低的，从整体效率高
     
     执行顺序 行数 -> 每个[cell -> 行高]
     
     预估行高：尽量靠近cell的实际高度
     
     -- 没设置预估行高
     1、计算所有行的高度
     2、再计算显示行的高度
     
     执行顺序 行数 -> 行高 -> cell
     
     问题：为什么药调用所有的行高方法？UITableView 继承自 UIScrollView
     表格视图滚动非常流畅 -> 需要提前计算出 contentSize
     
     苹果官方文档指出：如果行高是固定值，就不要实现行高代理方法
     
     实际开发中，行高一定要缓存
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return listViewModel.statusList[indexPath.row].rowHeight

    //在 viewModel 中使用懒加载计算并存储 rowHeight 以后，以下代码即可省略
        //        print(indexPath)
//        let vm:StatusViewModel = listViewModel.statusList[indexPath.row]
//        if vm.rowHeight != nil {
//            return vm.rowHeight!
//        }
//        //计算行高
//        let cell = StatusCell(style: UITableViewCellStyle.default, reuseIdentifier: "\(StatusCell.self)")
//        vm.rowHeight = cell.rowHeigth(vm: vm)
//        return vm.rowHeight!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath)")
        
    }
    //MARK:- 响应事件
    func clickEvent() {
        
    }
}

































