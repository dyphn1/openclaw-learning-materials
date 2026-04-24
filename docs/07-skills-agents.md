# Skills 與 Agent 設計 (Skills and Agent Design)

> 最後更新：2026-04-22

## 什麼是 Skills 與 Agent 設計？
OpenClaw 透過 **Skill**（技能）系統來賦予代理人（Agent）特定能力。每個 Skill 是一個模組化的功能包，包含說明文件（SKILL.md）以及可選的腳本、設定與依賴。Agent 則是負責理解使用者意圖、選擇適當的工具與 Skill 來執行任務的核心元件。透過 Skill 系統，開發者可以擴展 OpenClaw 的功能而不需修改核心程式碼，同時能依據環境、設定或二進位檔案的存在動態載入或過濾 Skills。

## 安裝 / 環境需求
- 已安裝 OpenClaw 並完成基本設定（請參見 01-introduction.md 與 02-environment-setup.md）
- Skill 系統內建於 OpenClaw，無需額外安裝
- 要開發自訂 Skill，建議具備基本的 Markdown 與 YAML 語法知識
- 若 Skill 需要特定二進位工具（如 `git`, `ffmpeg`），請確認該工具已在系統 PATH 中或透過 Skill 的 `requires.bins` 宣告

## 核心概念
### Skill 結構
每個 Skill 必須包含一個 `SKILL.md` 檔案，其開頭需有 YAML frontmatter，例如：
```markdown
---
name: my-skill
description: 這是我的自訂技能
---
```
以下為可選 frontmatter 欄位：
- `homepage`：技能相關網站 URL
- `user-invocable`：是否在聊天中以斜線命令觸發（預設 true）
- `disable-model-invocation`：是否從模型提示中隱藏此技能（預設 false）
- `command-dispatch`：設為 `tool` 時直接呼叫工具，繞過模型
- `command-tool`：當 `command-dispatch: tool` 時要呼叫的工具名稱
- `command-arg-mode`：工具派遣時的參數模式（預設 `raw`）

### 載入優先順序
OpenClaw 會從以下位置載入 Skill，名稱衝突時以下列優先序決定哪一份會被使用：
1. `<workspace>/skills`（最高優先順序）
2. `<workspace>/.agents/skills`
3. `~/.agents/skills`
4. `~/.openclaw/skills`（管理/本地 Skill）
5. 捆綁 Skill（隨安裝包一起提供）
6. `skills.load.extraDirs`（最低優先順序）

### 代理人技能白名單
即使 Skill 被載入，代理人仍需透過 `agents.list[].skills` 或 `agents.defaults.skills` 明確允許才能使用。例如：
```json5
{
  agents: {
    defaults: {
      skills: [\"github\", \"weather\"], // 預設所有代理人可用的技能
    },
    list: [
      { id: \"writer\" }, // 繼承預設技能：github, weather
      { id: \"docs\", skills: [\"docs-search\"] }, // 完全覆寫預設，只允許 docs-search
      { id: \"locked-down\", skills: [] }, // 不允許任何技能
    ],
  },
}
```

### Load-time 過濾（Gating）
Skill 可透過 `metadata.openclaw.requires` 在載入時根據環境條件過濾，常見條件包括：
- `requires.bins`：PATH 中必須存在的二進位檔案列表
- `requires.anyBins`：列表中至少一個必須存在
- `requires.env`：環境變數必須存在（或在 openclaw.json 中設定）
- `requires.config`：openclaw.json 中必須為真的設定路徑
- `os`：限定僅在特定作業系統載入（darwin, linux, win32）
- `always: true`：跳過所有過濾，強制載入

例如，需要 `uv` 二進位且設定 `browser.enabled` 為 true 的 Skill：
```markdown
---
name: image-lab
description: 生成或編輯圖像
metadata:
  openclaw:
    requires:
      bins: [\"uv\"]
      config: [\"browser.enabled\"]
---
```

### 環境變數與 API Key 注入
當代理人執行時，OpenClaw 會根據 `skills.entries.<skill-name>.env` 或 `.apiKey` 把祕密注入到該次執行的 process.env（僅限於該代理人執行週期），例如：
```json5
{
  skills: {
    entries: {
      \"gemini\": {
        enabled: true,
        apiKey: { source: \"env\", provider: \"default\", id: \"GEMINI_API_KEY\" },
        env: {
          GEMINI_API_KEY: \"your-key-here\"
        }
      }
    }
  }
}
```

### Skill Workshop（實驗性功能）
透過啟用 `plugins.entries.skill-workshop`，OpenClaw 可以觀察代理人執行過程中的程序，並自動產生或更新工作區 Skill。適合將經驗轉化為可重複使用的自動化步驟。

## CLI 指令說明
OpenClaw 提供 `openclaw skills` 系列指令來管理 Skill：

```bash
# 列出目前可用的 Skill（已載入且符合過濾條件）
openclaw skills list

# 安裝來自 ClawHub 的 Skill 到目前工作區
openclaw skills install <skill-slug>

# 更新所有已安裝的 Skill
openclaw skills update --all

# 查詢特定 Skill 的詳細資訊
openclaw skills show <skill-name>

# 重新載入 Skill（變更 SKILL.md 後使用）
openclaw skills reload

# 在啟用/禁用某個 Skill（需在 openclaw.json 中設定）
openclaw config set skills.entries.<skill-name>.enabled true
```

## 實際應用範例

### 場景一：安裝並使用 GitHub Skill
假設你希望透過自然語言查詢倉庫議題或建立 Pull Request：
```bash
# 從 ClawHub 安裝 GitHub Skill
openclaw skills install github
# 重新載入讓新 Skill 生效
openclaw skills reload
# 在支援的通訊平台上輸入：
/github list-issues --label bug --limit 5
```
OpenClaw 會呼叫 GitHub Skill，使用預設設定（或你在 openclaw.json 中提供的 GITHUB_TOKEN）來列出帶有 bug 標籤的議題。

### 場景二：建立自訂 Skill 天氣查詢
1. 建立 skill 目錄：
```bash
mkdir -p ~/.openclaw/skills/weather-skill
```
2. 建立 SKILL.md：
```markdown
---
name: weather-skill
description: 查詢目前天氣與預報
user-invocable: true
---
## 什麼是 weather-skill？
此技能使用 wttr.in 服務取得指定位置的天氣資訊。

## 安裝 / 環境需求
- 需要網路連線以存取 wttr.in
- 無需額外安裝

## 使用範例
在聊天中輸入：
/weather-skill Taipei
```
/weather-skill New York
```
將會回傳對應城市的天氣摘要。

## 應用主題分類

| 主題 | 適用場景 | 複雜度 |
|------|---------|-------|
| 股票分析 | 使用財經 API 技能自動抓取股價並產出圖表 | ⭐⭐⭐ |
| 自動寫 code | 結合程式碼生成技能與重構技能協作開發功能 | ⭐⭐ |
| 文件分析 | 搭配文件摘要技能與翻譯技能處理長篇報告 | ⭐⭐ |

## 常見問題與排錯
| 問題 | 原因 | 解法 |
|------|------|------|
| Skill 未出現在 `openclaw skills list` | 沒有被載入（位置錯誤）或被過濾掉 | 檢查 Skill 放置位置；使用 `openclaw skills show <name>` 查看載入原因；確認 `metadata.openclaw.requires` 條件是否符合 |
| 使用 Skill 時找不到所需二進位工具 | `requires.bins` 中宣告的工具未安裝或不在 PATH | 安裝缺少的工具；或在 Skill 中調整 `requires.bins`；或透過 `agents.defaults.sandbox.docker.setupCommand` 在沙箱中安裝 |
| 環境變數注入失敗 | `apiKey` 或 `env` 設定錯誤或祕密已被其他程序覆寫 | 檢查 `openclaw.json` 中的 `skills.entries.<skill-name>` 設定；確認變數名稱無誤；使用 `openclaw config show skills` 檢查 |
| Skill 啟用後仍無法觸發 | 代理人未被授權使用該 Skill | 檢查 `agents.list[].skills` 或 `agents.defaults.skills` 是否包含該 Skill 名稱 |
| Skill 在沙箱中執行失敗 | 所需工具未在沙箱鏡像中提供 | 在 `agents.defaults.sandbox.docker.setupCommand` 中加入安裝該工具的步驟；或將 `requires.bins` 設為空並改用宿主機執行（降低安全性） |

## 參考資源
- [官方文件 - Skills](https://docs.openclaw.ai/tools/skills) — 最新官方說明
- [GitHub](https://github.com/openclaw/openclaw) — 原始碼與 Issues
- [Discord](https://discord.gg/clawd) — 社群討論
- [ClawHub - 公共 Skill 註冊表](https://clawhub.ai) — 瀏覽、安裝與發布 Skill
- [Building Advanced Agent Skills for OpenClaw (DEV Community)](https://dev.to/volodymyr_nehir/building-advanced-agent-skills-for-openclaw-h36) — 進階技能開發教學
- [AgentSkills 官方規格](https://agentskills.io) — Skill 格式標準說明

---
*此文件由 AI agent 自動生成，最後更新：2026-04-22*