//
//  FacebookNativeAdView.swift
//  Timetable
//
//  Created by Jonah Schueller on 23.06.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit


// Native AD Banner ID: 602091090165655_602133180161446
//
//class AdView: UIView {
//
//    var adIconImageView: FBAdIconView = FBAdIconView()
//    var adTitleLabel: UILabel = UILabel()
//    var adCoverMediaView: FBMediaView = FBMediaView()
//    var adSocialContext: UILabel = UILabel()
//    var adCallToActionButton: UIButton = UIButton()
//    var adChoiceView: FBAdChoicesView = FBAdChoicesView()
//    var adBodyLabel: UILabel = UILabel()
//    var sponsoredLabel: UILabel = UILabel()
//
//    init() {
//        super.init(frame: .zero)
//
//        translatesAutoresizingMaskIntoConstraints = false
//
//        backgroundColor = .white
//
//        generalSubviewsSettings(adIconImageView, adTitleLabel, adCoverMediaView, adSocialContext, adCallToActionButton, adChoiceView, adBodyLabel, sponsoredLabel)
//
//        setupUIConstraints()
//
//        sponsoredLabel.text = "sponsored"
//        adBodyLabel.text = "adaddada"
//    }
//
//
//
//    func setupUIConstraints(){
//
//        // Ad Icon Image Top left
//        adIconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
//        adIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3).isActive = true
//        adIconImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
//        adIconImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
//
//        adTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
//        adTitleLabel.leadingAnchor.constraint(equalTo: adIconImageView.trailingAnchor, constant: 5).isActive = true
//        adTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
//        adTitleLabel.bottomAnchor.constraint(equalTo: adIconImageView.centerYAnchor).isActive = true
//
//        sponsoredLabel.topAnchor.constraint(equalTo: adTitleLabel.bottomAnchor, constant: 5).isActive = true
//        sponsoredLabel.leadingAnchor.constraint(equalTo: adIconImageView.trailingAnchor, constant: 5).isActive = true
//        sponsoredLabel.trailingAnchor.constraint(equalTo: adTitleLabel.trailingAnchor).isActive = true
//        sponsoredLabel.bottomAnchor.constraint(equalTo: adIconImageView.bottomAnchor).isActive = true
//
//        adChoiceView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        adChoiceView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        adChoiceView.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        adChoiceView.heightAnchor.constraint(equalToConstant: 30).isActive = true
//
//        adCoverMediaView.topAnchor.constraint(equalTo: adIconImageView.bottomAnchor, constant: 5).isActive = true
//        adCoverMediaView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3).isActive = true
//        adCoverMediaView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3).isActive = true
//        adCoverMediaView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
//
//        adSocialContext.topAnchor.constraint(equalTo: adCoverMediaView.bottomAnchor, constant: 5).isActive = true
//        adSocialContext.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3).isActive = true
//        adSocialContext.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3).isActive = true
//        adSocialContext.heightAnchor.constraint(equalToConstant: 15).isActive = true
//
//        adBodyLabel.topAnchor.constraint(equalTo: adSocialContext.bottomAnchor, constant: 5).isActive = true
//        adBodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3).isActive = true
//        adBodyLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
//        adBodyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 3).isActive = true
//
//        adCallToActionButton.topAnchor.constraint(equalTo: adBodyLabel.topAnchor).isActive = true
//        adCallToActionButton.leadingAnchor.constraint(equalTo: adBodyLabel.trailingAnchor, constant: 10).isActive = true
//        adCallToActionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3).isActive = true
//        adCallToActionButton.bottomAnchor.constraint(equalTo: adBodyLabel.centerYAnchor).isActive = true
//
//        adCallToActionButton.backgroundColor = .lightBlue
//        adCallToActionButton.layer.cornerRadius = 5
//
//        adTitleLabel.font = UIFont.robotoMedium(13)
//        adBodyLabel.font = UIFont.robotoMedium(13)
//        sponsoredLabel.font = UIFont.robotoMedium(12)
//        adSocialContext.font = UIFont.robotoMedium(12)
//
//        adIconImageView.contentMode = .scaleAspectFill
//
//        adBodyLabel.numberOfLines = -1
//    }
//
//
//    private func generalSubviewsSettings(_ views: UIView...) {
//        views.forEach { (view) in
//            self.generalSubviewSettings(view)
//        }
//    }
//
//    private func generalSubviewSettings(_ view: UIView) {
//        view.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(view)
//    }
//
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//}
