//
//  JWTVerifyMiddleware.swift
//  Main
//
//  Created by iq3AddLi on 2019/10/03.
//

import Vapor
import JWT

struct JWTVerifyMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {

        // JWT Verify (HTTP header bearer)
        var jwtOrNil: JWT<Payload>? = nil
        if let bearer = request.http.headers.bearerAuthorization {
            jwtOrNil = try JWT<Payload>(from: bearer.token, verifiedUsing: JWTSigner.hs256(key: Constants.secret))
        }
        if jwtOrNil == nil, let token = request.http.headers.tokenAuthorization {
            jwtOrNil = try JWT<Payload>(from: token.token, verifiedUsing: JWTSigner.hs256(key: Constants.secret))
        }
        
        guard let jwt = jwtOrNil else{
            throw Abort(.unauthorized, reason: "Authentication Token is not found.")
        }
        
        // Set threaded variable
        let payload = (try request.privateContainer.make(Payload.self))
        payload.username = jwt.payload.username
        payload.exp = jwt.payload.exp
        
        return try next.respond(to: request)
    }
}
