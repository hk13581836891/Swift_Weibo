//
//  Dispatch.swift
//  Swift_Weibo
//
//  Created by houke on 2018/9/4.
//  Copyright © 2018年 houke. All rights reserved.
//

import Foundation

/// GCD定时器倒计时⏳
///   - timeInterval: 循环间隔时间
///   - repeatCount: 重复次数
///   - handler: 循环事件, 闭包参数： 1. timer， 2. 剩余执行次数
func dispatchTimer(timeInterval: Double, repeatCount:Int, handler:@escaping (DispatchSourceTimer?, Int)->())
{
    if repeatCount <= 0 {
        return
    }
    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    var count = repeatCount
    timer.schedule(wallDeadline: .now(), repeating: timeInterval)
    timer.setEventHandler(handler: {
        count -= 1
        DispatchQueue.main.async {
            handler(timer, count)
        }
        if count == 0 {
            timer.cancel()
        }
    })
    timer.resume()
}

/// GCD定时器循环操作
///   - timeInterval: 循环间隔时间
///   - handler: 循环事件
func dispatchTimer(timeInterval: Double, handler:@escaping (DispatchSourceTimer?)->())
{
    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
    timer.schedule(deadline: .now(), repeating: timeInterval)
    timer.setEventHandler {
        DispatchQueue.main.async {
            handler(timer)
        }
    }
    timer.resume()
}

/// GCD延时操作
///   - after: 延迟的时间
///   - handler: 事件
func dispatchAfter(after: Double, handler:@escaping ()->())
{
    DispatchQueue.main.asyncAfter(deadline: .now() + after) {
        handler()
    }
}
