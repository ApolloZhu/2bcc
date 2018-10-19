import XCTest
@testable import _bcc

final class _bccTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(_bcc().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
