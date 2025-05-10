//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

import Foundation

/// Extracts up to 2 elements from the array starting at the specified offset.
///
/// - Parameters:
///   - array: The source array to extract values from.
///   - offset: The starting index for extraction (default is 0).
/// - Returns: A tuple containing up to 2 optional elements.
///
func extractTuple<T>(from array: [T], offset: Int = 0) -> (T?, T?) {
    let value0 = array.count > 0 ? array[offset + 0] : nil
    let value1 = array.count > 1 ? array[offset + 1] : nil
    return (value0, value1)
}

/// Extracts up to 3 elements from the array starting at the specified offset.
///
/// - Parameters:
///   - array: The source array to extract values from.
///   - offset: The starting index for extraction (default is 0).
/// - Returns: A tuple containing up to 3 optional elements.
///
func extractTuple<T>(from array: [T], offset: Int = 0) -> (T?, T?, T?) {
    let value0 = array.count > 0 ? array[offset + 0] : nil
    let value1 = array.count > 1 ? array[offset + 1] : nil
    let value2 = array.count > 2 ? array[offset + 2] : nil
    return (value0, value1, value2)
}

/// Extracts up to 4 elements from the array starting at the specified offset.
///
/// - Parameters:
///   - array: The source array to extract values from.
///   - offset: The starting index for extraction (default is 0).
/// - Returns: A tuple containing up to 4 optional elements.
///
func extractTuple<T>(from array: [T], offset: Int = 0) -> (T?, T?, T?, T?) {
    let value0 = array.count > 0 ? array[offset + 0] : nil
    let value1 = array.count > 1 ? array[offset + 1] : nil
    let value2 = array.count > 2 ? array[offset + 2] : nil
    let value3 = array.count > 3 ? array[offset + 3] : nil
    return (value0, value1, value2, value3)
}

/// Extracts up to 5 elements from the array starting at the specified offset.
///
/// - Parameters:
///   - array: The source array to extract values from.
///   - offset: The starting index for extraction (default is 0).
/// - Returns: A tuple containing up to 5 optional elements.
///
func extractTuple<T>(from array: [T], offset: Int = 0) -> (T?, T?, T?, T?, T?) {
    let value0 = array.count > 0 ? array[offset + 0] : nil
    let value1 = array.count > 1 ? array[offset + 1] : nil
    let value2 = array.count > 2 ? array[offset + 2] : nil
    let value3 = array.count > 3 ? array[offset + 3] : nil
    let value4 = array.count > 4 ? array[offset + 4] : nil
    return (value0, value1, value2, value3, value4)
}

/// Extracts up to 6 elements from the array starting at the specified offset.
///
/// - Parameters:
///   - array: The source array to extract values from.
///   - offset: The starting index for extraction (default is 0).
/// - Returns: A tuple containing up to 6 optional elements.
///
func extractTuple<T>(from array: [T], offset: Int = 0) -> (T?, T?, T?, T?, T?, T?) {
    let value0 = array.count > 0 ? array[offset + 0] : nil
    let value1 = array.count > 1 ? array[offset + 1] : nil
    let value2 = array.count > 2 ? array[offset + 2] : nil
    let value3 = array.count > 3 ? array[offset + 3] : nil
    let value4 = array.count > 4 ? array[offset + 4] : nil
    let value5 = array.count > 5 ? array[offset + 5] : nil
    return (value0, value1, value2, value3, value4, value5)
}

/// Extracts up to 7 elements from the array starting at the specified offset.
///
/// - Parameters:
///   - array: The source array to extract values from.
///   - offset: The starting index for extraction (default is 0).
/// - Returns: A tuple containing up to 7 optional elements.
///
func extractTuple<T>(from array: [T], offset: Int = 0) -> (T?, T?, T?, T?, T?, T?, T?) {
    let value0 = array.count > 0 ? array[offset + 0] : nil
    let value1 = array.count > 1 ? array[offset + 1] : nil
    let value2 = array.count > 2 ? array[offset + 2] : nil
    let value3 = array.count > 3 ? array[offset + 3] : nil
    let value4 = array.count > 4 ? array[offset + 4] : nil
    let value5 = array.count > 5 ? array[offset + 5] : nil
    let value6 = array.count > 6 ? array[offset + 6] : nil
    return (value0, value1, value2, value3, value4, value5, value6)
}
