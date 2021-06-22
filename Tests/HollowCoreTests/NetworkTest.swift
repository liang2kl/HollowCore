//
//  NetworkTest.swift
//  HollowCoreTest
//
//  Created by 梁业升 on 2021/6/20.
//

@testable import HollowCore
import XCTest

struct NetworkTest<R: Request> {
    init(configuration: R.Configuration, validate: @escaping (R.ResultData) -> Bool = { _ in true }, completion: @escaping (R.ResultData) -> Void = { _ in }) {
        self.request = .init(configuration: configuration)
        self.configuration = configuration
        self.validate = validate
        self.completion = completion
    }
    
    var request: R
    var configuration: R.Configuration
    var validate: (R.ResultData) -> Bool
    var completion: (R.ResultData) -> Void = { _ in }
    
    private func testAPI(with expectation: XCTestExpectation) {
        request.performRequest(completion: { result in
            expectation.fulfill()
            if case .failure(let error) = result {
                XCTAssert(false, "Call failed with failure \(error)")
            }
            if case .success(let data) = result {
                if !validate(data) {
                    XCTAssert(false, "Receiving invalid data:\n\(data)")
                } else {
                    completion(data)
                }
            }
        })
    }
    
#if swift(>=5.5)
    @available(macOS 12, iOS 15, watchOS 8, tvOS 15, *)
    private func testAsyncAPI(with expectation: XCTestExpectation) async {
        do {
            let data = try await request.result()
            expectation.fulfill()
            if !validate(data) {
                XCTAssert(false, "Receiving invalid data on async API:\n\(data)")
            }
        } catch {
            expectation.fulfill()
            XCTAssert(false, "Async call failed with failure \(error)")
        }
    }
#endif
    
    func execute(with expectations: [XCTestExpectation]) {
        print("\n--- Testing API for \(R.self) ---")
        print("CONFIGURATION:\n\(configuration)\n")
        if #available(macOS 12, iOS 15, watchOS 8, tvOS 15, *) {
#if swift(>=5.5)
            async {
                await testAsyncAPI(with: expectations[1])
                testAPI(with: expectations[0])
            }
#endif
        } else {
            testAPI(with: expectations[0])
            expectations[1].fulfill()
        }
    }
}
