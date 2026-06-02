# 初芽 App Store Connect 填写清单

## 1. App 基础信息

App 名称：

```text
初芽
```

副标题：

```text
0-3 岁宝宝成长助手
```

SKU：

```text
chuya-ios-mvp
```

Bundle ID：

```text
com.leoren.ChuYa
```

分类建议：

```text
主分类：生活
备选分类：健康健美
```

版本号：

```text
1.0
```

构建号：

```text
2
```

## 2. App 简介

```text
初芽是一款面向 0-3 岁宝宝家庭的每日成长陪伴 App。用户创建宝宝档案后，App 会根据宝宝生日计算月龄，并提供今日喂养、睡眠、亲子互动和安全提醒，同时支持成长记录、育儿问答参考、月龄百科和宝宝成长卡片。
```

## 3. 推广文本

```text
每天一点，陪宝宝长大。初芽帮助新手爸妈按宝宝月龄查看每日养育建议，记录成长变化，并制作温柔的宝宝成长卡片。
```

## 4. 关键词

```text
育儿,宝宝,成长记录,月龄,喂养,睡眠,亲子,母婴,新手妈妈,宝宝卡片
```

## 5. TestFlight 测试说明

```text
本次测试重点是验证本地 MVP 的核心流程是否顺畅：创建宝宝档案、查看今日建议、添加成长记录、使用问问页面、查看月龄百科、制作并保存宝宝成长卡片、查看隐私说明和免责声明。

如发现页面异常、卡顿、保存失败、文案不清楚或流程不顺，请记录复现步骤、设备型号、iOS 版本和截图。
```

## 6. 隐私摘要

当前版本建议填写方向：

```text
当前 MVP 版本的数据仅保存在用户本机，包括宝宝档案、成长记录、问答历史和卡片记录。App 不上传云端，不做云同步，不接入真实 AI API，不包含登录注册功能。用户可以在设置页随时清除本地数据。
```

隐私问卷注意：

- 不用于第三方广告。
- 不用于追踪用户。
- 不上传宝宝档案或成长记录。
- 相册访问仅用于选择宝宝照片和保存成长卡片。
- 如果 App Store Connect 要求声明照片访问，按实际用途填写为用户提供功能所需。

## 7. 免责声明

```text
初芽中的今日建议、月龄百科和问问回答仅供日常育儿参考，不能替代医生诊断、治疗建议或线下问诊。如宝宝出现明显不适、高风险症状或家长无法判断的情况，请及时咨询儿科医生。
```

## 8. 审核备注

```text
初芽第一版为本地 MVP，不包含登录注册、云同步、真实 AI API、支付、会员、商城或社区功能。

App 内育儿内容仅供参考，不提供医生问诊、疾病诊断、处方药建议或用药剂量。对于高风险症状，App 会提示用户及时咨询儿科医生或就医。

当前版本数据仅保存在用户本机，用户可在设置页清除本地数据。
```

## 9. 权限说明

相册读取：

```text
用于选择宝宝照片制作成长卡片。
```

相册写入：

```text
用于将宝宝成长卡片保存到相册。
```

## 10. 上传前检查

- Xcode Build 成功。
- Archive 使用 Release 配置。
- App Icon 已显示。
- Launch Screen 已显示。
- Version 为 `1.0`。
- Build 为 `2` 或更高，且没有和已上传构建重复。
- Bundle ID 为 `com.leoren.ChuYa`。
- 相册权限说明已存在。
- 设置页包含隐私说明和免责声明。
- 问问回答包含免责声明。
- 高风险关键词会提示及时就医。
- 不包含硬编码 API Key。
- 不包含真实支付、会员或云同步入口。

## 11. Archive 命令参考

如果需要命令行构建，可参考：

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild \
  -project ChuYa/ChuYa.xcodeproj \
  -scheme ChuYa \
  -configuration Release \
  -destination generic/platform=iOS \
  -archivePath /private/tmp/ChuYa.xcarchive \
  archive
```

如果只是验证无签名 Build：

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild \
  -project ChuYa/ChuYa.xcodeproj \
  -scheme ChuYa \
  -configuration Debug \
  -destination generic/platform=iOS \
  -derivedDataPath /private/tmp/ChuYaDerivedData \
  CODE_SIGNING_ALLOWED=NO build
```

