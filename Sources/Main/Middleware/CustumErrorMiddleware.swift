//
//  CustumErrorMiddleware.swift
//  Main
//
//  Created by iq3AddLi on 2019/10/18.
//

import Vapor

struct CustumErrorMiddleware: Middleware {
    
    internal struct ErrorResponse: Codable {
        var errors: [[String: String]]
    }
    
    private let closure: (Request, Error) -> (Response) = { request, error in
        
        let response = request.response(http: .init(status: .internalServerError, headers: [:]))
        
        // attempt to serialize the error to json
        do {
            let errorResponse = ErrorResponse(errors: [["YourBrain" : "Bad🤪"], ["error": error.localizedDescription]])
            response.http.body = try HTTPBody(data: JSONEncoder().encode(errorResponse))
            response.http.headers.replaceOrAdd(name: .contentType, value: "application/json; charset=utf-8")
        } catch {
            response.http.body = HTTPBody(string: "Oops: \(error)")
            response.http.headers.replaceOrAdd(name: .contentType, value: "text/plain; charset=utf-8")
        }
        
        return response
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        let response: Future<Response>
        do {
            response = try next.respond(to: request)
        } catch {
            response = request.eventLoop.newFailedFuture(error: error)
        }

        return response.catchFlatMap { error in
            if let response = error as? ResponseEncodable {
                do {
                    return try response.encode(for: request)
                } catch {
                    return request.future(self.closure(request, error))
                }
            } else {
                return request.future(self.closure(request, error))
            }
        }
    }
}
