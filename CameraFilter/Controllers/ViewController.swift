//
//  ViewController.swift
//  CameraFilter
//
//  Created by Juan Bonforti on 17/01/2021.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var applyFilterButton: UIButton!
    
    // MARK: - Vars
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController,
              let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController else { return }
        
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: - IBActions
    @IBAction func applyFilterButtonAction(_ sender: Any) {
        guard let sourceImage = imageView.image else { return }
        
        FilterService().applyFilter(to: sourceImage)
            .subscribe(onNext: { filteredImage in
                DispatchQueue.main.async {
                    self.imageView.image = filteredImage
                }
            }).disposed(by: disposeBag)
    }
}

// MARK: - Extensions
extension ViewController {
    func setupUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func updateUI(with image: UIImage) {
        imageView.image = image
        applyFilterButton.isHidden = false
    }
}
