//
//  RendererViewContext.swift
//  Smena
//
//  Created by Dmitrii on 07/04/2018.
//  Copyright © 2018 Andrei Valkovskii. All rights reserved.
//

import UIKit

class RendererViewContext {

    let ciContext: CIContext

    init(ciContext context: CIContext?) {
        if context == nil {
            let context = CIContext(options: nil)
            self.ciContext = context
        } else {
            self.ciContext = context!
        }
    }
}
