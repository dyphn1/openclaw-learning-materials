---
version: 10-plugin-sdk
date: 2026-04-22
---

# 10-plugin-sdk (Plugin SDK 開發)

> 最後更新：2026-04-22

## 什麼是 Plugin SDK？
OpenClaw 的 Plugin SDK 是一個 TypeScript 函式庫，用於開發可以擴充 OpenClaw 功能的外掛程式。透過 SDK，開發者可以建立通道外掛（連接新的訊息平台）、提供者外掛（整合新的 AI 模型供應商）、技能外掛（新增代理工具）或鉤子外掛（擴充核心功能）。

## 安裝 / 環境需求
- Node.js >= 22.12.0
- 包管理器（npm 或 pnpm）
- 基礎 TypeScript 知識
- OpenClaw 框架（建議使用 v2026.1.0 或更新版本）

```bash
# 建立新的外掛專案
mkdir my-openclaw-plugin
cd my-openclaw-plugin
npm init -y
npm install openclaw
# 或使用 pnpm
pnpm add openclaw
```

## 核心概念
Plugin SDK 遵循「合約優先」的設計，提供型別安全的介面來定義外掛程式。主要概念包括：

1. **入口點定義**：使用 `definePluginEntry` 或 `defineChannelPluginEntry` 註冊外掛
2. **副路徑匯入**：從特定副路徑匯入以避免循環依賴
3. **擴充點註冊**：註冊工具、鉤子、設定介面等
4. **生命週期管理**：處理外掛的載入、卸載和重載

## CLI 指令說明
OpenClaw 提供 CLI 指令來管理外掛：

```bash
# 安裝外掛
openclaw plugins install <package-name>
# 列出已安裝外掛
openclaw plugins list
# 移除外掛
openclaw plugins uninstall <package-name>
# 更新外掛
openclaw plugins update <package-name>
```

## 實際應用範例

### 場景一：建立簡單的工具外掛
這個範例示範如何建立一個新增兩個數字的工具。

1. 建立專案結構：
```bash
mkdir openclaw-adder-tool
cd openclaw-adder-tool
npm init -y
npm install openclaw
```

2. 建立 `index.ts`：
```typescript
import { definePluginEntry, registerTool } from "openclaw/plugin-sdk/plugin-entry";

export default definePluginEntry((plugin) => {
  registerTool(plugin, {
    name: "adder",
    description: "Add two numbers together",
    parameters: {
      type: "object",
      properties: {
        a: { type: "number", description: "First number" },
        b: { type: "number", description: "Second number" },
      },
      required: ["a", "b"],
    },
    execute: async ({ a, b }) => {
      return String(a + b);
    },
  });
});
```

3. 建立 `openclaw` 區塊在 `package.json` 中：
```json
{
  "name": "openclaw-adder-tool",
  "version": "1.0.0",
  "main": "index.ts",
  "type": "module",
  "openclaw": {
    "extensions": ["./index.ts"]
  }
}
```

4. 建置並使用：
```bash
# 在開發模式下連結
npm link
# 在 OpenClaw 實例中安裝
openclaw plugins install openclaw-adder-tool
```

### 場景二：建立通道外掛（Discord 範例）
這個範例展示如何建立一個基本的 Discord 通道外掛。

1. 建立專案：
```bash
mkdir openclaw-discord-channel
cd openclaw-discord-channel
npm init -y
npm install openclaw discord.js
```

2. 建立 `index.ts`：
```typescript
import { defineChannelPluginEntry } from "openclaw/plugin-sdk/channel-core";
import { Client, GatewayIntentBits } from "discord.js";

export default defineChannelPluginEntry((plugin) => {
  const client = new Client({ intents: [GatewayIntentBits.Guilds, GatewayIntentBits.GuildMessages] });

  plugin.on("start", async () => {
    await client.login(process.env.DISCORD_BOT_TOKEN);
    client.on("messageCreate", async (message) => {
      if (message.author.bot) return;
      await plugin.sendMessage(message.channel.id, message.content);
    });
  });

  plugin.on("stop", async () => {
    await client.destroy();
  });

  return {
    sendMessage: async (chatId: string, text: string) => {
      const channel = await client.channels.fetch(chatId);
      if (channel?.isTextBased()) {
        await channel.send(text);
      }
    },
  };
});
```

## 應用主題分類

| 主題 | 適用場景 | 複雜度 |
|------|---------|-------|
| 通道外掛 | 連接新的訊息平台（如 Discord、Slack、Telegram） | ⭐⭐⭐⭐ |
| 提供者外掛 | 整合新的 AI 模型供應商（如 OpenAI、Anthropic、本地模型） | ⭐⭐⭐ |
| 工具/鉤子外掛 | 新增代理工具或擴充核心功能 | ⭐⭐ |

## 常見問題與排錯

| 問題 | 原因 | 解法 |
|------|------|------|
| 外掛載入失敗 | 版本不相容或入口點錯誤 | 檢查 OpenClaw 版本與外掛相容性，確認入口點路徑正確 |
| TypeScript 編譯錯誤 | 缺少型別定義或設定錯誤 | 安裝 `@types/node` 和適當的 TypeScript 設定 |
| 通道外掛連線失敗 | 認證資訊錯誤或網路問題 | 檢查 API 權杖和網路連線，確認平台允許機器人存取 |
| 工具未在代理中顯示 | 註冊失敗或名稱衝突 | 確認工具註冊正確執行，檢查日誌中的錯誤訊息 |

## 參考資源
- [官方文件 - Plugin SDK 總覽](https://docs.openclaw.ai/plugins/sdk-overview) — SDK 參考與匯入慣例
- [官方文件 - 建立外掛](https://docs.openclaw.ai/plugins/building-plugins) — 外掛開發逐步指南
- [GitHub 原始碼](https://github.com/openclaw/openclaw) — 查看內建外掛範例
- [ClawHub](https://clawhub.com) — 探索和發布社群外掛
- [Discord 社群](https://discord.gg/clawd) — 取得開發支援和想法交流

---
*此文件由 AI agent 自動生成，最後更新：2026-04-22*