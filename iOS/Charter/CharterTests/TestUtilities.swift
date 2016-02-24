//
//  TestUtilities.swift
//  Charter
//
//  Created by Matthew Palmer on 25/02/2016.
//  Copyright © 2016 Matthew Palmer. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Charter

let config = Realm.Configuration(path: "./test-realm", inMemoryIdentifier: "test-realm")

extension XCTestCase {
    func setUpTestRealm() -> Realm {
        let realm = try! Realm(configuration: config)
        
        try! realm.write {
            realm.deleteAll()
        }
        
        return realm
    }
    
    func testBundle() -> NSBundle {
        return NSBundle(forClass: self.dynamicType)
    }
    
    func dataForJSONFile(file: String) -> NSData {
        let fileURL = testBundle().URLForResource(file, withExtension: "json")!
        return NSData(contentsOfURL: fileURL)!
    }
}

class NSURLSessionDataTaskMock : NSURLSessionDataTask {
    var completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void?)?
    var completionArguments: (data: NSData?, response: NSURLResponse?, error: NSError?)
    
    override func resume() {
        completionHandler?(completionArguments.data, completionArguments.response, completionArguments.error)
    }
}

class NetworkingSessionMock: NetworkingSession {
    let dataTask: NSURLSessionDataTaskMock
    
    var assertionBlockForRequest: ((NSURLRequest) -> Void)?
    
    init(dataTask: NSURLSessionDataTaskMock) {
        self.dataTask = dataTask
    }
    
    func dataTaskWithRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        assertionBlockForRequest?(request)
        
        dataTask.completionHandler = completionHandler
        return dataTask
    }
}


