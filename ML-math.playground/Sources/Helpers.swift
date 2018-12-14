import Foundation

public func example(_ description: String, action: () -> () ) {
    print("\n---Example of:", description, "---")
    action()
    print("\n---End of:", description, "---")
}
