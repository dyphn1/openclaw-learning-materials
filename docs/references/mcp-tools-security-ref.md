# MCP 工具安全限制參考資料

> 最後更新：2026-04-26

## 來源清單

### 來源 1：官方工具與文件
- **URL**：https://docs.openclaw.ai/tools
- **類型**：官方文件
- **擷取日期**：2026-04-26
- **可信度**：高（官方來源）
- **主要內容摘要**：
  - 完整的 OpenClaw 工具架構說明
  - 工具配置、允許/拒絕清單、工具配置檔案
  - Owner-only 工具的定義與限制
  - MCP 工具整合的安全邊界
- **用於文件的哪個部分**：
  - 工具架構概述、配置方式、安全限制基礎
- **注意事項**：
  - 官方文件涵蓋了工具配置的基本概念，但 MCP 安全限制的技術實現細節需要參考原始碼

### 來源 2：原始碼分析 - MCP 服務器實作
- **URL**：`/Users/daniel.chang/Desktop/openclaw/src/mcp/openclaw-tools-serve.ts`
- **類型**：原始碼分析
- **擷取日期**：2026-04-26
- **可信度**：高（直接來源原始碼）
- **主要內容摘要**：
  - MCP OpenClaw 工具服務器的實作
  - `resolveOpenClawToolsForMcp()` 函式只提供 `cron` 工具
  - Owner-only 工具的過濾機制在 `createPluginToolsMcpHandlers()` 中實現
- **用於文件的哪個部分**：
  - 技術實作細節、安全限制的具體實現方式
- **注意事項**：
  - 直接從原始碼提取，確保技術細準確性

### 來源 3：原始碼分析 - 安全限制實作
- **URL**：`/Users/daniel.chang/Desktop/openclaw/src/mcp/plugin-tools-handlers.ts`
- **類型**：原始碼分析
- **擷取日期**：2026-04-26
- **可信度**：高（直接來源原始碼）
- **主要內容摘要**：
  - `createPluginToolsMcpHandlers()` 中的安全過濾邏輯
  - Owner-only 工具被 `tools.filter((tool) => !tool.ownerOnly)` 過濾掉
  - MCP 橋接不會列出或調用 owner-only 工具
- **用於文件的哪個部分**：
  - 安全限制的具體實現邏輯、技術細節
- **注意事項**：
  - 這是 v2026.4.23 安全修復的核心實現

### 來源 4：原始碼分析 - Owner-only 工具定義
- **URL**：`/Users/daniel.chang/Desktop/openclaw/src/agents/tools/owner-only-tools.ts`
- **類型**：原始碼分析
- **擷取日期**：2026-04-26
- **可信度**：高（直接來源原始碼）
- **主要內容摘要**：
  - 定義了三個 owner-only 核心工具：`["cron", "gateway", "nodes"]`
  - `isOpenClawOwnerOnlyCoreToolName()` 函式檢查工具是否為 owner-only
- **用於文件的哪個部分**：
  - Owner-only 工具的具體定義、識別方法
- **注意事項**：
  - 這些工具在 MCP 橋接中被完全隱藏，無法被 non-owner 呼叫者使用

### 來源 5：原始碼分析 - 測試證據
- **URL**：`/Users/daniel.chang/Desktop/openclaw/src/mcp/openclaw-tools-serve.test.ts`
- **類型**：原始碼分析
- **擷取日期**：2026-04-26
- **可信度**：高（測試驗證）
- **主要內容摘要**：
  - 測試證據顯示 MCP 服務器不會列出 owner-only 的 `cron` 工具
  - 嘗試調用 owner-only 工具會返回 "Unknown tool" 錯誤
- **用於文件的哪個部分**：
  - 安全限制的測試驗證、行為確認
- **注意事項**：
  - 測試證實了安全限制的實際行為，不是理論上的設計

### 來源 6：變更日誌證據
- **URL**：`/Users/daniel.chang/Desktop/openclaw-analysis/v2026.4.23/changelog-notes.md`
- **類型**：變更日誌分析
- **擷取日期**：2026-04-26
- **可信度**：高（官方變更記錄）
- **主要內容摘要**：
  - v2026.4.23 修復：停止 ACPX OpenClaw tools bridge 列出或調用 owner-only 工具
  - 這是一個安全修復，關閉了權限提升的路徑
- **用於文件的哪個部分**：
  - 安全修復的背景、目的、影響範圍
- **注意事項**：
  - 這個修復針對的是 non-owner MCP 呼叫者可能權限提升的風險

### 來源 7：官方 MCP CLI 文件
- **URL**：`/Users/daniel.chang/Desktop/openclaw/src/cli/mcp-cli.ts`
- **類型**：原始碼分析
- **擷取日期**：2026-04-26
- **可信度**：高（官方實作）
- **主要內容摘要**：
  - MCP CLI 的命令結構與功能
  - MCP 服務器的配置、列出、設定、移除功能
- **用於文件的哪個部分**：
  - MCP 管理的 CLI 介面、配置方式
- **注意事項**：
  - CLI 提供了管理 MCP 服務器的標準方式，但無法繞過安全限制

## 技術實作細節

### Owner-only 工具識別機制
```typescript
// 定義 owner-only 工具
export const OPENCLAW_OWNER_ONLY_CORE_TOOL_NAMES = ["cron", "gateway", "nodes"] as const;

// 檢查工具是否為 owner-only
export function isOpenClawOwnerOnlyCoreToolName(toolName: string): boolean {
  return OPENCLAW_OWNER_ONLY_CORE_TOOL_NAME_SET.has(toolName);
}
```

### MCP 安全過濾邏輯
```typescript
export function createPluginToolsMcpHandlers(tools: AnyAgentTool[]) {
  // 過濾掉 owner-only 工具
  const allowedTools = tools.filter((tool) => !tool.ownerOnly);
  
  // 包裝工具以執行預執行鉤子
  const wrappedTools = allowedTools.map((tool) => {
    if (isToolWrappedWithBeforeToolCallHook(tool)) {
      return tool;
    }
    return wrapToolWithBeforeToolCallHook(tool);
  });
  
  // 建立工具映射
  const toolMap = new Map<string, AnyAgentTool>();
  for (const tool of wrappedTools) {
    toolMap.set(tool.name, tool);
  }
}
```

### MCP 服務器的工具列表限制
```typescript
// MCP 服務器只允許非 owner-only 工具
export function resolveOpenClawToolsForMcp(): AnyAgentTool[] {
  return [createCronTool()]; // 注意：cron 是 owner-only，但會被過濾掉
}
```

## 安全影響分析

### 權限提升修復
- **問題**：在 v2026.4.23 之前，ACPX OpenClaw tools bridge 可能允許 non-owner 呼叫者存取 owner-only 工具
- **修復**：完全阻止 owner-only 工具在 MCP 橋接中被列出或調用
- **影響**：關閉了權限提升的路徑，提高了系統安全性

### 測試驗證
- 列出工具測試：確保 owner-only 工具不出現在 MCP 工具列表中
- 調用工具測試：確保調用 owner-only 工具會被正確拒絕

## 配置建議

### MCP 工具安全配置
```json5
{
  tools: {
    profile: "coding",
    deny: ["bundle-mcp"], // 隱藏所有 MCP 工具（如果需要）
    allow: ["group:fs", "browser", "web_search"]
  }
}
```

### Owner-only 工具的特殊處理
- Owner-only 工具（cron、gateway、nodes）在 MCP 中完全不可用
- 這些工具只能在直接 agent 執行或 CLI 中使用
- MCP 橋接提供了安全的工具子集，適合第三方集成