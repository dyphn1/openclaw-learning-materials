# 環境設定與 onboard (Environment Setup and Onboarding)

> 最後更新：2026-04-22

## 什麼是環境設定與 onboarding？
OpenClaw 的 onboarding 向導是一個互動式設定程序，協助使用者從安裝完成後快速將 OpenClaw 配置為可用的個人 AI 助理。此流程包括：
- 選擇並設定 AI 模型供應商（Provider）
- 輸入 API 金鑰或設定相容端點
- 選擇預設模型
- （可選）連接通訊平台如 Telegram、Discord、WhatsApp 等
- 設定為開機自啟動的守護進程（Daemon）
- 驗證第一次對話以確保一切正常運作

透過 onboarding，即使是完全沒有經驗的使用者也能在數分鐘內讓 OpenClaw 開始運作。

## 安裝 / 環境需求
在執行 onboarding 之前，請確保已完成 OpenClaw 的基本安裝。

### 基本安裝方式
OpenClaw 支援多種安裝方式，任選其一即可：

#### 1. 一鍵腳本安裝（推薦）
```bash
# macOS / Linux
curl -fsSL https://openclaw.ai/install.sh | bash

# Windows (PowerShell)
iwr -useb https://openclaw.ai/install.ps1 | iex
```

#### 2. Docker 部署
參考《OpenClaw Docker 部署指南》。

#### 3. Nix 包管理器
```bash
nix-env -iA nixpkgs.openclaw
```

#### 4. npm 全域安裝
```bash
npm install -g openclaw
```

### 系統需求
- **Node.js 版本 ≥ 22.14+** （建議使用 LTS 版本，如 22.x 或 24.x）
- 支援的作業系統：macOS、Linux（包括 WSL）、Windows
- 網路連線：用於下載依賴、連線 AI 模型供應商及通訊平台
- 磁碟空間：至少 2 GB 可用空間（含依賴套件與快取）

### 安裝後檢查
安裝完成後，可執行以下指令驗證：
```bash
openclaw --version
# 應該顯示類似 v2026.x.x 的版本號

openclaw --help
# 顯示可用指令列表
```

## 核心概念
Onboarding 向導主要分為五個步驟，每個步驟負責設定 OpenClaw 的不同面向：

### 步驟 1：執行 Onboard 命令
```bash
openclaw onboard --install-daemon
```
- `--install-daemon` 旗標會將 OpenClaw 設定為開機自啟動的背景服務（在 macOS 上為 launchd agent，在 Linux 上為 systemd service，在 Windows 上為服務）。
- 向導會引導您完成後續設定，大約需要 2 分鐘。

### 步驟 2：添加 API Provider（AI 模型供應商）
OpenClaw 本身不包含 AI 模型，需要您提供一個相容 OpenAI API 的端點。常見選項包括：
- **國際供應商**：OpenAI、Anthropic (Claude)、Google Gemini、Groq 等（需境外信用卡）。
- **國內友好供應商**（推薦）：如 `ofox.ai`，支援支付寶/微信充值，提供 OpenAI 相容 API。

**設定範例（以 ofox.ai 為例）：**
- Provider Name：`ofox.ai`（可自行命名）
- Base URL：`https://api.ofox.ai/v1`
- API Key：在 ofox.ai 註冊後於「API Keys」頁面生成的金鑰（通常以 `sk-` 開頭）

填寫完畢後點擊「Verify」，若顯示綁定狀態為綠色表示連線成功。

### 步驟 3：選擇預設模型
連通 Provider 後，向導會列出該供應商支援的所有模型。您可根據使用場景選擇預設模型，隨時透過 `/model` 指令切換。

**場景推薦模型：**
- 日常對話/寫作：`claude-sonnet-4-6` 或 `gpt-5.4`
- 複雜推理/程式碼生成：`claude-opus-4-6`
- 高頻調用/節省成本：`deepseek-v4` 或 `minimax-m2-7`
- 國產模型：`kimi-k2-5`、`qwen3.6-plus`、`doubao-seed-2-0`、`glm-5` 等

### 步驟 4：連接通訊平台（可選）
此步驟可先跳過，先讓 AI 跑起來再連接通訊平台。若現在想配置，Telegram 是最簡單的選擇：

1. 在 Telegram 搜尋 `@BotFather`，發送 `/newbot` 建立新機器人。
2. 按照提示命名機器人並取得 Bot Token（形如 `123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11`）。
3. 在 onboarding 向導中將此 Token 填入 Telegram 設定欄位。
4. 完成後向您的機器人發送訊息，OpenClaw 應該會使用您選定的模型回覆。

其他平台如 Discard、WhatsApp、Feishu 等設定較為複雜，請參考對應的平台整合指南。

### 步驟 5：完成向導並驗證 Gateway
Onboard 完成後，請檢查 Gateway 狀態：
```bash
openclaw gateway status
```
應該會顯示監聽在特定端口（預設為 18789），表示服務正在運行。

然後打開控制台：
```bash
openclaw dashboard
```
這會在預設瀏覽器中開啟 OpenClaw 的網路介面。

## 第一次對話：驗證配置
在 Dashboard 的聊天介面中隨便發送一句話，例如：
> 「你好，自我介紹一下」

如果 AI 正常回覆，說明配置沒問題。若沒有回應或出現錯誤，請參考以下排錯表格。

## 常見問題與排錯
| 問題 | 原因 | 解法 |
|------|------|------|
| API Error → Key 填错了或餘額不足 | API 金鑰錯誤、帳號餘額耗盡或未啟用對應模型 | 重新檢查 API Key 是否正確，至供應商後台確認餘額與額度 |
| Connection Timeout → Base URL 不可達 | 網路問題、錯誤的 Base URL 或供應商服務異常 | 檢查網路連線，嘗試更換為已知可用的端點（如 `https://api.ofox.ai/v1`） |
| Model Not Found → 模型名拼錯 | 輸入的模型識別字不在供應商支援列表中 | 在 onboarding 時從模型列表中選擇，或使用 `/model` 指令查看可用模型 |
| 無法開啟 Dashboard | 防火牆阻擋本機埠口或 gateway 未正確啟動 | 檢查 `openclaw gateway status`，確認服務運行中；必要時重新啟動 gateway |
| 通訊平台連線失敗（Telegram 等） | Token 錯誤、機器人未被邀請至群組或缺少權限 | 重新取得有效 Token，確認機器人具備發送訊息與讀取訊息的權限 |
| 開機自啟動失敗 | daemon 服務未正確安裝或權限不足 | 重新執行 `openclaw onboard --install-daemon` 並檢查系統日誌 |

## 進階設定
完成基本 onboarding 後，您可透過以下方式進一步客製化 OpenClaw：

### 修改設定檔
設定檔位於 `~/.clawdbot/config.json`（macOS/Linux）或 `%USERPROFILE%\.clawdbot\config.json`（Windows），可直接編輯以調整：
- AI 供應商參數
- 預設模型
- 通訊平台詳細設定
- 日誌等級
- 工作空間路徑

### 管理技能與代理人
```bash
# 列出已安裝的技能
openclaw skills list

# 安裝新技能（例如檔案系統技能）
openclaw skills install filesystem

# 啟用/禁用技能
openclaw skills enable <skill-name>
openclaw skills disable <skill-name>

# 建立自訂代理人（進階用途）
openclaw agent create --name "my-assistant" --model "claude-sonnet-4-6"
```

### 查看與管理日誌
```bash
# 即時檢視日誌
openclaw logs

# 指定技能或通道的日誌
openclaw logs --skill filesystem
openclaw logs --channel telegram

# 清除日誌
openclaw logs clear
```

## 參考資源
- [官方文件 - Onboarding 指南](https://docs.openclaw.ai/onboard) — 最新官方說明
- [OpenClaw 初始化配置完全指南：从安装到第一次对话（2026）](https://ofox.ai/zh/blog/openclaw-onboard-initialization-guide-2026/) — 詳細步驟與螢幕截圖
- [OpenClaw CLI 初始化向導詳解：用 openclaw onboard 完成首次配置](https://www.boboidea.com/posts/2026-03-14-openclaw-cli-onboarding-wizard-guide/) — CLI 參數與進階選項
- [OpenClaw Docker 部署指南](https://docs.openclaw.ai/docker) — 如何在 Docker 中運行 OpenClaw
- [ClawHub - 技能市場](https://clawhub.ai) — 瀏覽與安裝社區技能
- [OpenClaw Discord 社群](https://discord.gg/clawd) — 取得即時幫助與範例分享

---
*此文件由 AI agent 自動生成，最後更新：2026-04-22*