import XCTest

import bccTests

var tests = [XCTestCaseEntry]()
tests += bccTests.allTests()
XCTMain(tests)