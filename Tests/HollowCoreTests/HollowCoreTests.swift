import XCTest
@testable import HollowCore

fileprivate let configURL = "https://cdn.jsdelivr.net/gh/treehollow/thuhole-config@master/config.txt"
fileprivate let testAPIRoot = "https://dev-api.thuhole.com/"
// Update the token when needed.
fileprivate let testToken = "oax3srqfixgv7ymi2vshfbvspiecb3nh"

final class HollowCoreTests: XCTestCase {
    
    func testGetConfig() {
        let test = NetworkTest<GetConfigRequest>(configuration: .init(configUrl: configURL))
        execute(test)
    }
    
    func testGetPush() {
        let test = NetworkTest<GetPushRequest>(configuration: .init(apiRoot: testAPIRoot, token: testToken))
        execute(test)
    }
    
    func testSetPush() {
        let random: () -> Bool = {
            let num = Double.random(in: 0...1)
            return num > 0.5
        }
        let test = NetworkTest<SetPushRequest>(configuration: .init(apiRoot: testAPIRoot, token: testToken, type: .init(pushSystemMsg: random(), pushReplyMe: random(), pushFavorited: random())))
        execute(test)
    }
    
    func testAttentionList() {
        let test = NetworkTest<AttentionListRequest>(configuration: .init(apiRoot: testAPIRoot, token: testToken, page: 1))
        execute(test)
    }
    
    func testAttentionListSearch() {
        let test = NetworkTest<AttentionListRequest>(configuration: .init(apiRoot: testAPIRoot, token: testToken, page: 1))
        execute(test)
    }
    
    func testPostDetail() {
        let test1 = NetworkTest<PostDetailRequest>(configuration: .init(apiRoot: testAPIRoot, token: testToken, postId: 1, includeComments: false), validate: {
            if case .cached = $0 { return false }
            if case .new(let data) = $0 { return data.comments.isEmpty }
            return true
        })
        execute(test1)
    }
    
    @available(macOS 12, iOS 15, watchOS 8, tvOS 15, *)
    func testPostDetailWithCache() async {
        guard let result = try? await PostDetailRequest(configuration: .init(apiRoot: testAPIRoot, token: testToken, postId: 1, includeComments: true)).result() else { return }
        guard case .new(let post) = result else { return }
        let test = NetworkTest<PostDetailRequest>(configuration: .init(apiRoot: testAPIRoot, token: testToken, postId: 1, includeComments: true, lastUpdateTimestamp: post.post.updatedAt, cachedPost: post), validate: {
            if case .cached = $0 { return true }
            if case .new(let newPost) = $0 {
                return newPost.post.updatedAt == post.post.updatedAt
            }
            return true
        })
        execute(test)
    }

    func testPostList() {
        let test = NetworkTest<PostListRequest>(configuration: .init(apiRoot: testAPIRoot, token: testToken, page: 1))
        execute(test)
    }
    
    func testRandomList() {
        let test = NetworkTest<RandomListRequest>(configuration: .init(apiRoot: testAPIRoot, token: testToken, page: 1))
        execute(test)
    }
    
    // TODO: More tests
    
    // Uncomment /*test*/ to enable the test
    func /*test*/Login() {
        let test = NetworkTest<LoginRequest>(configuration: .init(apiRoot: testAPIRoot, email: "<your_email_address>", password: "<your_password>", deviceInfo: "XCTest", deviceToken: nil))
        execute(test)
    }
}

extension HollowCoreTests {
    func execute<R: Request>(_ test: NetworkTest<R>, with expectations: [XCTestExpectation] = [XCTestExpectation(description: "Completion API"), XCTestExpectation(description: "Async API")], timeout: TimeInterval = 10) {
        test.execute(with: expectations)
        wait(for: expectations, timeout: timeout)
    }
}
