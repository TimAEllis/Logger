import Foundation

/// `LoggerFormatter`s are used to attempt to create string representations of `LoggerEntry` instances.
public protocol LoggerFormatter {
	/// Called to create a string representation of the passed-in `LoggerEntry`.
	/// - Parameter entry: The `LoggerEntry` to attempt to convert into a string.
	/// - Returns: A `String` representation of `entry`, or `nil` if the receiver could not format the `LoggerEntry`.
	func format(_ entry: LoggerEntry) -> String?
}
