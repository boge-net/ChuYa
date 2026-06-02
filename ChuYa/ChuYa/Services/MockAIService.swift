//
//  MockAIService.swift
//  ChuYa
//
//  Created by Codex on 2026-06-02.
//

import Foundation

struct MockAIService: AIServiceProtocol {
    private let highRiskKeywords = [
        "高烧不退",
        "呼吸困难",
        "抽搐",
        "意识不清",
        "持续呕吐",
        "严重腹泻",
        "便血",
        "脱水",
        "嘴唇发紫",
        "精神很差",
        "小月龄发热",
        "误食异物",
        "外伤",
        "严重过敏"
    ]

    func answer(question: String, baby: BabyProfile?) -> String {
        let trimmedQuestion = question.trimmingCharacters(in: .whitespacesAndNewlines)
        let riskKeyword = highRiskKeywords.first { trimmedQuestion.localizedCaseInsensitiveContains($0) }
        let ageContext = baby.map { "宝宝目前约 \(BabyAgeCalculator.calculate(from: $0.birthday).displayText)。" } ?? ""

        if let riskKeyword {
            return """
            需要优先处理：
            问题中提到“\(riskKeyword)”，这属于需要谨慎对待的情况。建议尽快联系儿科医生或前往正规医疗机构评估，不要在家自行拖延观察。

            可能原因：
            这类表现可能和感染、过敏、消化道问题、呼吸问题或其他急性情况有关，需要医生结合体征判断。

            家庭观察点：
            观察宝宝精神状态、呼吸、体温、尿量、皮肤颜色、进食情况，以及症状出现和持续的时间。\(ageContext)

            可以尝试的安全做法：
            保持宝宝在安全舒适的位置，记录体温和症状变化，准备好既往过敏史、喂养情况和最近用过的物品信息。

            需要就医的情况：
            已出现高风险表现时，应尽快就医；如果症状加重、精神差、尿量明显减少或呼吸异常，请立即寻求急诊帮助。

            温馨提醒：
            内容仅供育儿参考，不能替代医生诊断。如宝宝出现明显不适，请及时咨询儿科医生。
            """
        }

        return """
        可能原因：
        宝宝的状态常常和月龄、作息、喂养节奏、环境变化有关。\(ageContext) 目前可以先从最近的睡眠、进食、排便和精神状态一起观察。

        家庭观察点：
        记录问题出现的时间、持续多久、是否反复、宝宝精神和食欲是否和平时不同，也留意体温、尿量和大便变化。

        可以尝试的安全做法：
        先保持规律作息和温和安抚，减少一次性改变太多变量。如果和喂养有关，可以小幅调整节奏，并观察宝宝反馈。

        需要就医的情况：
        如果出现高烧不退、呼吸困难、抽搐、意识不清、持续呕吐、严重腹泻、便血、脱水、嘴唇发紫、精神很差、小月龄发热、误食异物、外伤或严重过敏，请及时就医。

        温馨提醒：
        内容仅供育儿参考，不能替代医生诊断。如宝宝出现明显不适，请及时咨询儿科医生。
        """
    }
}

