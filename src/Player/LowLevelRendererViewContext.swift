//
//  LowLevelRendererViewContext.swift
//  Smena
//
//  Created by Dmitrii on 07/04/2018.
//  Copyright © 2018 Grid Cascade. All rights reserved.
//

import CoreImage


class LowLevelRendererViewContext {

    let ciContext: CIContext

    init(ciContext context: CIContext?) {
        self.ciContext = context ?? CIContext(options:nil)
    }
}


class LowLevelRendererViewContextEAGL: LowLevelRendererViewContext {

    let eaglContext = EAGLContext(api: .openGLES2)!

    init() {
        super.init(ciContext: CIContext(eaglContext: eaglContext))
    }
}
