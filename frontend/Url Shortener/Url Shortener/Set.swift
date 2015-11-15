//
//  Set.swift
//  Url Shortener
//
//  Created by Michael Peterson on 11/15/15.
//  Copyright © 2015 Michael Peterson. All rights reserved.
//

import Foundation

extension Set {
    subscript(index: Int) -> Element {
        get {
            return self[startIndex.advancedBy(index)]
        }
    }
}