//
//  AuthMiddleware.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/26.
//

import Vapor

struct AlwaysErrorMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        return request.response( ServerError( reason: "Your authentication is bad.") , as: .json)
            .encode(status: .unauthorized, for: request)
    }
}

struct AuthMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        
        guard let token = request.http.headers["Authentication"].first, token == "hello" else{
            return request.response( ServerError( reason: "Your authentication is bad.") , as: .json)
                .encode(status: .unauthorized, for: request)
        }
        let relay = (try request.privateContainer.make(RelayInfomation.self))
        relay.infomation = randomString(length: 16)
        print("\(request.description) token=\(relay.infomation)")
        return try next.respond(to: request)
    }
}

private func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in letters.randomElement()! })
}
