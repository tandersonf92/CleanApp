import Foundation

func makeInvalidData() -> Data {
    Data("invalid_data".utf8)
}

func makeValidData() -> Data {
    Data("{\"name\":\"Rodrigo\"}".utf8)
}

func makeURL() -> URL {
    URL(string: "http://any-url.com")!
}
