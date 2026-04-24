# Configuration 參考資料

> 最後更新：2026-04-24

## 來源清單

### 來源 1：OpenClawConfig root type
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/src/config/types.openclaw.ts
- **類型**：原始碼
- **擷取日期**：2026-04-24
- **可信度**：高（第一方原始碼）
- **主要內容摘要**：定義 OpenClaw 的真實頂層設定面，包含 `env`、`logging`、`browser`、`ui`、`messages`、`approvals`、`session`、`web`、`discovery`、`talk`、`gateway`、`memory`、`mcp` 等。
- **用於文件的哪個部分**：頂層設定欄位總覽、欄位修正
- **注意事項**：這是頂層 truth，但深層欄位語意仍需回看各自型別與 docs。

### 來源 2：Cron config type
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/src/config/types.cron.ts
- **類型**：原始碼
- **擷取日期**：2026-04-24
- **可信度**：高（第一方原始碼）
- **主要內容摘要**：定義 `cron.retry`、`sessionRetention`、`runLog`、`failureAlert`、`failureDestination` 等設定，並在註解中明示多個預設值。
- **用於文件的哪個部分**：`cron` 高價值欄位章節
- **注意事項**：這裡只涵蓋 config surface，不含 CLI job-level patch semantics。

### 來源 3：Schema help
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/src/config/schema.help.ts
- **類型**：原始碼
- **擷取日期**：2026-04-24
- **可信度**：高（第一方原始碼）
- **主要內容摘要**：提供大量欄位級說明與部分預設語意，例如 `update.channel`、`gateway.bind`、`gateway.auth.mode`、`talk.silenceTimeoutMs`、`agents.defaults.contextLimits`。
- **用於文件的哪個部分**：高價值欄位解讀、設計動機與允許值摘要
- **注意事項**：不是所有預設都在這裡明示，仍需與型別與 runtime 行為交叉驗證。

### 來源 4：Configuration overview
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/docs/gateway/configuration.md
- **類型**：第一方官方文件
- **擷取日期**：2026-04-24
- **可信度**：高（第一方 docs）
- **主要內容摘要**：說明 JSON5、strict validation、Control UI、hot reload、diagnostic commands，以及 last-known-good restore 機制。
- **用於文件的哪個部分**：設定生命週期、變更生效方式、排錯
- **注意事項**：偏 overview，需要搭配 reference 與原始碼使用。

### 來源 5：Configuration reference
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/docs/gateway/configuration-reference.md
- **類型**：第一方官方文件
- **擷取日期**：2026-04-24
- **可信度**：高（第一方 docs）
- **主要內容摘要**：提供 channels、group policy、modelByChannel、provider-specific config 等 field-level reference 與延伸入口。
- **用於文件的哪個部分**：`channels` 章節、field-level reference 說明
- **注意事項**：官方也明說這一頁不會 inline 每一個 plugin/channel-owned 深層欄位。

### 來源 6：Config CLI 實作
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/src/cli/config-cli.ts
- **類型**：原始碼
- **擷取日期**：2026-04-24
- **可信度**：高（第一方原始碼）
- **主要內容摘要**：定義 `config get/set/unset/file/schema/validate`、`--strict-json`、`--dry-run`、builder mode 與 batch mode，是自動化安全改寫 config 的主入口。
- **用於文件的哪個部分**：CLI 指令完整參考、SecretRef / provider builder 寫法
- **注意事項**：文件寫作時不能把 `configure` 與 `config` 混為一談。

### 來源 7：Config CLI 測試
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/src/cli/config-cli.test.ts
- **類型**：測試
- **擷取日期**：2026-04-24
- **可信度**：高（第一方測試）
- **主要內容摘要**：驗證 `config validate` 的 success/invalid/JSON payload/file-not-found 行為，能補足使用文件裡常漏掉的 exit code 與輸出契約。
- **用於文件的哪個部分**：排錯、`validate --json` 行為
- **注意事項**：主要聚焦 CLI contract，不等於完整設定語意。

### 來源 8：Config CLI 官方文件
- **URL**：workspace:/Users/daniel.chang/Desktop/openclaw/docs/cli/config.md
- **類型**：第一方官方文件
- **擷取日期**：2026-04-24
- **可信度**：高（第一方 docs）
- **主要內容摘要**：詳細說明 path notation、`config set` 四種模式、provider builder、dry-run 與 protected path replace policy。
- **用於文件的哪個部分**：CLI 改寫流程與安全操作範例
- **注意事項**：適合作為 agent 寫設定文件時的操作層參考，不足以單獨描述所有 config fields。