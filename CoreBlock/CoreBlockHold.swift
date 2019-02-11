//
//  CoreBlockHold.swift
//  CoreBlockMac2
//
//  Created by Yihua Zhou on 2019/2/10.
//  Copyright © 2019 Yihua Zhou. All rights reserved.
//

import Foundation

class CoreBlockHold {
    
    static var shared: CoreBlockHold = CoreBlockHold()
    
    var piece: Int = 0
}

extension CoreBlockHold {
    
    func draw() {
        
        CoreBlockController.draw(
            pieces[self.piece].tetro,
            pieces[self.piece].x - 2,
            2 + pieces[self.piece].y,
            CoreBlockController.DrawType.hold
        )
    }
}
