# MCP 工具安全限制 (MCP Tools Security)

> 最後更新：2026-04-26
> 相關原始碼：`src/mcp/openclaw-tools-serve.ts`、`src/mcp/plugin-tools-handlers.ts`、`src/agents/tools/owner-only-tools.ts`

## 概覽與設計動機
MCP（Model Context Protocol）允許 OpenClaw 代理人在本地或遠端透過標準化介面呼叫外部工具。由於 MCP 可能被第三方插件或非受信任的代理人使用，OpenClaw 必須防止 **owner‑only**（僅允許系統所有者）的核心工具（如 `cron`、`gateway`、`nodes`）被未授權的 MCP 呼叫者濫用，避免權限提升或資源濫用。v2026.4.23 的安全修復在 **ACP​X tools bridge** 中加入了過濾機制，確保這類工具永遠不會在 MCP 層面曝光。

## 核心模組與入口
| 類型 | 路徑 | 作用 |
|------|------|------|
| MCP 服務器核心 | `src/mcp/openclaw-tools-serve.ts` | 建立 MCP 服務器，列出可供使用的工具（目前僅 `cron`，但會被過濾） |
| 工具過濾與包裝 | `src/mcp/plugin-tools-handlers.ts` | `createPluginToolsMcpHandlers()` 會過濾 `tool.ownerOnly`，並包裝剩餘工具以加入 pre‑call 鉤子 |
| Owner‑only 定義 | `src/agents/tools/owner-only-tools.ts` | 定義核心 owner‑only 工具清單 `["cron","gateway","nodes"]` 並提供 `isOpenClawOwnerOnlyCoreToolName()` 判斷函式 |

## 設計原則
1. **最小權限公開**：只有在 **CLI**（本地或遠端）直接執行時，owner‑only 工具才可被呼叫。MCP 桥接層永遠不會列出或執行它們。
2. **統一過濾**：所有由 `plugin-tools-handlers` 建立的工具清單在加入前會執行 `!tool.ownerOnly` 過濾，確保未授權的 MCP 呼叫者無法取得這些工具。
3. **測試驗證**：`openclaw-tools-serve.test.ts` 明確檢查工具列表不包含 `cron`，且呼叫 `cron` 會返回 *Unknown tool* 錯誤。
4. **變更日誌**：在 `changelog-notes.md` 中記錄此安全修復，提供可追溯的變更說明。

## MCP CLI 指令樹
```text
openclaw mcp
├─ list                   # 列出已設定的 MCP 伺服器
├─ add <name> <command> [args...]   # 新增 MCP 伺服器（stdio 或 http）
├─ remove <name>          # 移除 MCP 伺服器
└─ call <server> <tool> [args...]   # 呼叫指定伺服器上的工具
```

*所有子指令皆在 `src/cli/mcp-cli.ts` 中定義。* 下面是 `mcp-cli.ts` 中的關鍵 `option` 定義（此檔案只有 `list|add|remove|call`，未使用額外 flag），因此 **option matrix** 只有四個子命令，無額外參數。

## 參數矩陣（Option Matrix）
| 子命令 | 參數 | 必填 | 預設值 | 說明 |
|--------|------|------|--------|------|
| `list` | `--json`（optional） | 否 | `false`