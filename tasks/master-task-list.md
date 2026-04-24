# OpenClaw 學習資料工作任務清單

> 建立日期：2026-04-21
> 狀態：進行中（由 cron 自動維護）

---

## 一、基礎文件任務

### task-01：OpenClaw 簡介
- 對應 doc：/Users/daniel.chang/Desktop/openclaw-learning/docs/01-introduction.md
- 狀態：待執行
- [ ] 什麼是 OpenClaw（定義、特色、使用情境）
- [ ] 支援的通道清單（WhatsApp/Telegram/Discord 等）
- [ ] 系統需求（Node 22+、硬體需求）
- [ ] 與其他 AI 助理的比較

### task-02：安裝與環境設定
- 對應 doc：/Users/daniel.chang/Desktop/openclaw-learning/docs/02-environment-setup.md
- 狀態：待執行
- [ ] 安裝方式（npm/pnpm/bun）
- [ ] `openclaw onboard` 互動式設定流程說明
- [ ] Docker 安裝方式
- [ ] Nix 安裝方式
- [ ] 常見安裝問題排錯

### task-03：CLI 指令完整說明
- 對應 doc：/Users/daniel.chang/Desktop/openclaw-learning/docs/03-cli-reference.md
- 狀態：待執行
- [ ] `openclaw` 主要指令一覽
- [ ] `openclaw cron` 完整說明
- [ ] `openclaw acp` 說明
- [ ] `openclaw onboard` 說明
- [ ] 常用旗標與選項

### task-04：設定檔詳解
- 對應 doc：/Users/daniel.chang/Desktop/openclaw-learning/docs/04-configuration.md
- 狀態：待執行
- [ ] config 檔案位置與格式
- [ ] 各欄位說明（providers/channels/cron 等）
- [ ] 環境變數設定
- [ ] 安全性設定（secrets 管理）

### task-05：通道整合
- 對應 doc：/Users/daniel.chang/Desktop/openclaw-learning/docs/05-channels.md
- 狀態：待執行
- [ ] Telegram Bot 設定步驟
- [ ] Discord Bot 設定步驟
- [ ] WhatsApp 設定步驟
- [ ] iMessage/BlueBubbles 設定步驟
- [ ] 其他通道快速設定

---

## 二、進階功能任務

### task-06：定時任務（Cron）
- 對應 doc：/Users/daniel.chang/Desktop/openclaw-learning/docs/06-cron-scheduling.md
- 狀態：待執行
- [ ] Cron 基本概念與 CLI 語法
- [ ] `--session main` vs `isolated` vs `current` 差異
- [ ] 排程表達式說明（5 欄位格式）
- [ ] delivery 模式（announce/webhook/none）
- [ ] 失敗重試機制與錯誤通知

### task-07：Skills 與 Agent 設計
- 對應 doc：/Users/daniel.chang/Desktop/openclaw-learning/docs/07-skills-agents.md
- 狀態：待執行
- [ ] Skill 定義與 SKILL.md 格式
- [ ] Agent 任務設計模式
- [ ] 多 Agent 協作設計
- [ ] 自定義 skill 開發

### task-08：MCP 工具整合
- 對應 doc：/Users/daniel.chang/Desktop/openclaw-learning/docs/08-mcp-tools.md
- 狀態：待執行
- [ ] MCP 協議說明
- [ ] 設定 MCP 伺服器
- [ ] 常用 MCP 工具清單
- [ ] 自定義 MCP 工具開發

### task-09：AI 模型供應商設定
- 對應 doc：/Users/daniel.chang/Desktop/openclaw-learning/docs/09-providers.md
- 狀態：待執行
- [ ] OpenAI 設定
- [ ] Anthropic Claude 設定
- [ ] 本地模型（Ollama）設定
- [ ] OpenRouter 設定
- [ ] 模型備援鏈（fallback chain）設定

### task-10：插件 SDK 開發
- 對應 doc：/Users/daniel.chang/Desktop/openclaw-learning/docs/10-plugin-sdk.md
- 狀態：待執行
- [ ] Plugin SDK 架構說明
- [ ] 建立第一個插件
- [ ] 插件發布流程
- [ ] SDK API 參考

---

## 三、應用場景任務

### task-topic-stock：股票分析自動化
- 對應 doc：/Users/daniel.chang/Desktop/openclaw-learning/docs/topic-stock-analysis.md
- 狀態：待執行
- [ ] 設定股票資料 MCP 工具
- [ ] 定時抓取股市資料的 cron 設定
- [ ] 技術分析 prompt 設計
- [ ] 推播結果至 Telegram 設定

### task-topic-code：自動寫 Code 場景
- 對應 doc：/Users/daniel.chang/Desktop/openclaw-learning/docs/topic-code-automation.md
- 狀態：待執行
- [ ] 程式碼生成 prompt 模板
- [ ] 與 Git 整合的工作流程
- [ ] Code Review 自動化
- [ ] 測試生成場景

### task-topic-document：文件分析場景
- 對應 doc：/Users/daniel.chang/Desktop/openclaw-learning/docs/topic-document-analysis.md
- 狀態：待執行
- [ ] PDF/文件讀取工具設定
- [ ] 摘要生成 prompt 設計
- [ ] 批次處理文件的 cron 設定
- [ ] 輸出格式化設定

### task-topic-learning：自動化學習場景
- 對應 doc：/Users/daniel.chang/Desktop/openclaw-learning/docs/topic-learning-automation.md
- 狀態：待執行
- [ ] 每日學習摘要 cron 設定
- [ ] 網路資料收集設定
- [ ] 學習進度追蹤設計
- [ ] 知識庫建立流程

### task-topic-data：資料收集與整理
- 對應 doc：/Users/daniel.chang/Desktop/openclaw-learning/docs/topic-data-collection.md
- 狀態：待執行
- [ ] web_search / web_fetch 工具使用
- [ ] 資料結構化輸出設定
- [ ] 定期資料更新 cron 設定

---

## 四、實戰教學任務

### tutorial-stock：股票分析完整工作流程
- 對應 doc：/Users/daniel.chang/Desktop/openclaw-learning/docs/tutorial-stock-workflow.md
- 狀態：待執行
- [ ] 從安裝到第一次分析的完整步驟
- [ ] 每個步驟的詳細說明與截圖/輸出範例
- [ ] 常見問題排解

### tutorial-code：程式碼生成完整工作流程
- 對應 doc：/Users/daniel.chang/Desktop/openclaw-learning/docs/tutorial-code-generation.md
- 狀態：待執行
- [ ] 設定開發環境
- [ ] 建立第一個自動化 code 生成流程
- [ ] 整合 CI/CD 管道

### tutorial-research：研究調查完整工作流程
- 對應 doc：/Users/daniel.chang/Desktop/openclaw-learning/docs/tutorial-research-workflow.md
- 狀態：待執行
- [ ] 定義研究目標
- [ ] 設定資料收集 cron
- [ ] 報告生成流程
- [ ] 結果傳送至通道

---

## 五、原始碼分析任務

### analysis-versions：版本分析文件建立
- 輸出目錄：/Users/daniel.chang/Desktop/openclaw-analysis/
- 狀態：待執行
- [ ] 找出所有 v2026. 開頭的 tag
- [ ] 從舊到新逐版建立分析文件
- [ ] 使用 mkdocs + mike 格式
- [ ] 每版本包含：架構說明、核心模組、插件分析、版本差異

---

## 執行記錄

| 日期 | 執行次數 | 新增 docs | 更新 docs | 分析版本 |
|------|---------|----------|----------|---------|
| 2026-04-21 | 0 (初始化) | 0 | 0 | 待執行 |
