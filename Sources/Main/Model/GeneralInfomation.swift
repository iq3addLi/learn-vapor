//
//  GeneralInfomation.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/20.
//

struct GeneralInfomation{
    let infomation: String
    
    init(_ infomation: String){
        self.infomation = infomation
    }
}


import Vapor

extension GeneralInfomation: Content{}

// Requires implementation when generating Response
extension GeneralInfomation: LosslessHTTPBodyRepresentable{
    func convertToHTTPBody() -> HTTPBody{
        return try! HTTPBody(data: JSONEncoder().encode(self))
    }
}
