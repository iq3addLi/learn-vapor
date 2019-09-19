//
//  BookController.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/19.
//

import Vapor

struct BookController{
    
    func getBook(_ request: Request) throws -> Book {
        return Book(title: "三国志", author: "横山光輝")
    }
    
    func postBook(_ request: Request) throws -> Book {
        return Book(title: "伊達政宗", author: "横山光輝")
    }
}
