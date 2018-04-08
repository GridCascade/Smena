//
//  RendererView.swift
//  Smena
//
//  Created by Dmitrii on 18/03/2018.
//  Copyright © 2018 Grid Cascade. All rights reserved.
//

import UIKit
import GLKit

public class RendererView: UIView {

    // MARK: - Properties
    var ciImage: CIImage? {
        didSet {
            loadContextIfNeeded()
            setNeedsDisplay()
        }
    }
    var ciTime: CFTimeInterval?
    var ciTransform = CGAffineTransform.identity

    private var context: RendererViewContext?
    private var glkView: GLKView?

    // MARK: - Lyfecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {

    }

    public override func setNeedsDisplay() {
        super.setNeedsDisplay()
        glkView?.setNeedsDisplay()
    }

//    public override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        guard let img = ciImage else { return }
//        
//    }

    // MARK: - Public


    // MARK: - Private
    private func loadContextIfNeeded() {
        guard ciImage != nil else { return }
        if context == nil {
            // EAGL (OpenGL) context
            context = RendererViewContextEAGL()
            let eaglContext = context as! RendererViewContextEAGL
            glkView = GLKView(frame: frame, context: eaglContext.eaglContext)
            glkView!.contentScaleFactor = contentScaleFactor;
            glkView!.delegate = self
            insertSubview(glkView!, at: 0)
        }
    }

    private func renderedCIImage(rect: CGRect) -> CIImage? {
        guard ciImage != nil else { return nil }
        return scaledAndResizedImage(image: ciImage!, rect: rect)
    }

    private func scaledAndResizedImage(image: CIImage, rect: CGRect) -> CIImage {
        let imageSize = image.extent.size
        var horizontalScale = rect.size.width / imageSize.width
        var verticalScale = rect.size.height / imageSize.height
        let mode = self.contentMode

        if (mode == UIViewContentMode.scaleAspectFill) {
            horizontalScale = CGFloat.maximum(horizontalScale, verticalScale)
            verticalScale = horizontalScale;
        } else if (mode == UIViewContentMode.scaleAspectFit) {
            horizontalScale = CGFloat.minimum(horizontalScale, verticalScale);
            verticalScale = horizontalScale;
        }
        return image.transformed(by: CGAffineTransform(scaleX: horizontalScale, y: verticalScale))
    }
}


extension RendererView: GLKViewDelegate {
    public func glkView(_ view: GLKView, drawIn rect: CGRect) {
        autoreleasepool(invoking: {() -> () in
            glClearColor(0, 0, 0, 0)
            glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
            if let image = renderedCIImage(rect: rect) {
                context?.ciContext.draw(image, in: rect, from: image.extent)
            }
        })
    }
}
