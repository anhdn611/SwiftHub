//
//  TrendingRepositoryCellViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 12/18/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import BonMot

class TrendingRepositoryCellViewModel {

    let title: Driver<String>
    let detail: Driver<String>
    let secondDetail: Driver<NSAttributedString>
    let imageUrl: Driver<URL?>
    let badge: Driver<UIImage?>
    let badgeColor: Driver<UIColor>

    let repository: TrendingRepository

    init(with repository: TrendingRepository, since: TrendingPeriodSegments) {
        self.repository = repository
        title = Driver.just("\(repository.fullname ?? "")")
        detail = Driver.just("\(repository.descriptionField ?? "")")
        secondDetail = Driver.just(repository.attributetDetail(since: since.title))
        imageUrl = Driver.just(repository.avatarUrl?.url)
        badge = Driver.just(R.image.icon_cell_badge_repository()?.template)
        badgeColor = Driver.just(UIColor.flatGreenDark)
    }
}

extension TrendingRepositoryCellViewModel: Equatable {
    static func == (lhs: TrendingRepositoryCellViewModel, rhs: TrendingRepositoryCellViewModel) -> Bool {
        return lhs.repository == rhs.repository
    }
}

extension TrendingRepository {
    func attributetDetail(since: String) -> NSAttributedString {
        let starImage = R.image.icon_cell_badge_star()?.filled(withColor: .text()).scaled(toHeight: 15)?.styled(with: .baselineOffset(-3)) ?? NSAttributedString()
        let starsString = (stars ?? 0).kFormatted()
        let currentPeriodStarsString = "\((currentPeriodStars ?? 0).kFormatted()) \(since.lowercased())"
        let languageColorShape = "●".styled(with: StringStyle([.color(UIColor(hexString: languageColor ?? "") ?? .clear)]))
        return NSAttributedString.composed(of: [
            starImage, Special.space, starsString, Special.space, Special.tab,
            starImage, Special.space, currentPeriodStarsString, Special.space, Special.tab,
            languageColorShape, Special.space, language ?? ""
        ])
    }
}
