# 通道整合（WhatsApp/Telegram/Discord 等） (Channel Integration)

> 最後更新：2026-04-26
> 完整性狀態：已深度整合最新安全修復（v2026.4.23）、結構化物件處理機制、plugin approval gates 與訪問控制模型
> 相關原始碼：`src/extensions/whatsapp/`、`src/extensions/discord/`、`src/extensions/telegram/`、`src/gateway/security/`、`src/cli/security-cli.ts`

## 什麼是通道？
在 OpenClaw 中，**通道（Channel）** 是指與各種通訊平台（如 WhatsApp、Telegram、Discord、Slack 等）連接的介面，使得 OpenClaw 能夠在這些平台上接收訊息、發送回應，並執行自動化任務。每個通道都是一個獨立的擴展（extension），透過統一的介面與 OpenClaw 核心框架互動。

## 支援的通道
OpenClaw 透過其豐富的擴展生態系統支援多種通訊平台。以下是一些主要支援的通道（對應 `extensions/` 目錄下的資料夾）：

### 核心支援通道
- **Discord** (`extensions/discord`)：連接 Discord 伺服器，支援文字訊息、斜線指令、互動元件。
- **Telegram** (`extensions/telegram`)：透過 Bot API 連接 Telegram，支援私聊、群組、頻道。
- **WhatsApp** (`extensions/whatsapp`)：使用 Baileys 库連接 WhatsApp Web/WhatsApp Business。
- **Slack** (`extensions/slack`)：連接 Slack 工作區，支援頻道、私聊、互動訊息。
- **Matrix** (`extensions/matrix`)：連接 Matrix 伺服器（如 Element）。
- **IRC** (`extensions/irc`)：連接傳統 IRC 伺服器。
- **Feishu (Lark)** (`extensions/feishu`)：連接飛書（Lark）平台。

### 專業支援通道
- **Microsoft Teams** (`extensions/msteams`)：Bot Framework；企業支援。
- **Google Chat** (`extensions/googlechat`)：Google Chat API app 透過 HTTP webhook。
- **LINE** (`extensions/line`)：LINE Messaging API bot。
- **Mattermost** (`extensions/mattermost`)：Bot API + WebSocket；頻道、群組、私聊。
- **Nostr** (`extensions/nostr`)：去中心化 DM 透過 NIP-04。
- **QQ Bot** (`extensions/qqbot`)：QQ Bot API；私聊、群組、豐富媒體。
- **Signal** (`extensions/signal`)：signal-cli；注重隱私。
- **Twitch** (`extensions/twitch`)：Twitch chat 透過 IRC 連接。
- **WeChat** (`extensions/wechat`)：騰訊 iLink Bot 插件透過 QR 登錄；僅限私聊。
- **Zalo** (`extensions/zalo`)：Zalo Bot API；越南的熱門信使。
- **Synology Chat** (`extensions/synology-chat`)：Synology NAS Chat 透過出站+入站 webhook。
- **Tlon** (`extensions/tlon`)：基於 Urbit 的信使。

### 語音與媒體通道
- **Voice Call** (`plugins/voice-call`)：透過 Plivo 或 Twilio 的電話語音（插件，單獨安裝）。
- **BlueBubbles** (`extensions/bluebubbles`)：**推薦用於 iMessage**；使用 BlueBubbles macOS 服務器 REST API。

### Web 介面
- **WebChat** (`web/webchat`)：透過 WebSocket 的 Gateway WebChat UI。

> 注意：具體可用的通道取決於已安裝的擴展。您可以透過 `openclaw extensions list` 查看目前可用的擴展。
> **安全提醒**：所有擴展都作為進程內插件運行，僅安裝您信任的來源。

## 安裝 / 環境需求
- **Node.js ≥ 22**（與 OpenClaw 核心需求相同）
- 為特定通道安裝對應的擴展（通常透過 `openclaw extensions install <extension-name>` 或直接克隆至 `extensions/` 目錄）
- 某些通道可能需要額外的帳號、API 金鑰或憑證（例如：Telegram 需要 Bot Token、WhatsApp 需要掃碼登入、Discord 需要 Bot Token 等）

### 安全安裝步驟
通道安裝涉及安全考慮，請遵循以下最佳實踐：

#### Discord 安全設置
```bash
# 1. 確保已安裝 OpenClaw 核心
cd /path/to/openclaw
pnpm install

# 2. 安裝 Discord 擴展
openclaw extensions install discord

# 3. 配置安全設置
openclaw config set channels.discord.dmPolicy pairing
openclaw config set channels.discord.groups."*".requireMention true
openclaw config set tools.deny '["group:automation", "group:runtime", "group:fs"]'

# 4. 驗證配置
openclaw security audit
```

#### WhatsApp 安全設置
```bash
# 1. 安裝 WhatsApp 擴展
openclaw extensions install whatsapp

# 2. 配置 DM 政策
openclaw config set channels.whatsapp.dmPolicy pairing
openclaw config set channels.whatsapp.groups."*".requireMention true

# 3. 設置會話隔離
openclaw config set session.dmScope per-channel-peer

# 4. 啟動並配對
openclaw tui --local
# 在 TUI 中掃描 QR 碼進行配對
```

#### Telegram 安全設置
```bash
# 1. 安裝 Telegram 擴展
openclaw extensions install telegram

# 2. 配置安全設置
openclaw config set channels.telegram.dmPolicy pairing
openclaw config set channels.telegram.groups."*".requireMention true

# 3. 設置環境變數（安全儲存 bot token）
export TELEGRAM_BOT_TOKEN="your-bot-token-here"
openclaw config set channels.telegram.token "$(openclaw config get channels.telegram.token --ref-provider default --ref-source env --ref-id TELEGRAM_BOT_TOKEN)"
```

## 安全架構與核心概念

### 信任模型
OpenClaw 採用**個人助理信任模型**，假設每個 gateway 一個可信操作員邊界。這意味著：
- 支援的安全姿態：每個 gateway 一個用戶/信任邊界（建議每個 OS 用戶/主機/VPS 一個邊界）
- **不支援的安全邊界**：一個共享的 gateway/agent 被多個相互不可信或對抗的用戶使用
- 如果需要對抗用戶隔離，請按信任邊界拆分（分開的 gateway + 憑證，理想情況下分開的 OS 用戶/主機）

### 通道安全層次
OpenClaw 的通道安全包含三個主要層次：

1. **觸發授權層**：誰可以觸發代理（DM 政策、群組政策、allowlists、提及門控）
2. **工具爆發半徑層**：工具訪問控制和沙盒隔離
3. **內容可見性層**：補充上下文（回覆正文、引用文本、歷史記錄）如何過濾

#### 觸發授權模型
- **DM 政策** (`dmPolicy` 或 `*.dm.policy`)：控制入站 DM
  - `pairing`（默認）：未知發送者接收配對代碼，bot 忽略訊息直到批准
  - `allowlist`：未知發送者被阻止
  - `open`：允許任何人 DM（需要明確選擇）
  - `disabled`：完全忽略入站 DM

- **群組政策** (`groupPolicy` 和 `groupAllowFrom`)：控制群組內的觸發
  - `allowlist`：僅允許群組 allowlist 中的發送者
  - `mention`：需要明確提及 bot
  - `open`：允許任何人觸發（默認）

#### 工具安全策略
```json5
{
  tools: {
    profile: "messaging",           // 配置文件類型
    deny: ["group:automation", "group:runtime", "group:fs"],
    fs: { workspaceOnly: true },    // 僅工作區文件系統
    exec: { 
      security: "sandbox",         // 執行安全性
      ask: "always"                 // 執行批准要求
    },
    elevated: { enabled: false }    // 禁用提升權限工具
  }
}
```

#### 內容可見性控制
- `contextVisibility: "all"`（默認）：保持補充上下文原樣
- `contextVisibility: "allowlist"`：過濾補充上下文為 allowlist 允許的發送者
- `contextVisibility: "allowlist_quote"`：類似 allowlist，但仍保留一個明確的引用回覆

## 最新安全修復（v2026.4.23）

### 1. QQBot 安全修復
**問題**：未經授權的 QQ 發送者可以通過未經身份驗證的預分發斜線命令路徑更改執行批准設置。

**修復**：要求框架身份驗證用於 `/bot-approve` 命令。

**實施細節**：
- QQBot 插件強制執行框架身份驗證用於批准命令
- 防止未經授權的執行批准設置更改
- 修復 ID：#70706

### 2. MCP 工具安全修復
**問題**：ACPX OpenClaw 工具橋接可能列舉或調用所有者專用工具（如 `cron`），造成權限提升路徑。

**修復**：阻止 ACPX OpenClaw 工具橋接列出或調用所有者專用工具。

**實施細節**：
- 在 MCP 整合中添加限制
- 關閉非所有者 MCP 調用者的權限提升路徑
- 修復 ID：#70698

### 3. WhatsApp 和群組聊天安全修復
**問題**：聯繫人/vCard/位置結構化物件包含在內聯訊息體中，可能隱藏提示注入負載。

**修復**：將結構化物件從內聯訊息體中移除，通過柵欄不可信元數據 JSON 渲染。

**實施細節**：
- 限制名稱、電話字段和位置標籤/註釋中的隱藏提示注入負載
- 保持結構化數據的功能性，同時增加安全性

### 4. 群組聊天安全改進
**問題**：來自通道源的群組名稱和參與者標籤包含在內聯群組系統提示中。

**修復**：將群組名稱和參與者標籤通過柵欄不可信元數據 JSON 渲染。

### 5. Feishu 啟動改進
**問題**：Feishu 設置在捆綁運行時依賴階段之前導入 Lark SDK。

**修復**：通過僅設置裝載表面加載 Feishu 設置，延遲 Lark SDK 導入。

### 6. 插件啟動改進
**問題**：Telegram/Discord 在缺少依賴修復後 crash-looping。

**修復**：恢復捆綁插件 `openclaw/plugin-sdk/*` 解析從包裝安裝和外部運行時依賴階段根目錄。

## 核心概念
每個通道擴展通常包含：
- **連線管理**：負責建立與維護與平台的連線（如 WebSocket、長輪詢）。
- **事件處理**：接收平台事件（如新訊息、反應更新）並轉發至 OpenClaw 核心。
- **動作執行**：根據核心指令發送訊息、修改訊息、執行平台特定操作（如添加反應、修改狀態）。
- **設定介面**：透過 OpenClaw 設定系統讀取和更新通道特定參數（如 Token、前綴、權限等）。

運作流程：
1. 使用者在支援的平台上發送訊息或觸發事件。
2. 通道擴展接收事件並將其格式化為 OpenClaw 內部訊息格式。
3. 內部訊息被傳遞給 OpenClaw 核心框架進行意圖解析和技能路由。
4. 核心框決策使用哪個技能或代理人來處理請求。
5. 處理結果（如訊息回覆、執行狀態）返回給通道擴展。
6. 通道擴展將結果轉換為平台特定格式並發送回平台。

## CLI 指令說明
OpenClaw 提供統一的 CLI 來管理通道。以下是一些常用指令（假設已安裝對應擴展）：

```bash
# 列出所有可用的通道擴展
openclaw extensions list

# 安裝新通道擴展（例如 Telegram）
openclaw extensions install telegram

# 移除通道擴展
openclaw extensions remove telegram

# 顯示特定通道的當前設定
openclaw config get channels.telegram

# 更新通道設定（例如設置 Telegram Bot Token）
openclaw config set channels.telegram.token "123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11"

# 啟用或禁用通道
openclaw channels enable telegram
openclaw channels disable telegram

# 重新載入通道設定（無需重啟整個應用）
openclaw reload

# 查看通道日誌（除錯連線問題時很有用）
openclaw logs --channel telegram
```

## 實際應用範例

### 場景一：在 Discord 上建立自動回覆機器人
目標：當成員在特定頻道發送訊息時，OpenClaw 自動分析並回覆摘要或建議。

**步驟：**
1. 安裝 Discord 擴展：
   ```bash
   openclaw extensions install discord
   ```
2. 設定 Discord Bot Token（在 Discord 開發者門戶建立應用並取得 Token）：
   ```bash
   openclaw config set channels.discord.token "YOUR_BOT_TOKEN"
   ```
3. （可選）設置機器人應該監聽的頻道 ID（若為空則監聽所有可讀取的頻道）：
   ```bash
   openclaw config set channels.discord.channelIds "['123456789012345678']"
   ```
4. 啟用自動回覆或 AI 聊天技能：
   ```bash
   openclaw skills enable auto-reply   # 或 openclaw skills enable chat
   ```
5. 重新載入設定：
   ```bash
   openclaw reload
   ```
6. 邀請機器人到您的 Discord 伺服器並授予閱讀/發送訊息權限。
7. 在伺服器中向機器人發送訊息，觀察其回覆。

### 場景二：透過 Telegram 接收每日天氣預報
目標：每天早上 7:00，OpenClaw 自動抓取天氣資訊並發送給您的 Telegram 私聊。

**步驟：**
1. 安裝 Telegram 擴展：
   ```bash
   openclaw extensions install telegram
   ```
2. 設定 Telegram Bot Token（透過 @BotFather 建立機器人並取得 Token）：
   ```bash
   openclaw config set channels.telegram.token "YOUR_BOT_TOKEN"
   ```
3. 取得您的 Telegram 用戶 ID（可透過 @userinfobot 獲取）：
   ```bash
   openclaw config set channels.telegram.chatId "123456789"
   ```
4. 安裝並設定天氣技能（假設存在 `weather` 技能）：
   ```bash
   openclaw skills install weather
   openclaw skills enable weather
   # 設定天氣技能的參數（如 API Key、地點等）
   openclaw config set skills.weather.location "Taipei"
   openclaw config set skills.weather.apiKey "YOUR_WEATHER_API_KEY"
   ```
5. 建立每日排程任務（使用 Cron）：
   ```bash
   openclaw cron add "0 7 * * *" "openclaw skills run weather --target telegram --chatId $(openclaw config get channels.telegram.chatId)"
   ```
6. 重新載入設定：
   ```bash
   openclaw reload
   ```
7. 每天早上 7:00，您將在 Telegram 上收到天氣預報。

## 進階安全場景

### 場景一：企業級 Discord 安全部署
**背景說明**：在企業環境中部署 Discord 通道，需要嚴格的訪問控制和審計功能。

**完整步驟**：
```bash
# 1. 配置嚴格的 DM 政策
openclaw config set channels.discord.dmPolicy allowlist
openclaw config set channels.discord.allowFrom '["user:123456789", "user:987654321"]'

# 2. 設置群組級別控制
openclaw config set channels.discord.groupPolicy allowlist
openclaw config set channels.discord.groupAllowFrom '["role:admin", "role:developer"]'
openclaw config set channels.discord.guilds '["123456789"]'

# 3. 配置工具安全策略
openclaw config set tools.profile minimal
openclaw config set tools.deny '["group:automation", "group:runtime", "group:fs", "exec", "browser"]'
openclaw config set tools.exec.security deny

# 4. 啟用審計日誌
openclaw config set logging.level debug
openclaw config set logging.channels.enabled true

# 5. 驗證配置
openclaw security audit --deep
```

**預期結果**：
- 只有指定的 Discord 用戶和角色可以觸發 bot
- 禁用所有高風險工具，僅保留基本訊息功能
- 完整的審計日誌記錄所有活動

### 場景二：WhatsApp 安全隔離部署
**背景說明**：在需要高度安全性的環境中使用 WhatsApp，確保不同對話之間的隔離。

**完整步驟**：
```bash
# 1. 配置 DM 會話隔離
openclaw config set session.dmScope per-channel-peer

# 2. 設置嚴格的 DM 政策
openclaw config set channels.whatsapp.dmPolicy pairing
openclaw config set channels.whatsapp.pendingRequests.max 3

# 3. 配置群組控制
openclaw config set channels.whatsapp.groups."*".requireMention true

# 4. 設置工具限制
openclaw config set tools.deny '["group:automation", "group:runtime", "group:fs", "exec", "browser", "web_fetch", "web_search"]'

# 5. 啟動並監控
openclaw tui --local --deliver

# 6. 監控配對請求
openclaw pairing list whatsapp
```

**預期結果**：
- 每個 WhatsApp 聯繫人都有獨立的會話隔離
- 所有 DM 都需要配對批准
- 禁用所有網絡和文件系統工具
- 完整的配對請求監控

### 場景三：多通道統一安全策略
**背景說明**：在多通道環境中統一安全策略，確保一致的訪問控制。

**完整步驟**：
```bash
# 1. 創建統一配置
openclaw config set session.dmScope per-channel-peer
openclaw config set tools.profile messaging
openclaw config set tools.deny '["group:automation", "group:runtime", "group:fs", "sessions_spawn", "sessions_send"]'

# 2. 為所有通道設置 DM 政策
openclaw config set channels.telegram.dmPolicy pairing
openclaw config set channels.slack.dmPolicy pairing
openclaw config set channels.discord.dmPolicy pairing
openclaw config set channels.whatsapp.dmPolicy pairing

# 3. 設置群組提及要求
openclaw config set channels.telegram.groups."*".requireMention true
openclaw config set channels.slack.groups."*".requireMention true
openclaw config set channels.discord.groups."*".requireMention true

# 4. 啟用審計
openclaw config set logging.redactSensitive tools
openclaw config set diagnostics.enabled true

# 5. 驗證整體安全性
openclaw security audit --fix
```

**預期結果**：
- 所有通道都有一致的 DM 配對政策
- 統一的工具安全策略
- 完整的審計和診斷功能

## Plugin Approval Gates

OpenClaw 的插件系統包含安全閘道，即使在本機模式下也保持安全性：

### 1. 插件安全隔離
- 所有插件都作為進程內代碼運行
- 插件加載前執行內置危險代碼掃描
- `critical` 發現會默認阻止
- 使用 `npm pack`，然後在目錄中運行 `npm install --omit=dev --ignore-scripts`

### 2. 插件配置安全
```json5
{
  plugins: {
    entries: {
      discord: {
        permissionMode: "approve-all",  // 危險：僅用於調試
        allowedCommands: ["send", "list"]
      }
    }
  }
}
```

### 3. 安全插件管理
```bash
# 安裝插件（自動掃描）
openclaw extensions install discord

# 手動檢查插件安全性
openclaw security audit --deep

# 禁用危險插件功能
openclaw config set plugins.entries.discord.permissionMode "default"
```

## 應用主題分類

| 主題 | 適用場景 | 複雜度 |
|------|---------|-------|
| 多平台同步訊息 | 在 WhatsApp、Telegram、Discord 間同步重要通知 | ⭐⭐⭐ |
| 平台特定自動化 | 在 Slack 上執行 DevOps 指令，在 Telegram 上接收警報 | ⭐⭐ |
| 聊天機器人與客服 | 建立能夠回答常見問題的 AI 客服機器人 | ⭐⭐ |

## 常見問題與排錯
| 問題 | 原因 | 解法 |
|------|------|------|
| 連線失敗（顯示「未授權」或「無效Token」） | API 金鑰或 Token 錯誤或過期 | 重新取得有效的 Token 並更新設定 |
| 收不到訊息 | 機器人沒有被邀請到群組/頻道，或缺少閱讀權限 | 確認機器人已加入目標位置並具備必要權限 |
| 發送訊息失敗 | 缺少發送權限或訊息格式不符合平台規範 | 檢查平台對機器人帳號的發送權限，調整訊息長度或格式 |
| 頻繁斷線 | 網路不穩或平台對連線頻率有限制 | 檢查網路連線，考慮增加重試機制或使用平台推薦的連線方式 |
| 延遲過高 | 機器人伺服器與平台伺服器地理距離遠，或處理過程複雜 | 選擇地理位置較近的伺服器hosting，優化技能執行效率 |
| 擴展載入失敗 | 缺少相依的 npm 套件或版本不相容 | 進入擴展目錄執行 `pnpm install`，確保 Node.js 版本符合擴展需求 |

## 參考資源
- [官方文件 - 通道整合指南](https://docs.openclaw.ai/channels) — 最新官方說明
- [官方安全文件](https://docs.openclaw.ai/gateway/security) — 安全架構與審計指南
- [GitHub OpenClaw Extensions](https://github.com/openclaw/openclaw/tree/main/extensions) — 原始碼與範例
- [Discord 通道設定教學](https://docs.openclaw.ai/channels/discord) — Discord 特定設定
- [Telegram 通道設定教學](https://docs.openclaw.ai/channels/telegram) — Telegram 特定設定
- [WhatsApp 通道設定教學](https://docs.openclaw.ai/channels/whatsapp) — WhatsApp 特定設定（注意使用官方 API 以避免封號）
- [ClawHub - 官方擴展市場](https://clawhub.ai) — 瀏覽和安裝社區擴展
- [OpenClaw Discord 社群](https://discord.gg/clawd) — 取得即時幫助與範例分享
- [通道安全參考資料](references/channels-security-ref.md) — 詳細的安全修復與最佳實踐

---
*此文件由 AI agent 自動生成並持續更新*

## 更新記錄
- 2026-04-26：深度整合 v2026.4.23 安全修復，新增 QQBot、MCP 工具、WhatsApp 結構化物件安全處理機制，plugin approval gates，以及進階安全場景（企業級部署、WhatsApp 隔離、多通道統一策略）