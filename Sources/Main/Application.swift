//
//  Application.swift
//  Main
//
//  Created by iq3AddLi on 2019/09/19.
//

import Vapor

class Application{
    
    private lazy var services = {
        return Services.default()
    }()
    
    init(){
        var services = self.services
        
        // Register routes to the router
        let router = EngineRouter.default()
        
        // Set Routing
        let controller = BookController()
        router.get("/book", use: controller.getBook )
        router.post("/book", use: controller.postBook )
        
        services.register(router, as: Router.self)
        
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
