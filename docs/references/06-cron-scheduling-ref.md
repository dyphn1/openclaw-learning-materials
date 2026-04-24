# 06-cron-scheduling 參考資料

> 最後更新：2026-04-24

## 來源清單

### 來源 1：Cron root command 註冊
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/src/cli/cron-cli/register.ts
- **類型**：原始碼
- **擷取日期**：2026-04-24
- **可信度**：高（第一方原始碼）
- **主要內容摘要**：註冊 `openclaw cron` root command，並掛上 `status`、`list`、`add`、`edit`、simple commands 等子命令群。
- **用於文件的哪個部分**：命令樹、原始碼入口與驗證來源
- **注意事項**：這個檔案只負責組裝，不含具體 option 定義。

### 來源 2：`cron add` 實作
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/src/cli/cron-cli/register.cron-add.ts
- **類型**：原始碼
- **擷取日期**：2026-04-24
- **可信度**：高（第一方原始碼）
- **主要內容摘要**：定義 `cron add` 的完整 option surface，並在 CLI 層處理 schedule 解析、payload 互斥、session target 推導、delivery 規則、account 限制與 best-effort delivery。
- **用於文件的哪個部分**：`cron add` 參數矩陣、constraints matrix、基本與進階範例
- **注意事項**：CLI 已做大量前置驗證，文件若不直接讀此檔，很容易漏掉互斥規則。

### 來源 3：`cron edit` 實作
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/src/cli/cron-cli/register.cron-edit.ts
- **類型**：原始碼
- **擷取日期**：2026-04-24
- **可信度**：高（第一方原始碼）
- **主要內容摘要**：定義 patch 類更新 surface，包含 enable/disable、clear-agent、clear-session-key、delivery 調整、tool allow-list 與 failure alert 相關 flags。
- **用於文件的哪個部分**：`cron edit` 補充參數矩陣、failure alert 規則
- **注意事項**：failure alert mode 僅允許 `announce` 或 `webhook`，且 `--no-failure-alert` 不可與 `failure-alert-*` 併用。

### 來源 4：Simple commands 實作
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/src/cli/cron-cli/register.cron-simple.ts
- **類型**：原始碼
- **擷取日期**：2026-04-24
- **可信度**：高（第一方原始碼）
- **主要內容摘要**：定義 `rm/remove/delete`、`enable`、`disable`、`show`、`runs`、`run` 等操作，包含 `runs --id` 與 `run --due` 行為。
- **用於文件的哪個部分**：子命令總覽、`run` / `runs` 參數矩陣
- **注意事項**：`run` 會依 RPC 回傳的 `ok/ran/enqueued` 決定 exit code。

### 來源 5：Cron CLI 官方文件
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/docs/cli/cron.md
- **類型**：第一方官方文件
- **擷取日期**：2026-04-24
- **可信度**：高（第一方 docs）
- **主要內容摘要**：補充 `announce` / `no-deliver` 語意、one-shot delete 預設、manual run queue 行為、failure destination precedence、sessionRetention 與 runLog pruning、upgrade notes。
- **用於文件的哪個部分**：設計動機、delivery 說明、config 章節、已知限制與注意事項
- **注意事項**：官方 docs 有語意補充，但不會逐列全部 CLI options，仍需回到原始碼與測試。

### 來源 6：Cron CLI 測試
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/src/cli/cron-cli.test.ts
- **類型**：測試
- **擷取日期**：2026-04-24
- **可信度**：高（第一方測試）
- **主要內容摘要**：覆蓋 model/thinking trim、isolated job 預設 announce、session target inference、`--keep-after-run`、`--account`、`--tz` 與 DST 邊界等行為。
- **用於文件的哪個部分**：constraints matrix、常見問題排錯、timezone/DST 說明
- **注意事項**：timezone 與 DST 說明應以測試為準，不可用通用 cron 常識自行推導。

### 來源 7：Cron 設定型別
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/src/config/types.cron.ts
- **類型**：原始碼
- **擷取日期**：2026-04-24
- **可信度**：高（第一方原始碼）
- **主要內容摘要**：定義 `cron.retry`、`webhook`、`webhookToken`、`sessionRetention`、`runLog`、`failureAlert`、`failureDestination`，並在註解中明示多個預設值。
- **用於文件的哪個部分**：配置與客製化、全域 cron 設定面
- **注意事項**：這裡是 config truth，不等於 CLI job-level flags 的全部行為。

---
*此參考資料由 AI agent 自動生成並持續更新*