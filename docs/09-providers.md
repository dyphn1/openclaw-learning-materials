# AI 模型供應商設定 (AI Model Providers Configuration)

> 最後更新：2026-04-22

## 什麼是 AI 模型供應商設定？
OpenClaw 支援多種語言模型（LLM）供應商，包括商業 API（如 OpenAI、Anthropic、Google）和本地模型（如 Ollama、LMStudio）。透過適當的供應商設定，您可以讓 OpenClaw 使用不同的模型來完成各種任務，並根據成本、效能和隱私需求進行切換。

## 安裝 / 環境需求
- OpenClaw 已安裝並運行（v2026.1.5 或更新版本）
- Node.js >= 22.12.0
- pnpm 包管理器
- 根據選擇的供應商，可能需要對應的 API 金鑑或本地模型安裝

### 常見供應商安裝說明
1. **OpenAI**：取得 API 金鑑 from https://platform.openai.com/api-keys
2. **Anthropic**：取得 API 金鑑 from https://console.anthropic.com/
3. **Google**：取得 API 金鑑 from https://makersuite.google.com/app/apikey
4. **Ollama**（本地）：安裝 Ollama from https://ollama.com/download 並拉取模型（如 `ollama pull llama3`）
5. **OpenRouter**：取得 API 金鑑 from https://openrouter.ai/keys

## 核心概念
OpenClaw 的模型供應商設定主要透過以下方式管理：

### 1. 設定檔
- 根目錄的 `.env` 檔案用於儲存環境變數（如 API 金鑑）。
- 範例 `.env`：
  ```
  OPENAI_API_KEY=sk-your-openai-key
  ANTHROPIC_API_KEY=sk-ant-your-anthropic-key
  GOOGLE_API_KEY=your-google-key
  OPENROUTER_API_KEY=sk-or-your-openrouter-key
  ```

### 2. 模型選擇規則
OpenClaw 按以下順序選擇模型：
1. **主要模型**：`agents.defaults.model.primary` 或 `agents.defaults.model`
2. **備援模型**：`agents.defaults.model.fallbacks`（按順序）
3. **供應商認證備援**：在切換到下一個模型之前，會先在同一供應商內嘗試認證備援

### 3. CLI 指令協助
- `openclaw onboard`：引導式設定精靈，幫助您快速配置供應商。
- `openclaw models list`：列出所有可用的模型和供應商。
- `openclaw models set <provider/model>`：設定預設模型（例如 `openclaw models set openai/gpt-4o`）。

### 4. 提供者插件
某些供應商（如 Ollama、LMStudio）透過擴展（extensions）提供支援。這些插件可以：
- 注入模型目錄（catalog）
- 提供認證環境變數映射
- 正規化模型 ID、傳輸方式和配置
- 處理流式使用情況、額外參數等

## 實際應用範例

### 場景一：設定 OpenAI 作為主要模型
**目標**：使用 OpenAI 的 GPT-4o 模型進行一般對話和任務。

1. 取得 OpenAI API 金鑑並加入 `.env`：
   ```
   OPENAI_API_KEY=sk-your-openai-key
   ```
2. 透過 CLI 設定預設模型：
   ```bash
   openclaw models set openai/gpt-4o
   ```
3. 或手動編輯設定（在適當的設定檔中）：
   ```json
   {
     "agents": {
       "defaults": {
         "model": {
           "primary": "openai/gpt-4o",
           "fallbacks": ["openai/gpt-3.5-turbo"]
         }
       }
     }
   }
   ```

### 場景二：使用 Ollama 本地模型以降低成本
**目標**：在本地運行 Llama 3 模型，避免 API 費用。

1. 安裝 Ollama 並拉取模型：
   ```bash
   # 安裝 Ollama（參考 https://ollama.com/download）
   ollama pull llama3
   ```
2. 確認 Ollama 服務正在運行（預設 port 11434）。
3. 安裝 Ollama 擴展（如果尚未安裝）：
   ```bash
   openclaw skills install ollama
   ```
4. 設定預設模型為 Ollama 的 Llama 3：
   ```bash
   openclaw models set ollama/llama3
   ```
5. （可選）設定備援模型以防本地模型不可用：
   ```bash
   # 編輯設定以加入備援
   openclaw models set ollama/llama3 --fallbacks openai/gpt-3.5-turbo
   ```

### 場景三：多供應商路由與成本優化
**目標**：根據任務類型自動切換供應商以優化成本和效能。

1. 配置多個供應商的 API 金鑑在 `.env` 中。
2. 設定主要模型為成本較低的模型，並為特定任務設定備援或覆蓋：
   ```bash
   # 設定主要模型為 OpenRouter 的免費層模型
   openclaw models set openrouter/mistralai/mistral-7b-instruct:free
   # 為需要更強模型的任務設定會話級別覆蓋（在聊天中使用）：
   # /model anthropic/claude-3-opus
   ```

## 應用主題分類

| 主題 | 適用場景 | 複雜度 |
|------|---------|-------|
| 商業 API 模型 (OpenAI, Anthropic) | 一般對話、複雜推理 | ⭐ |
| 本地模型 (Ollama, LMStudio) | 隱私敏感、離線使用 | ⭐⭐ |
| 多供應商負載平衡 | 成本優化、高可用性 | ⭐⭐⭐ |
| 模型備援與故障轉移 | 服務中斷時自動切換 | ⭐⭐ |

## 常見問題與排錯

| 問題 | 原因 | 解法 |
|------|------|------|
| 模型呼叫返回認證錯誤 | API 金鑑錯誤或未設定 | 檢查 `.env` 中的金鑑是否正確，並確認沒有多餘空格 |
| 本地模型無回應 | Ollama 服務未運行或模型未拉取 | 執行 `ollama list` 確認模型存在，並啟動 Ollama 服務 |
| 模型列表為空 | 提供者插件未載入或設定錯誤 | 確認對應的技能（如 `ollama`）已安裝，並重啟 OpenClaw |
| 切換模型後無效果 | 需要重新載入設定或重啟 | 執行 `openclaw models list` 確認設定，必要時重啟 OpenClaw 進程 |
| 費用異常增加 | 意外使用了昂貴的模型 | 檢查預設模型和備援設置，考慮設定成本監控或使用 OpenRouter 的免費層 |

## 參考資源
- [官方文件](https://docs.openclaw.ai) — 最新官方說明
- [GitHub](https://github.com/openclaw/openclaw) — 原始碼與 Issues
- [Discord](https://discord.gg/clawd) — 社群討論
- [Model Providers 文件](https://docs.openclaw.ai/concepts/model-providers) — 供應商詳細說明
- [Models CLI 文件](https://docs.openclaw.ai/concepts/models) — 模型選擇和 CLI 指令
- [Model Failover 文件](https://docs.openclaw.ai/concepts/model-failover) — 支援與備援機制

---
*此文件由 AI agent 自動生成，最後更新：2026-04-22*