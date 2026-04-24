# 程式碼自動化 (Code Automation)

> 最後更新：2026-04-23

## 什麼是程式碼自動化？
程式碼自動化是利用 OpenClaw 的 Coding Agent Skill，透過自然語言指令讓 AI 自主執行程式碼的讀取、修改、建立、刪除、執行測試、建置、部署以及 Git 操作等完整開發流程。與傳統的程式碼補全工具不同，Coding Agent 作為一個自主代理人，能夠規劃多步驟任務、自行偵錯並自我修正，從「修復這個錯誤」到「為我建構一個 REST API」都能在無需逐步微管理的情況下完成。

## 安裝 / 環境需求
- OpenClaw 已安裝並完成基本 onboarding（參考 02-environment-setup）
- 安裝 Coding Agent Skill：
  ```bash
  npx clawhub install coding-agent
  ```
- 建議使用具備良好程式碼生成能力的語言模型（如 Claude Opus 4.6、Claude Sonnet 4.6 或 Claude Haiku 4.5），並透過 `config set` 調整至適當的模型。
- 安裝 Git（用於版本控制）以及專案所需的建置工具（例如 Node.js、Python、編譯器等）。
- 為了安全，建議在隔離的開發環境（如 Docker 容器或虛擬機）中使用，並確保所有代碼受 Git 版本控管。

```bash
# 確認 Coding Agent 已安裝
openclaw doctor

# 安裝 Coding Agent（若尚未安裝）
npx clawhub install coding-agent

# 查看已安裝的 Skills
skill list

# 設定推薦模型（以 Claude Sonnet 4.6 為例）
config set llm.model claude-sonnet-4-20250514
config set llm.baseUrl https://api.anthropic.com/v1
# 請替換為您的實際 API Key（請勿提交至版本控制）
config set llm.apiKey sk-ant-your-api-key-here
```

## 核心概念
Coding Agent 的運作主要包含以下元件：
1. **程式碼讀取**：瀏覽專案結構，理解程式邏輯與相依關係。
2. **檔案修改**：建立、編輯或刪除原始碼檔案。
3. **命令執行**：在 Shell 中執行測試、建置與部署命令。
4. **Git 操作**：提交變更、建立分支、推送至遠端儲存庫。
5. **自我修正**：當測試失敗或編譯錯誤發生時，自動分析並修正錯誤。
6. **安全沙箱**：透過 OpenClaw 的權限設定，限制 Agent 能執行的 Shell 指令範圍，避免對系統造成不可預期的變更。
7. **工作區隔離**：建議為不同專案使用不同的 Workspace，以避免上下文混雜。

## CLI 指令說明
雖然程式碼自動化主要透過自然語言觸發，但 OpenClaw 提供以下相關 CLI 指令協助管理與設定：

```bash
# 查看 Coding Agent 狀態
skill info coding-agent

# 啟用/停用 Coding Agent
skill enable coding-agent
skill disable coding-agent

# 更新 Coding Agent 至最新版本
npx clawhub install coding-agent

# 設定模型參數（範例）
config set llm.model claude-sonnet-4-20250514
config set llm.maxTokens 4000
config set llm.temperature 0.2

# 查看目前模型設定
config get llm

# 開啟/關閉安全沙箱（需謹慎）
config set agents.defaults.sandbox.enabled true
config set agents.defaults.sandbox.allowedCommands "git,npm,node,python,pip"
```

## 實際應用範例

### 場景一：修復登入頁面錯誤訊息
描述：登入頁面在輸入錯誤密碼時未顯示錯誤訊息，需要找出問題並修復。

**自然語言指令：**
```
登入頁面不會在輸入錯誤密碼時顯示錯誤訊息。找出問題並修復它。
```

**Agent 的執行流程：**
1. **掃描相關檔案**：Agent 會根據上下文尋找登入頁面相關的檔案（例如 `src/components/Login.jsx`、`src/pages/login.js` 等）。
2. **理解程式邏輯**：分析現有程式碼，找出負責處理登入表單提交與錯誤顯示的部分。
3. **執行修改**：在適當的位置加入錯誤訊息的狀態管理與渲染邏輯。
4. **執行測試**：如果專案有測試套件，Agent 會自動執行相關測試以確認修改未破壞既有功能。
5. **提交變更**：將修改提交至 Git，並可選擇性地推送至遠端分支。
6. **回報結果**：向使用者說明已找到問題（例如：錯誤訊息狀態未被設定）並已修補。

### 場景二：建立帶有認證的 REST API
描述：需要建立一個 Express.js REST API，具備使用者資源的 CRUD endpoint、JWT 認證 middleware、輸入驗證以及對應的單元測試。

**自然語言指令：**
```
建立一個 Express.js REST API，具有 /users 的 CRUD endpoint、JWT 認證 middleware、輸入驗證，並寫 corresponding 單元測試。
```

**Agent 的執行流程：**
1. **規劃專案結構**：建立必要的目錄與檔案（例如 `src/`、`src/routes/`、`src/middleware/`、`src/controllers/`、`src/tests/` 等）。
2. **安裝相依套件**：執行 `npm install express jsonwebtoken zod`（或使用專案既有的套件管理方式）。
3. **建立伺服器入口**：建立 `src/index.js`，設定 Express 應用程式、中介軟載入與路由註冊。
4. **實作路由與控制器**：在 `src/routes/users.js` 中定義 CRUD endpoint，將業務邏輯委派給 `src/controllers/userController.js`。
5. **加入 JWT 認證**：建立 `src/middleware/auth.js`，驗證請求標頭中的 JWT token。
6. **添加輸入驗證**：使用 zod 或 joi 在每個 endpoint 中驗證請求體與查詢參數。
7. **編寫單元測試**：在 `src/tests/` 中建立測試檔案，使用 jest 或 mocha 測試每個 endpoint 的功能與錯誤處理。
8. **執行測試與修正**：Agent 會自動執行測試，根據失敗結果修正程式碼，直到所有測試通過。
9. **Git 提交**：將所有變更提交至 Git，並附上有意義的提交訊息。
10. **完成回報**：向使用者說明 API 已建立完成，並提供如何啟動伺服器與執行測試的指令。

## 應用主題分類

| 主題 | 適用場景 | 複雜度 |
|------|---------|-------|
| 股票分析自動化 | 個人投資決策、投資研究、模擬交易練習 | ⭐⭐⭐ |
| 程式碼自動化 | 錯誤修複、功能開發、重構、測試編寫、建置部署 | ⭐⭐⭐ |
| 文件分析 | 法務文件審查、財報解讀、研究論文摘要 | ⭐⭐⭐ |
| 自動化學習 | 個性化課程推薦、知識圖譜建設、語言學習 | ⭐⭐ |
| 資料收集與整理 | 網路爬蟲、競爭情報監視、學術文獻蒐集 | ⭐⭐⭐ |

## 常見問題與排錯

| 問題 | 原因 | 解法 |
|------|------|------|
| Agent 沒有回應或卡住 | 模型回應超時或上下文過長 | 檢查模型設定，增加 timeout 或減少上下文大小；重新啟動 OpenClaw 會話 |
| 修改的程式碼無法執行 | 語法錯誤或缺少相依套件 | 檢查 Agent 的修改內容，手動執行建置或測試以確認錯誤；必要時提供更明確的指令 |
| Agent 建立了不必要的檔案 | 指令描述不夠精確 | 在後續指令中提供更詳細的上下文或限制範圍；使用 Workspace 隔離 |
| Git 操作失敗 | 沒有設定 Git 認證或遠端倉庫不可達 | 確認 git config 中的使用者名稱與信箱，或設定 SSH 金鑰/Personal Access Token |
| 安全沙箱阻止了必要命令 | 沒有將所需命令加入允許清單 | 透過 `config set agents.defaults.sandbox.allowedCommands` 加入所需命令（例如 `git, npm, node, python, pip`） |
| 測試失敗但 Agent 無法自行修正 | 錯誤過於複雜或需要架構層面的變更 | 介入提供更高階的指令或將任務拆解為更小的子任務；檢查是否需要更新模型或提供更多範例程式碼 |

## 參考資源
- [官方文件](https://docs.openclaw.ai) — 最新官方說明
- [GitHub](https://github.com/openclaw/openclaw) — 原始碼與 Issues
- [Discord](https://discord.gg/clawd) — 社群討論
- [OpenClaw Coding Agent Complete Guide: Automating Software Development with AI Agent Workflows](https://www.meta-intelligence.tech/en/insight-openclaw-coding-agent) — 安裝、設定與實作工作流程詳解
- [OpenClaw Tutorial 2026: Complete Beginner to Advanced Guide](https://www.meta-intelligence.tech/en/insight-openclaw-tutorial) — 基礎安裝與設定
- [OpenClaw AI Agent Automation Tutorial 2026: Complete Guide](https://www.howto-do.it/openclaw-ai-agent-automation-tutorial-2026/) — 多代理人系統與工作流程 orchestration

---
*此文件由 AI agent 自動生成，最後更新：2026-04-23*