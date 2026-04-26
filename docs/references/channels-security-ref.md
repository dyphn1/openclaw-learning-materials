# 通道安全參考資料

> 最後更新：2026-04-26

## 來源清單

### 來源 1：官方通道文件
- **URL**：https://docs.openclaw.ai/channels
- **類型**：官方文件
- **擷取日期**：2026-04-26
- **可信度**：高（官方第一方資料）
- **主要內容摘要**：
  - OpenClaw 支援 20+ 種通訊平台（WhatsApp、Telegram、Discord、Slack、Matrix 等）
  - 每個通道都透過 Gateway 連接，支援文字訊息，媒體和反應因通道而異
  - WhatsApp 需要 QR 配對並在磁碟上存儲更多狀態
  - 快速設計通常是 Telegram（簡單的 bot token）
  - 群組行為因通道而異；DM 配對和 allowlist 為安全而強制執行
- **用於文件的哪個部分**：
  - 通道支援清單、安裝需求、基本安全概念
- **注意事項**：
  - 官方文件提供了基礎安全概念，但缺乏最新安全修復的詳細說明

### 來源 2：官方安全文件
- **URL**：https://docs.openclaw.ai/gateway/security
- **類型**：官方文件
- **擷取日期**：2026-04-26
- **可信度**：高（官方第一方資料）
- **主要內容摘要**：
  - OpenClaw 採用個人助理信任模型，假設每個 gateway 一個可信操作員邊界
  - 安全審計命令：`openclaw security audit`、`openclaw security audit --deep`、`openclaw security audit --fix`
  - 核心安全概念：身份驗證、範圍控制、模型強化
  - DM 政策：`pairing`（配對）、`allowlist`（允許列表）、`open`（開放）、`disabled`（禁用）
  - 群組allowlist和提及門控用於控制群組中的觸發
  - 工具策略：`tools.profile`、`tools.deny`、`tools.exec.security`、`tools.exec.ask`
- **用於文件的哪個部分**：
  - 整體安全架構、審計工具、訪問控制模型、工具安全策略
- **注意事項**：
  - 提供了詳細的安全理論和配置指導，但缺乏針對最新安全修復的具體實施細節

### 來源 3：安全修復說明
- **URL**：https://releasebot.io/updates/openclaw
- **類型**：更新日誌
- **擷取日期**：2026-04-26
- **可信度**：中來源（第三方更新日誌聚合器）
- **主要內容摘要**：
  - QQBot 安全修復：要求框架身份驗證用於 `/bot-approve`，防止未經授權的 QQ 發送者通過未經身份驗證的預分發斜線命令路徑更改執行批准設置
  - MCP 工具安全修復：阻止 ACPX OpenClaw 工具橋接列出或調用所有者專用工具（如 `cron`），關閉非所有者 MCP 調用者的權限提升路徑
- **用於文件的哪個部分**：
  - 最新安全修復的具體細節、漏洞修復說明
- **注意事項**：
  - 提供了修復的高層次摘要，但缺乏原始碼級別的實施細節

### 來源 4：架構文件
- **URL**：https://docs.openclaw.ai/llms.txt
- **類型**：官方文件索引
- **擷取日期**：2026-04-26
- **可信度**：高（官方第一方資料）
- **主要內容摘要**：
  - OpenClaw 文檔索引，包含所有可用頁面的清單
  - 用於在進一步探索之前發現所有可用文檔
- **用於文件的哪個部分**：
  - 文檔結構和資源發現
- **注意事項**：
  - 提供了文檔結構的概覽，幫助理解資料組織方式

## 通道安全架構總結

### 核心安全原則
1. **個人助理信任模型**：每個 gateway 一個可信操作員邊界
2. **訪問控制優先於智能**：決定誰可以與 bot 聊天，bot 被允許在哪裡行動，bot 可以觸摸什麼
3. **工具爆發半徑最小化**：限制高風險工具的訪問

### 通道安全功能
1. **DM 政策控制**：
   - `pairing`：默認，未知發送者接收配對代碼，bot 忽略訊息直到批准
   - `allowlist`：未知發送者被阻止
   - `open`：允許任何人 DM（需要明確選擇）
   - `disabled`：完全忽略入站 DM

2. **群組安全控制**：
   - `groupPolicy` 和 `groupAllowFrom` 控制群組內的觸發
   - `requireMention` 在群組中需要明確提及
   - 群組 allowlist 作為群組級別的門控

3. **工具安全策略**：
   - `tools.profile`：配置文件類型（messaging、minimal、automation、runtime）
   - `tools.deny`：明確拒絕的工具組
   - `tools.exec.security`：執行安全性設置（deny、sandbox、full）
   - `tools.exec.ask`：執行批准要求（always、auto、off）

### 最新安全修復（2026.4.23）
1. **QQBot 安全修復**：
   - 要求框架身份驗證用於 `/bot-approve`
   - 防止未經授權的 QQ 發送者更改執行批准設置
   - 修復 ID：#70706

2. **MCP 工具安全修復**：
   - 阻止 ACPX OpenClaw 工具橋接列出或調用所有者專用工具
   - 關閉非所有者 MCP 調用者的權限提升路徑
   - 修復 ID：#70698

3. **WhatsApp 和群組聊天安全修復**：
   - 將聯繫人/vCard/位置結構化物件從內聯訊息體中移除
   - 通過柵欄不可信元數據 JSON 渲染它們
   - 限制名稱、電話字段和位置標籤/註釋中的隱藏提示注入負載

4. **Feishu 啟動改進**：
   - 通過僅設置裝載表面加載 Feishu 設置
   - 在捆綁運行時依賴階段之後延遲 Lark SDK 導入

## 安全最佳實踐

### 網路暴露最小化
- 偏好 `gateway.bind: "loopback"`（僅本地客戶端）
- 如果必須綁定到 LAN，防火牆限制源 IP
- 永遠不要在未經身份驗證的情況下將 Gateway 暴露在 `0.0.0.0`

### 工具策略強化
- 對於啟用工具的代理，使用 `tools.profile: "messaging"` 或更嚴格
- 拒絕高風險工具：`["group:automation", "group:runtime", "group:fs", "sessions_spawn", "sessions_send"]`
- 啟用沙盒模式以進行隔離執行

### 訪問控制
- 使用 `session.dmScope: "per-channel-peer"` 進行 DM 會話隔離
- 保持 DM 政策為 `pairing` 或 `allowlist`
- 在群組中使用 `requireMention` 以減少意外觸發

### 審計和監控
- 定期運行 `openclaw security audit`
- 監控文件系統權限（`~/.openclaw` 應為 700）
- 檢查配置和憑證的敏感性