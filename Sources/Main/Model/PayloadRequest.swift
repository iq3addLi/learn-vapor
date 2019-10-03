//
//  PayloadRequest.swift
//  Main
//
//  Created by iq3AddLi on 2019/10/03.
//

struct PayloadRequest{
    let token: String
}

import Vapor
extension PayloadRequest: Content{}
