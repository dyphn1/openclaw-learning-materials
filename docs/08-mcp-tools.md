# MCP 工具整合 (MCP Tools Integration)

> 最後更新：2026-04-22

## 什麼是 MCP 工具整合？
MCP（Model Context Protocol）是 Anthropic 提出的開放標準，使 AI 模型能夠透過一致的介面與外部工具和資料來源進行互動。對於 OpenClaw 而言，MCP 整合使您的自托管 AI 代理能夠安全地連接到數百種外部服務，而無需編寫自訂整合程式碼或在設定中硬編碼憑證。

## 安裝 / 環境需求
- OpenClaw 已安裝並運行（v2026.1.5 或更新版本）
- Node.js >= 22.12.0
- pnpm 包管理器
- 基本的終端機操作知識

### 安裝步驟
1. 確保 OpenClaw 已正確安裝並運行
2. 安裝 mcporter 技能（用於管理 MCP 伺服器）：
   ```bash
   openclaw skills install mcporter
   ```
3. 根據您要連接的服務安裝對應的 MCP 伺服器（例如：GitHub、PostgreSQL、檔案系統等）

## 核心概念
MCP 在 OpenClaw 中的運作流程如下：
1. **MCP 伺服器**：獨立的程序（可以是本地或遠端）實作了 MCP 標準，提供特定工具的訪問（如查詢資料庫、操作 GitHub 倉庫等）。
2. **mcporter 技能**：OpenClaw 內建的技能，用於探索、配置和呼叫 MCP 伺服器所提供的工具。
3. **傳輸方式**：MCP 伺服器可以透過 stdio（本地進程）或 HTTP（遠端服務）與 OpenClaw 通訊。
4. **安全邊界**：憑證儲存在 MCP 伺服器中，而非 OpenClaw 設定中，提供能力範圍限制和審計追蹤。

### 基本架構
```
[OpenClaw 核心] ←→ [mcporter 技能] ←→ [MCP 伺服器 (stdio/http)] ←→ [外部服務 (GitHub, DB, etc.)]
```

## CLI 指令說明
透過 `openclaw` 指令可以管理 MCP 伺服器和使用 MCP 工具：

Vào mcporter 相關的子指令：
}}><|tool_calls_section_begin|><|tool_call_begin|>openclaw mcp list<|tool_calls_section_end|><|tool_call_begin|>openclaw mcp add <name> <command> [args...]<|tool_calls_section_end|><|tool_call_begin|>openclaw mcp remove <name><|tool_calls_section_end|><|tool_call_begin|>openclaw mcp call <server> <tool> [args...]<|tool_calls_section_end|><|tool_calls_section_begin|># 範例：加入檔案系統 MCP 伺服器<|tool_calls_section_end|><|tool_call_begin|>openclaw mcp add filesystem npx -y @modelcontextprotocol/server-filesystem /path/to/allowed/directory<|tool_calls_section_end|><|tool_calls_section_begin|># 範例：呼叫檔案系統工具列出目錄<|tool_calls_section_end|><|tool_call_begin|>openclaw mcp call filesystem list /<|tool_calls_section_end|>

## 實際應用範例

### 場景一：連接到本地檔案系統
**目標**：讓 OpenClaw 能夠讀取和列出特定目錄中的檔案。

1. 安裝檔案系統 MCP 伺服器：
   ```bash
   npm install -g @modelcontextprotocol/server-filesystem
   ```
2. 透過 mcporter 加入伺服器：
   ```bash
   openclaw mcp add local-files npx @modelcontextprotocol/server-filesystem /home/user/documents
   ```
3. 列出目錄內容：
   ```bash
   openclaw mcp call local-files list /home/user/documents
   ```
4. 讀取特定檔案：
   ```bash
   openclaw mcp call local-files read /home/user/documents/notes.txt
   ```

### 場景二：查詢 PostgreSQL 資料庫
**目標**：讓 OpenClaw 能夠執行 SQL 查詢並返回結果。

1. 安裝 PostgreSQL MCP 伺服器：
   ```bash
   npm install -g @modelcontextprotocol/server-postgres
   ```
2. 配置環境變數（例如在 `.env` 檔案中）：
   ```env
   PGHOST=localhost
   PGPORT=5432
   PGUSER=myuser
   PGPASSWORD=mypassword
   PGDATABASE=mydb
   ```
3. 加入 MCP 伺服器：
   ```bash
   openclaw mcp add postgres npx @modelcontextprotocol/server-postgres
   ```
4. 執行查詢：
   ```bash
   openclaw mcp call postgres query "SELECT * FROM users LIMIT 5;"
   ```

## 應用主題分類

| 主題 | 適用場景 | 複雜度 |
|------|---------|-------|
| 檔案系統存取 | 本地檔案操作、配置讀取 | ⭐ |
| 資料庫查詢 | 數據分析、報告生成 | ⭐⭐ |
| GitHub 整合 | 程式碼審查、Issue 管理 | ⭐⭐⭐ |
| Slack 通知 | 自動通報、團隊協作 | ⭐⭐ |
| 網路爬蟲 | 資料收集、內容聚合 | ⭐⭐⭐ |

## 常見問題與排錯

| 問題 | 原因 | 解法 |
|------|------|------|
| MCP 伺服器無法啟動 | 路徑錯誤或缺少依賴 | 檢查伺服器安裝路徑和必要的 npm 套件 |
| 工具呼叫返回權限錯誤 | MCP 伺服器能力範圍設定不足 | 調整 MCP 伺服器的存取權限（例如檔案系統伺服器的允許目錄） |
| 連線逾時 | 網路問題或伺服器無回應 | 檢查伺服器狀態和網路連線，嘗試增加超時時間 |
| 工具找不到 | 未正確註冊的工具名稱 | 使用 `openclaw mcp list <server>` 查看可用工具列表 |

## 參考資源
- [官方文件](https://docs.openclaw.ai) — 最新官方說明
- [GitHub](https://github.com/openclaw/openclaw) — 原始碼與 Issues
- [Discord](https://discord.gg/clawd) — 社群討論
- [MCP 官方規格](https://modelcontextprotocol.io) — Model Context Protocol 官方網站
- [mcporter 技能文件](https://github.com/openclaw/openclaw/tree/main/skills/mcporter) — 技能原始碼

---
*此文件由 AI agent 自動生成，最後更新：2026-04-22*