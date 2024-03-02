import Foundation

func makeInvalidData() -> Data {
    Data("invalid_data".utf8)
}

func makeValidData() -> Data {
    Data("{\"name\":\"Rodrigo\"}".utf8)
}
func makeEmptyData() -> Data {
    Data()
}

func makeURL() -> URL {
    URL(string: "http://any-url.com")!
}

func makeHttpResponse(statusCode: Int = 200) -> HTTPURLResponse {
    HTTPURLResponse(url: makeURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}

func makeError() -> Error {
    NSError(domain: "any_error", code: 0)
}
