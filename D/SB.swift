//
//  SB.swift
//  D
//
//  Created by Kirti S on 2/13/23.
//

import Foundation
import UIKit

class SupView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.myCustomInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.myCustomInit()
    }

    func myCustomInit() {
        print("hello there from SupView")
    }

}
