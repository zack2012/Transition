import Foundation

public struct Hello {
  public init() {}
  
  public func greeting() -> String {
    return "Hello"
  }

  @_spi(Test) public func foo() -> Bool {
    return false
  }
}

public protocol Flyable {
  func fly()
  @_spi(Test) func run()
}

public func foo(a: any Flyable) {
  a.run()
}
