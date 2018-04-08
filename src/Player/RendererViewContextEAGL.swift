//
//  RendererViewContextEAGL.swift
//  Smena
//
//  Created by Dmitrii on 07/04/2018.
//  Copyright © 2018 Andrei Valkovskii. All rights reserved.
//

import UIKit

class RendererViewContextEAGL: RendererViewContext {

    let eaglContext = EAGLContext(api: .openGLES2)!

    init() {
        super.init(ciContext: CIContext(eaglContext: eaglContext))
    }
}
