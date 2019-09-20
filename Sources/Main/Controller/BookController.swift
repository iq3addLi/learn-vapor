//
//  BookController.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/19.
//

import Vapor

struct BookController{
    
    func getBook(_ request: Request) throws -> Book {
        return Book(title: "Three kingdom", author: "Mitsuteru yokoyama")
    }
    
    func postBook(_ request: Request) throws -> GeneralInfomation {
        return GeneralInfomation("Your post is receipted.")
    }
    
    func putBook(_ request: Request) throws -> GeneralInfomation {
        return GeneralInfomation("Update successful.")
    }
    
    func deleteBook(_ request: Request) throws -> GeneralInfomation {
        return GeneralInfomation("Delete successful.")
    }
    
    func alwaysError(_ request: Request) throws -> Response {
        let response = request.response( ServerError( reason: "Your request is always error."), as: .json)
        response.http.status = .badRequest
        return response
    }
}
