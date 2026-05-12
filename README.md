# OpenClaw 學習資料自動化系統

> 建立日期：2026-04-21  
> 更新日期：2026-05-09  
> 維護方式：Agentic Pipeline（4 個 AI Agent 協作）

---

## Agentic Pipeline

本工作區採用閉環 4-agent 文件生產流程：

```
Orchestrator（大腦）
  ↓ 從 tasks/backlog.json 建立任務卡
Content Researcher（眼睛）
  ↓ 研究 OpenClaw 原始碼，產出 Fact Sheet
Document Writer（雙手）
  ↓ 撰寫學習指南（>1500 字，含 Mermaid 架構圖）
Quality Validator（審核）
  ↓ 通過 → 歸檔 ✅
  ↓ 未通過 → 退回 Document Writer 修正 🔁
```

啟動流程：在 GitHub Copilot Chat 中使用 `#agent-launcher` skill 或直接呼叫 Orchestrator agent。

### Agent 定義位置

| Agent | 檔案 |
|-------|------|
| Orchestrator | `.github/agents/orchestrator.agent.md` |
| Content Researcher | `.github/agents/content-researcher.agent.md` |
| Document Writer | `.github/agents/document-writer.agent.md` |
| Quality Validator | `.github/agents/quality-validator.agent.md` |

---

## 目錄結構

```
openclaw-learning/
├── .github/                  # Agentic pipeline 定義
│   ├── agents/               # 4 個 agent 定義檔
│   │   ├── orchestrator.agent.md
│   │   ├── content-researcher.agent.md
│   │   ├── document-writer.agent.md
│   │   └── quality-validator.agent.md
│   ├── instructions/         # 狀態機指令
│   │   └── orchestrator.instructions.md
│   └── skills/               # 入口 skill
│       └── agent-launcher/
│           └── SKILL.md
├── docs/                     # 主要學習文件（pipeline 輸出）
│   ├── 01-introduction.md
│   ├── 02-environment-setup.md
│   ├── 03-cli-reference.md
│   ├── ...
│   ├── topic-*.md            # 應用場景主題
│   ├── tutorial-*.md         # 實戰教學
│   └── references/           # 參考資料
├── tasks/                    # 任務管理（JSON 格式）
│   ├── backlog.json          # 待執行任務清單（20 個主題）
│   ├── active/               # 進行中任務卡
│   ├── completed/            # 待驗證任務卡
│   ├── archived/             # 已通過驗證任務卡
│   ├── context/              # Fact Sheets（研究結果）
│   └── specs/                # 舊式任務規格（歷史參考）
├── requirements/             # 使用者需求
│   └── req-001-*.md
├── logs/                     # 執行日誌
│   └── orchestrator.log
└── scripts/                  # 自動化腳本
    └── manage-cron.sh
```

程式碼分析輸出：
```
openclaw-analysis/
└── <版本號>/
    ├── README.md
    ├── architecture.md
    ├── core-modules.md
    ├── extensions.md
    └── changelog-notes.md
```

---

## 快速開始

### 啟動 Cron 任務

```bash
cd /Users/daniel.chang/Desktop/openclaw-learning/scripts

# 1. 新增 cron 任務（每 4 小時自動執行）
./manage-cron.sh add

# 2. 立即觸發一次（測試用）
./manage-cron.sh run

# 3. 查看執行狀態
./manage-cron.sh status
```

### 查看學習資料

```bash
# 查看最新執行日誌
./manage-cron.sh logs

# 瀏覽文件目錄
ls /Users/daniel.chang/Desktop/openclaw-learning/docs/

# 查看任務清單
cat /Users/daniel.chang/Desktop/openclaw-learning/tasks/master-task-list.md
```

---

## 自動化流程說明

每次 cron 觸發時，agent 會依序執行：

```
第一階段  →  更新 OpenClaw 原始碼，分析新版本 tag
    ↓
第二階段  →  盤點現有 docs，找出主題缺口
    ↓
第三階段  →  網路收集資料，撰寫/更新 docs
    ↓
第四階段  →  製作實戰教學（輪替主題）
    ↓
第五階段  →  更新任務狀態，寫入執行日誌
```

每次執行最多處理：**2 個主題 + 1 個實戰教學**（避免超時）

---

## 涵蓋的學習主題

### 基礎文件（01-10）
| 文件 | 主題 | 狀態 |
|------|------|------|
| 01-introduction.md | OpenClaw 簡介 | 待建立 |
| 02-environment-setup.md | 安裝與環境設定 | 待建立 |
| 03-cli-reference.md | CLI 指令說明 | 待建立 |
| 04-configuration.md | 設定檔詳解 | 待建立 |
| 05-channels.md | 通道整合 | 待建立 |
| 06-cron-scheduling.md | 定時任務 | 待建立 |
| 07-skills-agents.md | Skills 與 Agent | 待建立 |
| 08-mcp-tools.md | MCP 工具整合 | 待建立 |
| 09-providers.md | AI 模型供應商 | 待建立 |
| 10-plugin-sdk.md | 插件 SDK 開發 | 待建立 |

### 應用場景（topic-*）
| 文件 | 場景 | 狀態 |
|------|------|------|
| topic-stock-analysis.md | 股票分析 | 待建立 |
| topic-code-automation.md | 自動寫 code | 待建立 |
| topic-document-analysis.md | 文件分析 | 待建立 |
| topic-learning-automation.md | 自動化學習 | 待建立 |
| topic-data-collection.md | 資料收集 | 待建立 |

### 實戰教學（tutorial-*）
| 文件 | 教學主題 | 狀態 |
|------|---------|------|
| tutorial-stock-workflow.md | 股票分析完整流程 | 待建立 |
| tutorial-code-generation.md | 程式碼生成流程 | 待建立 |
| tutorial-research-workflow.md | 研究調查流程 | 待建立 |

---

## 相關連結

- [OpenClaw 官方文件](https://docs.openclaw.ai)
- [GitHub](https://github.com/openclaw/openclaw)
- [Discord 社群](https://discord.gg/clawd)
- [原始碼](../openclaw/) ← 本機複本
- [原始碼分析](../openclaw-analysis/) ← 版本分析文件
