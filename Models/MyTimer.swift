//
//  MyTimer.swift
//  Kiara
//
//  Created by Fabian Sand on 19.12.23.
//

import Foundation

class MyTimer : ObservableObject{
    let startTime = DispatchTime.now()
    @Published var update = false
    private var timer :Timer?
    private var workTime : UInt64 = 0
    private var wait_point = DispatchTime.now()
    
    private var isRunning = false
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                    self.refresh()
                })
    }
    
    private func refresh(){
        update = !update
    }
    
    public func getTimeSec() -> Int{
        return Int((DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000_000)
    }
    
    public func getWorkTimeSec() -> Int{
        if(isRunning){
            return Int((workTime +  DispatchTime.now().uptimeNanoseconds - wait_point.uptimeNanoseconds) / 1_000_000_000)
        }
        return Int(workTime / 1_000_000_000)
    }
    
    public func getWorkTimeNano() -> UInt64{
        if(isRunning){
            return workTime +  DispatchTime.now().uptimeNanoseconds - wait_point.uptimeNanoseconds
        }
        return workTime
    }
    
    public func start(){
        isRunning = true
        wait_point = DispatchTime.now()
    }
    
    public func wait(){
        isRunning = false
        workTime += DispatchTime.now().uptimeNanoseconds - wait_point.uptimeNanoseconds
    }
}
