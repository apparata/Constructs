//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

#if os(iOS) || os(tvOS)

import Foundation

public extension IndexSet {
    
    func indexPaths(withSection section: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        
        for index in indices {
            let indexInt = self[index]
            indexPaths.append(IndexPath(item: indexInt, section: section))
        }
        return indexPaths
    }
    
}

#endif

