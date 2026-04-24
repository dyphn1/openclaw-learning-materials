# CLI 參考資料

> 最後更新：2026-04-24

## 來源清單

### 來源 1：CLI 根命令分類
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/src/cli/program/core-command-descriptors.ts
- **類型**：原始碼
- **擷取日期**：2026-04-24
- **可信度**：高（第一方原始碼）
- **主要內容摘要**：定義 OpenClaw 核心 root commands，包括 `setup`、`config`、`agent`、`sessions`、`tasks` 等，並標記哪些命令有子命令。適合建立 CLI 地圖與分類。
- **用於文件的哪個部分**：CLI 根命令總覽、命令樹
- **注意事項**：這個檔案只給分類與描述，不包含每個子命令的 option 細節。

### 來源 2：子命令註冊總表
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/src/cli/program/register.subclis-core.ts
- **類型**：原始碼
- **擷取日期**：2026-04-24
- **可信度**：高（第一方原始碼）
- **主要內容摘要**：把 `cron`、`channels`、`sandbox`、`nodes`、`gateway`、`models` 等模組化 CLI 掛到主程式，是追蹤命令入口的樞紐。
- **用於文件的哪個部分**：命令樹、追蹤方法說明
- **注意事項**：這裡是 loader/registrar，不是最終行為定義點。

### 來源 3：Config CLI 官方文件
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/docs/cli/config.md
- **類型**：第一方官方文件
- **擷取日期**：2026-04-24
- **可信度**：高（第一方 docs，且與原始碼相互佐證）
- **主要內容摘要**：完整說明 `openclaw config` 的 path 格式、`set` 的四種模式、provider builder、dry-run、schema 與 validate 用法。
- **用於文件的哪個部分**：`config` 命令樣本章節、批次與 builder 範例
- **注意事項**：仍需回到 `src/cli/config-cli.ts` 核對 option 與測試行為。

### 來源 4：Config CLI 實作與測試
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/src/cli/config-cli.ts
- **類型**：原始碼
- **擷取日期**：2026-04-24
- **可信度**：高（第一方原始碼）
- **主要內容摘要**：定義 `config get/set/unset/file/schema/validate`，包含 `--strict-json`、`--dry-run`、`--allow-exec`、builder flags 與 batch mode。
- **用於文件的哪個部分**：`config set` 參數矩陣、參數限制與互動規則
- **注意事項**：實際錯誤輸出與 exit code 還要配合測試讀。

### 來源 5：Config validate 測試
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/src/cli/config-cli.test.ts
- **類型**：測試
- **擷取日期**：2026-04-24
- **可信度**：高（第一方測試）
- **主要內容摘要**：驗證 `config validate` 的 success、invalid、`--json`、allowed-values metadata 與 file-not-found 行為。
- **用於文件的哪個部分**：排錯、`validate --json` 行為說明
- **注意事項**：測試涵蓋的是 contract，不是使用情境文件。

### 來源 6：Cron CLI 官方文件
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/docs/cli/cron.md
- **類型**：第一方官方文件
- **擷取日期**：2026-04-24
- **可信度**：高（第一方 docs）
- **主要內容摘要**：說明 `openclaw cron` 的 delivery、retention、manual run、light-context 與 upgrade notes，是 cron 語意層的重要補充。
- **用於文件的哪個部分**：`cron` 命令樣本、delivery 與 retention 說明
- **注意事項**：仍需對照 `register.cron-add.ts` 與測試，因為 docs 不會逐列全部 option。

### 來源 7：Cron add / edit / simple 實作
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/src/cli/cron-cli/register.cron-add.ts
- **類型**：原始碼
- **擷取日期**：2026-04-24
- **可信度**：高（第一方原始碼）
- **主要內容摘要**：定義 `cron add` 的 options、payload 選擇、session target 推導、delivery 模式與互斥條件。`register.cron-edit.ts` 與 `register.cron-simple.ts` 定義 edit、show、run、runs、rm、enable、disable 等子命令。
- **用於文件的哪個部分**：`cron` 子命令總覽、add 參數矩陣、限制規則
- **注意事項**：這些檔案是 CLI 層的 truth，但 scheduler 與 stored job 行為仍在更下層。

### 來源 8：Cron CLI 測試
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/src/cli/cron-cli.test.ts
- **類型**：測試
- **擷取日期**：2026-04-24
- **可信度**：高（第一方測試）
- **主要內容摘要**：覆蓋預設 `announce`、session target 推導、`--keep-after-run`、`--account`、`--tz` 與 DST 邊界，是 cron 文件避免寫錯的關鍵來源。
- **用於文件的哪個部分**：參數限制與邊界、常見錯誤與排錯
- **注意事項**：timezone 與 DST 行為不可只靠一般 cron 常識推論，必須以此測試為準。