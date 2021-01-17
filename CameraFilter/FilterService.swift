//
//  FilterService.swift
//  CameraFilter
//
//  Created by Juan Bonforti on 17/01/2021.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

class FilterService {
    
    private var context: CIContext
    
    init() {
        self.context = CIContext()
    }
    
    // Reactive function
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        
        return Observable<UIImage>.create { (observer) in
            self.applyFilter(to: inputImage) { (filteredImage) in
                observer.onNext(filteredImage)
            }
            
            return Disposables.create()
        }
    }
    
    // Normal Function
    private func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ())) {
        let filter = CIFilter(name: "CICMYKHalftone")!
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: inputImage) {
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            
            if let cgImg = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
                let processedImage = UIImage(cgImage: cgImg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                
                completion(processedImage)
            }
        }
    }
    
}
