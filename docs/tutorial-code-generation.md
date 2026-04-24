# 實戰教學：使用 OpenClaw 進行程式碼生成

> 難度：⭐⭐⭐
> 預計時間：30 分鐘
> 最後更新：2026-04-22

## 前言
本教學將示範如何利用 OpenClaw 的 AI 程式碼生成能力，透過內建的 coding agent（如 Pi、Claude Code、OpenAI Codex）或相關技能，來自動產生、重構、撰寫測試以及執行程式碼審查。您將學會如何設定環境、啟用適當的技能或代理，並透過實際範例體驗從需求描述到可執行程式碼的完整流程。

## 前置條件
- OpenClaw 已安裝並設定完成（可透過 `openclaw onboard` 或 `openclaw setup` 完成初始設定）
- 終端機或命令列介面可用
- 網路連線（以存取外部 AI 模型 API 或下載必要工具）
- （可選）已安裝 Git 並有可用的程式碼倉庫，用於測試生成的程式碼
- 若要使用本地模型（如 Ollama），請確認已安裝並運行相應服務

## 完整步驟

### 步驟 1：安裝程式碼生成相關技能
OpenClaw 提供多種方式來進行程式碼生成。以下是兩種常見做法：

**方式 A：使用內建的 coding agent（Pi）**
Pi 是 OpenClaw 內嵌的程式碼生成助手，無需額外安裝。
```bash
# 確認 Pi 已可用（通常隨 OpenClaw 一起安裝）
openclaw agents list
```
若看不到 Pi，可透過以下方式安裝相關擴展：
```bash
openclaw skills install pi-agent
```

**方式 B：使用外部 coding agent 透過 ACP（Agent Communication Protocol）**
OpenClaw 能夠 spawn 外部 coding agent 如 Claude Code 或 OpenAI Codex。
1. 安裝對應的 ACP 代理（以 Claude Code 為例）：
   ```bash
   # 依照官方文件安裝 Claude Code 並確認可在終端機執行
   claude --version
   ```
2. 確認 OpenClaw 能夠存取該代理（通常透過環境變數或 PATH 設定）。

### 步驟 2：設定預設模型或 coding agent
根據您選擇的方式，設定 OpenClaw 使用哪個模型或代理進行程式碼生成。

**使用內建 Pi（依賴所選 LLM）**：
```bash
# 例如設定使用 OpenAI GPT-4o 作為 Pi 的後端模型
openclaw models set openai/gpt-4o
```

**使用外部 ACP coding agent**：
在需要時，可透過指令明確指定使用哪個 agent（後續步驟會示範）。

### 步驟 3：透過自然語言產生簡單函式
嘗試讓 OpenClaw 根據描述產生程式碼。

在終端機或與 OpenClaw 的聊天介面中輸入：
```
請用 TypeScript 撰寫一個函式，輸入為 Stripe webhook payload，回傳事件類型和客戶 ID。
```
OpenClaw 會：
1. 理解您的需求
2. （如果使用 Pi）呼叫設定好的 LLM 產生程式碼
3. 將產生的程式碼以程式碼區塊形式回傳，並說明其作用

### 步驟 4：將產生的程式碼寫入檔案
若您想直接將程式碼儲存至專案中，可使用以下指令（假設您在專案根目錄）：
```
/write src/stripe/webhook-handler.ts
```
接著貼上產生的程式碼，儲存並離開編輯器。

或者，使用 OpenClaw 的編輯功能：
```
/edit src/stripe/webhook-handler.ts --content "<貼上程式碼>"
```

### 步驟 5：為產生的程式碼撰寫單元測試
良好的程式碼應該伴隨測試。繼續請求 OpenClaw 為剛才的函式撰寫測試：
```
請為上面的 Stripe webhook 處理函式撰寫 Jest 單元測試，涵蓋成功案例和錯誤處理。
```
同樣地，將測試寫入 `src/stripe/webhook-handler.test.ts`。

### 步驟 6：執行測試驗證功能
在終端機中執行測試以確認產生的程式碼如預期運作：
```bash
npm test src/stripe/webhook-handler.test.ts
```
或根據您的專案設定執行對應的測試命令。

### 步驟 7：使用 coding agent 進行較大規模的程式碼重構
當需求涉及多檔案變更或較複雜的重構時，建議 spawn 一個專門的 coding sub-agent。

例如，使用 Claude Code 重構一個服務類：
```
/agent spawn claude-code --task "重構 src/services/user-service.ts，將資料庫操作抽離至 repository 層，保持公開介面不變，並確保所有現有測試仍能通過"
```
OpenClaw 會：
1. 建立一個隔離的 sub-agent 會話
2. 將任務簡報傳遞給 agent
3. agent 執行變更後回報：已修改的檔案、測試結果、commit hash（若適用）
4. 您可以審查變更並決定是否接受

### 步驟 8：設定自動化程式碼審查（進階）
利用 OpenClaw 的 cron 功能，定期檢查 GitHub 上的新 Pull Request 並自動發布程式碼審查備註。

在 AGENTS.md 中加入類似以下的排程（實際參數請依您的情境調整）：
```
cron add \
  --name pr-review \
  --schedule "*/30 * * * *" \
  --agent main \
  --task "檢查 GitHub 最近 30 分鐘內開啟的 PR。對每個 PR：閱讀 diff，發布程式碼審查備註，指出潛在問題、缺少的測試、風格不一致。標記為已審查。"
```
此設定會使 OpenClaw 每半小時自動檢查新 PR 並提供即時回饋。

### 步驟 9：使用程式碼樣板（Scaffolding）快速起專案
定義您專案的常見檔案樣板，讓 OpenClaw 能根據樣板快速產生新功能。

1. 在 `~/.openclaw/workspace/templates/` 建立樣板檔案，例如：
   - `api-route.ts.template`
   - `component.tsx.template`
   - `test.ts.template`
2. 請求 OpenClaw 使用樣板產生新檔案：
   ```
   /generate api-route --name users --path /api/users
   ```
   OpenClaw 會讀取樣板，替換變數（如路徑、名稱），並將產生的檔案寫入專案中適當位置。

## 進階應用
- **多代理協作**：一個 OpenClaw 代理負責理解需求並撰寫高階規格，另一個 coding sub-agent 負責實作細節。
- **跨語言程式碼生成**：透過指定不同的模型或 agent，產生 TypeScript、Python、Go 等多種語言的程式碼。
- **整合開發工作流程**：將程式碼生成步驟納入您的 CI/CD 管線，例如在每次合併前自動產生遷移腳本或 API 文件。
- **自訂提示詞與上下文**：在 AGENTS.md 中編寫專案特定的程式碼生成規則，例如慣用的錯誤處理模式、日誌格式等，以提升產出的一致性。

## 小結
在這個教學中，您學會了：
- 如何安裝和設定 OpenClaw 的程式碼生成功能（內建 Pi 或外部 ACP agent）
- 透過自然語言描述產生函式及其單元測試
- 將產生的程式碼寫入檔案並執行測試驗證
- 使用 coding sub-agent 進行較大規模的重構或多檔案變更
- 設定自動化程式碼審查與程式碼樣板以提升開發效率

透過這些步驟，您現在可以將 OpenClaw 作為您的 AI 程式碼夥伴，自動化重複的編程任務，加速功能開發，並保持程式碼品質。隨著您對這些功能的熟練，您可以進一步探索其進階用途，例如整合語音指令、多模態輸入，或是開發專屬的程式碼生成技能。