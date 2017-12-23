//
//  HeaderTableViewCellController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 30/07/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import ImageViewer

class SummaryHeaderCellController: TakePictureViewController {
    var product: Product!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var callToActionView: PictureCallToActionView!
    @IBOutlet weak var nutriscore: NutriScoreView! {
        didSet {
            nutriscore?.currentScore = nil
        }
    }
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var addNewPictureButton: UIButton!

    convenience init(with product: Product, dataManager: DataManagerProtocol) {
        self.init(nibName: String(describing: SummaryHeaderCellController.self), bundle: nil)
        self.product = product
        super.barcode = product.barcode
        super.dataManager = dataManager
        super.imageType = .front
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    fileprivate func setupViews() {
        if let imageUrl = product.frontImageUrl ?? product.imageUrl, let url = URL(string: imageUrl) {
            productImage.kf.indicatorType = .activity
            productImage.kf.setImage(with: url)

            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProductImage))
            productImage.addGestureRecognizer(tap)
            productImage.isUserInteractionEnabled = true
            callToActionView.isHidden = true
            addNewPictureButton.isHidden = false
        } else {
            productImage.isHidden = true
            callToActionView.textLabel.text = "call-to-action.summary".localized
            callToActionView.isHidden = false
            callToActionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTakePictureButton(_:))))
            addNewPictureButton.isHidden = true
        }

        if let nutriscoreValue = product.nutriscore, let score = NutriScoreView.Score(rawValue: nutriscoreValue.uppercased()) {
            nutriscore.currentScore = score
        } else {
            nutriscore.superview?.isHidden = true
        }

        if let name = product.name, !name.isEmpty {
            productName.text = name
        } else {
            productName.isHidden = true
        }
    }
}

// MARK: - Gesture recognizers
extension SummaryHeaderCellController {
    @objc func didTapProductImage(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            ImageViewer.show(imageView, presentingVC: self)
        }
    }
}
