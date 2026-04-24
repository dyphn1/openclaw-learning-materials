# OpenClaw 簡介與安裝 (Introduction and Installation)

> 最後更新：2026-04-22

## 什麼是 OpenClaw？
OpenClaw 是一個開源的個人 AI 數位助理框架，設計用於在各種通訊平台（如 WhatsApp、Telegram、Discord 等）上提供智能自動化服務。它允許用戶透過自然語言與 AI 模型互動，執行任務如訊息自動回覆、檔案操作、網頁抓取、工作流程自動化等。OpenClaw 強調本地運行和資料隱私，支持連接多種開源和商業 AI 模型（如 Claude、DeepSeek、GPT 等），同時提供豐富的技能（Skill）擴展機制，讓開發者可以自行添加功能。

## 安裝 / 環境需求
- **Node.js 版本 ≥ 22**（建議使用 LTS 版本）
- **npm 或 pnpm** 作為套件管理器
- 支援的作業系統：macOS、Linux（包括 WSL）、Windows
- 為避免安全風險，建議在安裝後將 Canvas Host 元件的綁定位址改為 127.0.0.1

### 安裝步驟（以 macOS 為例）：
```bash
# 1. 克隆存儲庫
git clone https://github.com/openclaw/openclaw.git
cd openclaw

# 2. 安裝依賴
pnpm install

# 3. 建置專案
pnpm build

# 4. 首次運行並按照提示進行設定（如選擇通訊平台、設定 API 金鑰等）
pnpm dev
```

### 透過 npm 全域安裝（替代方案）：
```bash
npm install -g openclaw
openclaw setup
```

## 核心概念
OpenClaw 的架構主要由以下幾個部分組成：
1. **核心框架**：提供執行環境、工具調用、記憶體管理等基礎功能。
2. **通道插件 (Channel Extensions)**：負責與不同通訊平台（如 Discord、Telegram）的連接和訊息傳遞。
3. **技能系統 (Skills)**：透過模組化的技能擴展功能，每個技能是一個獨立的功能包。
4. **代理人 (Agents)**：負責理解使用者意圖、選擇適當的工具和技能來執行任務。
5. **設定與配置**：透過設定檔管理通訊平台參數、AI 模型選擇、技能啟用等。

運作流程簡述：
- 使用者透過支援的通訊平台發送訊息給 OpenClaw。
- 通道插件接收訊息並傳遞給核心框架。
- 核心框架解析訊息內容，決定使用哪個代理人或技能進行處理。
- 代理人可能調用工具（如檔案操作、網頁抓取）或 AI 模型來生成回應。
- 處理結果經過同樣的通道插件回傳給使用者。

## CLI 指令說明
OpenClaw 提供豐富的命令列介面進行設定、調試和執行特定操作。以下是一些常用指令：

```bash
# 查看所有可用指令
openclaw --help

# 登入特定通訊平台（例如 Discord）
openclaw login discord

# 查看當前設定
openclaw config show

# 啟用或禁用技能
openclaw skills enable <skill-name>
openclaw skills disable <skill-name>

# 重新載入設定而無需重啟
openclaw reload

# 查看日誌
openclaw logs
```

## 實際應用範例

### 場景一：自動回覆 WhatsApp 訊息
透過設定 WhatsApp 通道並啟用自動回覆技能，OpenClaw 可以自動分析來訊並根據預設規則或 AI 模型生成適當的回覆。
```bash
# 設定 WhatsApp（需事先準備好對應的憑證）
openclaw setup whatsapp
# 啟用自動回覆技能
openclaw skills enable auto-reply
# 重新載入設定
openclaw reload
```

### 場景二：透過 Telegram 執行檔案搜尋與摘要
使用者可以在 Telegram 上向 OpenClaw 指令搜尋本機檔案並取得內容摘要。
```bash
# 設定 Telegram 機器人
openclaw setup telegram
# 啟用檔案系統技能
openclaw skills enable filesystem
# 在 Telegram 對話中發送：/search 會議紀錄.pdf
# OpenClaw 會回傳檔案摘要或相關內容
```

## 應用主題分類

| 主題 | 適用場景 | 複雜度 |
|------|---------|-------|
| 股票分析 | 自動抓取股票資訊、生成投資報告 | ⭐⭐⭐ |
| 自動寫 code | 根據描述生成程式碼片段、重構現有程式 | ⭐⭐ |
| 文件分析 | 摘要長文檔案、提取關鍵資訊、翻譯文件 | ⭐⭐ |

## 常見問題與排錯
| 問題 | 原因 | 解法 |
|------|------|------|
| 安裝後無法啟動 | Node.js 版本過舊 | 升級 Node.js 至 v22 或以上 |
| 通訊平台連線失敗 | API 金鑰或憑證設定錯誤 | 重新執行 `openclaw setup <platform>` 並依照提示輸入正確資訊 |
| 技能載入失敗 | 相依的 npm 套件未安裝 | 檢查技能對應的 package.json 並執行 `pnpm install` |
| 本機檔案存取被拒絕 | 權限設定問題 | 確保 OpenClaw 有權限存取目標目錄，或在設定中調整存取範圍 |
| 回應延遲過高 | AI 模型回應時間長或網路問題 | 考慮使用本地模型或調整超時設定 |

## 參考資源
- [官方文件](https://docs.openclaw.ai) — 最新官方說明
- [GitHub](https://github.com/openclaw/openclaw) — 原始碼與 Issues
- [Discord](https://discord.gg/clawd) — 社群討論
- [安裝教學 2026：macOS/Linux/Windows 全平台](https://www.shareuhack.com/zh-TW/posts/openclaw-setup-tutorial-2026) — 詳細安裝步驟與安全加固
- [OpenClaw 入門：15 分鐘內從零開始建立你的第一個 AI 代理](https://openclaws.io/zh-TW/blog/openclaw-101-beginners-guide/) — 新手友好的快速開始指南

---
*此文件由 AI agent 自動生成，最後更新：2026-04-22*