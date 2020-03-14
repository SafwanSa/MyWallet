//
//  Calculation.swift
//  My Wallet
//
//  Created by Safwan Saigh on 14/03/2020.
//  Copyright © 2020 Safwan Saigh. All rights reserved.
//

import UIKit

class Calculations{
    
    
    var costs = [Float]()
    
    init() {
        let dataSourceDelivery = DataSource(type: "ppaymnet")
        dataSourceDelivery.dataSourceDelegate = self
    }
    
    static func getAverage(){
        
    }
    
    
    
}
extension Calculations: DataSourceProtocol{
    func paidDataUpdated(data: [[Payment]]) {}
    
    func unpaidDataUpdated(data: [Payment]) {}
    
    func userDataUpdated(data: [String : Any], which: String) {}
    
    func getMonths(months: [String]) {}
    
    func getCosts(costs: [Float]) {
        print(costs)
        self.costs = costs
    }
    
    
}
