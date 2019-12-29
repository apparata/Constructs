//
//  Copyright © 2018 Apparata AB. All rights reserved.
//

import Foundation

public class WeakBox<T: AnyObject> {
    
    public private(set) weak var value: T?
    
    public init(_ value: T) {
        self.value = value
    }
}
