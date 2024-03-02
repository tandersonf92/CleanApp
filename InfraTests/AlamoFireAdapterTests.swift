import Alamofire
import XCTest

class AlamoFireAdapter {
    private var session: Session

    init(session: Session = .default) {
        self.session = session
    }

    func post(to url: URL, with data: Data?) {
        let json = try? JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed) as? [String: Any]
        session.request(url, method: .post, parameters: json, encoding: JSONEncoding.default).resume()
    }
}

final class AlamoFireAdapterTests: XCTestCase {
    func test_post_ShouldMakeRequestWithValidUrlAndMethod() {
        let url = makeURL()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamoFireAdapter(session: session)
        
        sut.post(to: url, with: makeValidData())
        let exp = expectation(description: "waiting")
        URLProtocolStub.observerRequest { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}

class URLProtocolStub: URLProtocol {
    static var emit: ((URLRequest) -> Void)?

    static func observerRequest(completion: @escaping (URLRequest) -> Void) {
        URLProtocolStub.emit = completion
    }

    override open class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override open func startLoading() {
        URLProtocolStub.emit?(request)
    }

    override open func stopLoading() {}
}
