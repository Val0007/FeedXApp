//
//  CellModel.swift
//  FeedX
//
//  Created by Val V on 17/03/23.
//

import Foundation
class SwiftyAccordionCells {
    var items = [Item]()
    
    class Item {
        var isHidden: Bool
        var value: String
        var pub:String
        
        init(_ hidden: Bool = true, value: String,pub:String="") {
            self.isHidden = hidden
            self.value = value
            self.pub = pub
        }
    }
    
    class HeaderItem: Item {
        init (value: String) {
            super.init(false, value: value)
        }
    }
    
    func append(_ item: Item) {
        self.items.append(item)
    }
    
    func removeAll() {
        self.items.removeAll()
    }
    
    func expand(_ headerIndex: Int) {
        self.toggleVisible(headerIndex, isHidden: false)
    }
    
    func collapse(_ headerIndex: Int) {
        self.toggleVisible(headerIndex, isHidden: true)
    }
    
    private func toggleVisible(_ headerIndex: Int, isHidden: Bool) {
        var headerIndex = headerIndex
        headerIndex += 1
        
        while headerIndex < self.items.count && !(self.items[headerIndex] is HeaderItem) {
            self.items[headerIndex].isHidden = isHidden
            print(self.items[headerIndex].value)
            headerIndex += 1
        }
    }
}
