# 通道整合（WhatsApp/Telegram/Discord 等） (Channel Integration)

> 最後更新：2026-04-22

## 什麼是通道？
在 OpenClaw 中，**通道（Channel）** 是指與各種通訊平台（如 WhatsApp、Telegram、Discord、Slack 等）連接的介面，使得 OpenClaw 能夠在這些平台上接收訊息、發送回應，並執行自動化任務。每個通道都是一個獨立的擴展（extension），透過統一的介面與 OpenClaw 核心框架互動。

## 支援的通道
OpenClaw 透過其豐富的擴展生態系統支援多種通訊平台。以下是一些主要支援的通道（對應 `extensions/` 目錄下的資料夾）：

- **Discord** (`extensions/discord`)：連接 Discord 伺服器，支援文字訊息、斜線指令、互動元件。
- **Telegram** (`extensions/telegram`)：透過 Bot API 連接 Telegram，支援私聊、群組、頻道。
- **WhatsApp** (`extensions/whatsapp`)：使用 Baileys 库連接 WhatsApp Web/WhatsApp Business。
- **Slack** (`extensions/slack`)：連接 Slack 工作區，支援頻道、私聊、互動訊息。
- **Matrix** (`extensions/matrix`)：連接 Matrix 伺服器（如 Element）。
- **SMS/電話** (`extensions/voice-call`, `extensions/talk-voice`)：透過 Twilio 或類似服務發送/接收語音和簡訊。
- **郵件** (`extensions/email`)：透過 SMTP/IMAP 收發電子郵件（此處為範例，實際擴展名可能不同）。
- **IRC** (`extensions/irc`)：連接傳統 IRC 伺服器。
- **Feishu (Lark)** (`extensions/feishu`)：連接飛書（Lark）平台。
- **微信** (`extensions/wechat` 或類似)：部分社區維護的微信機器人擴展。
- **其他**：如 Line、Mattermost、Rocketchat、Twitch、YouTube 等，視社區貢獻而定。

> 注意：具體可用的通道取決於已安裝的擴展。您可以透過 `openclaw extensions list` 查看目前可用的擴展。

## 安裝 / 環境需求
- **Node.js ≥ 22**（與 OpenClaw 核心需求相同）
- 為特定通道安裝對應的擴展（通常透過 `openclaw extensions install <extension-name>` 或直接克隆至 `extensions/` 目錄）
- 某些通道可能需要額外的帳號、API 金鑰或憑證（例如：Telegram 需要 Bot Token、WhatsApp 需要掃碼登入、Discord 需要 Bot Token 等）

### 通用安裝步驟（以 Discord 為例）：
```bash
# 1. 確保已安裝 OpenClaw 核心
cd /path/to/openclaw
pnpm install

# 2. 安裝 Discord 擴展（若尚未內建）
# 方法一：透過 ClawHub（官方擴展市場）
openclaw extensions install discord

# 方法二：手動複製原始碼（以開發或自定義擴展為例）
git clone https://github.com/openclaw/extensions-discord.git extensions/discord
cd extensions/discord
pnpm install

# 3. 返回專案根目錄並重建（若需要）
cd ../..
pnpm build
```

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
- [GitHub OpenClaw Extensions](https://github.com/openclaw/openclaw/tree/main/extensions) — 原始碼與範例
- [Discord 通道設定教學](https://docs.openclaw.ai/channels/discord) — Discord 特定設定
- [Telegram 通道設定教學](https://docs.openclaw.ai/channels/telegram) — Telegram 特定設定
- [WhatsApp 通道設定教學](https://docs.openclaw.ai/channels/whatsapp) — WhatsApp 特定設定（注意使用官方 API 以避免封號）
- [ClawHub - 官方擴展市場](https://clawhub.ai) — 瀏覽和安裝社區擴展
- [OpenClaw Discord 社群](https://discord.gg/clawd) — 取得即時幫助與範例分享

---
*此文件由 AI agent 自動生成，最後更新：2026-04-22*