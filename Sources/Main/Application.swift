//
//  Application.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/19.
//

import Vapor
import JWT

class Application{
    
    private lazy var services = {
        return Services.default()
    }()
    
    init(){
        var services = self.services
        
        // Register routes to the router
        let router = EngineRouter.default()
        
        // Set Routing
        let bookController = BookController()
        let jwtController = JWTController()
        
//        router.get("/book", use: controller.getBook )
        router.on(.GET, at: "/book", use: bookController.getBook )
//        router.post("/book", use: controller.postBook )
        router.on(.POST, at: "/book", use: bookController.postBook )
//        router.put("/book", use: controller.putBook )
        router.on(.PUT, at: "/book", use: bookController.putBook )
//        router.delete("/book", use: controller.deleteBook )
        router.on(.DELETE, at: "/book", use: bookController.deleteBook )
        
        router.get("jwt", use: jwtController.getToken )
        router.post("jwt", "verify", use: jwtController.verifyToken )
        
        router.get("error") { request -> Response /* It is necessary to tell the compiler the return type */ in
            let response = Response(http: HTTPResponse(status: .badRequest), using: request)
            let myContent = Book(title: "Three kingdom", author: "Mitsuteru yokoyama")
            try response.content.encode(myContent, as: MediaType.json)
            return response
        }
        
        router.get("/notfound") { request -> Response in
            let response = request.response(ServerError( reason: "Not found is not found."), as: .json)
            let myContent = Book(title: "Three kingdom", author: "Mitsuteru yokoyama")
            try response.content.encode(myContent, as: .json)
            response.http.status = .notFound
            
            return response
        }
        
        router.on(.GET, at: "always", use: bookController.alwaysError )
        
        // Add group by middleware
        router.group(AlwaysErrorMiddleware()) { router in
            router.get("auth", "error", use:{ request in
                return GeneralInfomation("unreachable it.")
            })
        }
        
        let authMiddleware = AuthMiddleware()
        router.grouped(authMiddleware).get("auth", use: { request -> GeneralInfomation in
            let token = (try request.privateContainer.make(RelayInfomation.self)).infomation
            print("\(request.description) token=\(token)")
            return GeneralInfomation("You authenticate token is good. token is \(token)")
        })
        
        router.grouped(JWTVerifyMiddleware()).get("jwt", "verify", use: jwtController.relayedPayload )
        
        // Set router
        services.register(router, as: Router.self)
        
        // Set server config
        let serverConfiure = NIOServerConfig.default(hostname: "127.0.0.1", port: 8080)
        services.register(serverConfiure)
        
        // Set Service models
        services.register(RelayInfomation(""))
        services.register(Payload(username: "", exp: ExpirationClaim(value: Date())))
        
        // Apply change service
        self.services = services
    }
    
    public func launch() throws{
        let config = Config.default()
        let env = try Environment.detect()
        
        // Create vapor application
        let application = try Vapor.Application(config: config, environment: env, services: self.services)
        
        // Application launch
        try application.run()
    }
}
