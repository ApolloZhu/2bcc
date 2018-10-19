import XCTest

import _bccTests

var tests = [XCTestCaseEntry]()
tests += _bccTests.allTests()
XCTMain(tests)