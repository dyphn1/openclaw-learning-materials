# 自動化學習場景深度指南 (Learning Automation Deep Guide)

> 最後更新：2026-04-29
> 完整性狀態：基於 v2026.4.23 原始碼分析，涵蓋 OpenClaw 記憶、Cron 與工具鏈的自動化學習工作流
> 相關原始碼：`src/config/types.memory.ts`、`src/config/types.cron.ts`、`src/agents/tools/web-search.ts`、`src/agents/tools/web-fetch.ts`

## 概覽與設計動機

自動化學習場景旨在讓 OpenClaw 定期收集、整理與摘要外部資訊，並將結果持久化於本地記憶或外部知識庫。從原始碼可見，該工作流主要由三個核心模組協同完成：

1. **Cron 排程** (`openclaw cron`) – 定時觸發資訊收集任務
2. **Web 搜索與抓取** (`web-search`、`web-fetch`) – 取得最新資料
3. **記憶與嵌入** (`memory`、`mcp` 插件) – 存儲、向量化並支援後續查詢

這樣的設計允許開發者構建如每日新聞摘要、技術趨勢追蹤或個人學習筆記自動化等場景，且所有步驟皆可在 OpenClaw CLI 中以 declarative config 完成，保持可追溯與可測試的特性。

## 架構與實作原理

### 核心模組

| 模組 | 檔案 | 作用 |
|------|------|------|
| Memory Config | `src/config/types.memory.ts` | 定義記憶後端、引用與更新策略 |
| Cron Config | `src/config/types.cron.ts` | 定義排程行為、重試與失敗通知 |
| Web Search Tool | `src/agents/tools/web-search.ts` | 搜索關鍵字，返回結果 URL 與摘要 |
| Web Fetch Tool | `src/agents/tools/web-fetch.ts` | 抓取 URL 內容，支援 markdown/text 抽取 |
| Memory Embedding Plugin | `src/plugins/memory-embedding-provider-runtime.ts` | 將文字向量化存入 QMD 或內建向量庫 |
| Memory Repair Utilities | `src/memory/root-memory-files.ts` | 兼容舊 `memory.md` 與新 `MEMORY.md`，提供修復指令 |

### 關鍵型別定義

```typescript
export type MemoryConfig = {
  backend?: "builtin" | "qmd"; // 記憶後端選擇
  citations?: "auto" | "on" | "off"; // 是否自動加入引用
  qmd?: MemoryQmdConfig; // QMD 相關設定
};

export type CronConfig = {
  enabled?: boolean;
  retry?: CronRetryConfig;
  sessionRetention?: string | false;
  // ... 其他排程設定
};
```

### 工作流概覽

```mermaid
flowchart TD
    A[Cron 觸發] --> B[Web Search]
    B --> C[選擇結果 URL]
    C --> D[Web Fetch 抽取內容]
    D --> E[文字清理與整理]
    E --> F[向量化 (Memory Embedding)]
    F --> G[存入 MEMORY.md / QMD]
    G --> H[可視化報告或通知]
```

### 原始碼入口與驗證來源

| 類型 | 檔案 | 作用 |
|------|------|------|
| Cron 入口 | `src/cli/cron-cli/register.ts` | 註冊 `cron add` 子命令，用於排程學習任務 |
| Web Search