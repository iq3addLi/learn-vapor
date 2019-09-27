//
//  RelayInfomation.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/26.
//



final class RelayInfomation{
    var infomation: String
    
    init(_ infomation: String){
        self.infomation = infomation
    }
}

import Vapor
extension RelayInfomation: Service{}
