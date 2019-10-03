//
//  JWTController.swift
//  Main
//
//  Created by iq3AddLi on 2019/10/03.
//

import Vapor
import JWT

struct JWTController{
    
    // JWT Issue
    func getToken(_ request: Request) throws -> [ String: String ] {
        
        // Get parameter at query
        guard let username = request.query[ String.self, at: "username" ] else{
            throw Abort(.badRequest, reason: "The username is require in query.")
        }
        let exp = request.query[ Int.self, at: "exp" ] ?? 60
        
        // create payload
        let payload = Payload(username: username, exp: ExpirationClaim(value: Date().addingTimeInterval(TimeInterval(exp))))
        
        // create JWT and sign
        let data = try JWT(payload: payload).sign(using: .hs256(key: Constants.secret))
        return [ "token": String(data: data, encoding: .utf8) ?? "<encode failed>" ]
    }
    
    // JWT Verify (HTTP Body)
    func verifyToken(_ request: Request) throws -> Future<Response> {
        
        // JWT Verify (HTTP header bearer)
        if let bearer = request.http.headers.bearerAuthorization {
            let jwt = try JWT<Payload>(from: bearer.token, verifiedUsing: .hs256(key: Constants.secret))
            return request.response( GeneralInfomation("Your username is \(jwt.payload.username)") , as: .json).encode(status: .ok, for: request)
        }
        if let token = request.http.headers.tokenAuthorization {
            let jwt = try JWT<Payload>(from: token.token, verifiedUsing: .hs256(key: Constants.secret))
            return request.response( GeneralInfomation("Your username is \(jwt.payload.username)") , as: .json).encode(status: .ok, for: request)
        }
        
        // JWT Verify (HTTP Body)
        // Get parameter at http body
        return try request.content.decode(json: PayloadRequest.self, using: JSONDecoder()).map { (payloadReq) in
            
            // parse JWT from token string, using HS-256 signer
            let jwt = try JWT<Payload>(from: payloadReq.token, verifiedUsing: .hs256(key: Constants.secret))
            return request.response( GeneralInfomation("Your username is \(jwt.payload.username)") , as: .json)
        }
    }
    
    // JWT Verify (in Middleware)
    func relayedPayload(_ request: Request) throws -> Future<Response> {
        
        let payload = (try request.privateContainer.make(Payload.self))
        return request.response( GeneralInfomation("Your username is \(payload.username)") , as: .json).encode(status: .ok, for: request)
    }
}
