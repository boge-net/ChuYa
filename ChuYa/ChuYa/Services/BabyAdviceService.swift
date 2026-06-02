//
//  BabyAdviceService.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import Foundation

struct BabyAdvice: Identifiable {
    let id = UUID()
    let kind: AdviceKind
    let title: String
    let body: String
    let tip: String
}

enum AdviceKind {
    case feeding
    case sleep
    case interaction
    case safety

    var iconName: String {
        switch self {
        case .feeding:
            return "drop"
        case .sleep:
            return "moon"
        case .interaction:
            return "hands.sparkles"
        case .safety:
            return "shield.checkered"
        }
    }
}

enum BabyAdviceService {
    static func todayAdvice(forMonthAge monthAge: Int, feedingType: String) -> [BabyAdvice] {
        let stage = AdviceStage(monthAge: monthAge)

        return [
            BabyAdvice(
                kind: .feeding,
                title: "今日喂养",
                body: stage.feedingBody(feedingType: feedingType),
                tip: stage.feedingTip
            ),
            BabyAdvice(
                kind: .sleep,
                title: "今日睡眠",
                body: stage.sleepBody,
                tip: stage.sleepTip
            ),
            BabyAdvice(
                kind: .interaction,
                title: "今日互动",
                body: stage.interactionBody,
                tip: stage.interactionTip
            ),
            BabyAdvice(
                kind: .safety,
                title: "今日提醒",
                body: stage.safetyBody,
                tip: stage.safetyTip
            )
        ]
    }
}

private enum AdviceStage {
    case newborn
    case earlyInfant
    case infant
    case crawler
    case toddler
    case preschool

    init(monthAge: Int) {
        switch monthAge {
        case 0:
            self = .newborn
        case 1..<3:
            self = .earlyInfant
        case 3..<6:
            self = .infant
        case 6..<12:
            self = .crawler
        case 12..<24:
            self = .toddler
        default:
            self = .preschool
        }
    }

    func feedingBody(feedingType: String) -> String {
        switch self {
        case .newborn:
            return "以按需喂养为主，留意吞咽、尿量和精神状态。当前喂养方式：\(feedingType)。"
        case .earlyInfant:
            return "继续保持规律观察，宝宝饿了、困了、需要安抚时信号会更清楚。当前喂养方式：\(feedingType)。"
        case .infant:
            return "奶仍是主要营养来源，白天可慢慢建立更稳定的喂养节奏。"
        case .crawler:
            return "辅食从少量、单一、细腻开始推进，新食材连续观察 2-3 天。"
        case .toddler:
            return "一日三餐逐渐稳定，点心少量即可，尽量保持食物多样。"
        case .preschool:
            return "鼓励自主进食，主食、蛋白质、蔬果搭配，少用零食替代正餐。"
        }
    }

    var feedingTip: String {
        switch self {
        case .newborn, .earlyInfant, .infant:
            return "不要强迫宝宝喝完固定量，先看宝宝状态和生长趋势。"
        case .crawler:
            return "添加辅食时避开整颗坚果、硬糖等容易噎住的食物。"
        case .toddler, .preschool:
            return "饭桌气氛轻松一点，吃饭会更顺。"
        }
    }

    var sleepBody: String {
        switch self {
        case .newborn:
            return "睡眠还很碎片化，白天黑夜节律正在慢慢建立。"
        case .earlyInfant:
            return "可以尝试固定睡前流程，比如换尿布、调暗灯光、轻声安抚。"
        case .infant:
            return "白天小睡和夜间睡眠逐渐可预测，睡前保持安静环境。"
        case .crawler:
            return "活动量增加后，规律小睡和睡前流程会帮助宝宝更稳地入睡。"
        case .toddler:
            return "午睡不宜太晚，晚上保持一致的入睡节奏。"
        case .preschool:
            return "睡前减少兴奋游戏和屏幕刺激，给宝宝一点缓冲时间。"
        }
    }

    var sleepTip: String {
        "仰卧睡、床面平整，睡眠环境清爽简单。"
    }

    var interactionBody: String {
        switch self {
        case .newborn:
            return "抱一抱、看一看、轻声说话，就是很好的亲子互动。"
        case .earlyInfant:
            return "可以和宝宝面对面说话，回应咿呀声，帮助建立安全感。"
        case .infant:
            return "试试趴玩、追视玩具和简单儿歌，时间短一点也没关系。"
        case .crawler:
            return "给宝宝安全空间练习翻身、坐、爬，陪他探索身边的小物件。"
        case .toddler:
            return "一起读图画书、玩积木、模仿声音，鼓励宝宝表达。"
        case .preschool:
            return "可以加入角色扮演、分类游戏和简单规则游戏。"
        }
    }

    var interactionTip: String {
        "互动不需要复杂，稳定回应比玩具数量更重要。"
    }

    var safetyBody: String {
        switch self {
        case .newborn, .earlyInfant:
            return "抱娃、洗澡、换尿布时先准备好物品，避免宝宝独自留在高处。"
        case .infant:
            return "宝宝会更爱抓东西，细小物件、绳带和热饮都要远离。"
        case .crawler:
            return "活动范围变大，插座、桌角、抽屉和小物件需要提前检查。"
        case .toddler:
            return "宝宝开始走跑攀爬，厨房、浴室和阳台要重点看护。"
        case .preschool:
            return "建立简单安全规则，比如过马路牵手、热水不能碰。"
        }
    }

    var safetyTip: String {
        "如果宝宝出现明显不适或异常状态，请及时咨询儿科医生。"
    }
}

