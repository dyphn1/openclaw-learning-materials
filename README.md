# OpenClaw 學習資料自動化系統

> 建立日期：2026-04-21
> 維護方式：每 4 小時由 cron 自動更新

---

## 目錄結構

```
openclaw-learning/
├── docs/                     # 主要學習文件
│   ├── 01-introduction.md
│   ├── 02-environment-setup.md
│   ├── 03-cli-reference.md
│   ├── ...
│   ├── topic-*.md            # 應用場景主題
│   ├── tutorial-*.md         # 實戰教學
│   └── references/           # 參考資料
│       └── <主題>-ref.md
├── tasks/                    # 工作任務清單
│   └── master-task-list.md   # 主任務清單
├── requments/                # 使用者需求
│   └── req-001-*.md
├── logs/                     # 執行日誌
│   └── autodoc-YYYY-MM-DD.log
└── scripts/                  # 自動化腳本
    ├── manage-cron.sh        # Cron 管理腳本
    ├── openclaw-learning-cron.md   # Cron 設定說明
    └── openclaw-learning-prompt.md # Agent 提示詞
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
