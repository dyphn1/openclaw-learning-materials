# OpenClaw 學習自動化 Cron 設定

兩個 cron 任務，職責分離：

| 任務名稱 | 職責 | 頻率 |
|----------|------|------|
| `openclaw-analysis` | 原始碼深度分析、架構文件、安全性分析 | 每天 02:00 |
| `openclaw-learning-autodoc` | 學習文件深化、網路資料收集、教學製作 | 每 6 小時 |

---

## 一、原始碼分析 Cron

**每天凌晨 2 點執行，專注於分析新版本原始碼。**

```bash
openclaw cron add \
  --name "openclaw-analysis" \
  --cron "0 2 * * *" \
  --tz "Asia/Taipei" \
  --session isolated \
  --message "$(cat /Users/daniel.chang/Desktop/openclaw-learning/scripts/openclaw-analysis-prompt.md)" \
  --announce \
  --stagger 120s
```

執行時間：每天 02:00 (Asia/Taipei)

---

## 二、學習資料自動化 Cron

**每 6 小時執行，專注於學習文件的深化與更新。**

```bash
openclaw cron add \
  --name "openclaw-learning-autodoc" \
  --cron "0 */6 * * *" \
  --tz "Asia/Taipei" \
  --session isolated \
  --message "$(cat /Users/daniel.chang/Desktop/openclaw-learning/scripts/openclaw-learning-prompt.md)" \
  --announce \
  --stagger 60s
```

執行時間：00:00, 06:00, 12:00, 18:00 (Asia/Taipei)

---

## 三、查看與管理任務

```bash
# 列出所有 cron 任務
openclaw cron list

# 查看指定任務詳情
openclaw cron show <job-id>

# 查看執行歷史（確認是否有錯誤）
openclaw cron runs --id <job-id>

# 手動立即觸發（測試用）
openclaw cron run <job-id>
```

## 四、調整任務

```bash
# 暫停任務（例如暫停分析 cron）
openclaw cron edit <job-id> --pause

# 恢復任務
openclaw cron edit <job-id> --resume

# 修改排程頻率
openclaw cron edit <job-id> --cron "0 */12 * * *"

# 刪除任務
openclaw cron delete <job-id>
```

## 五、排程說明

### openclaw-analysis（每日）

| 欄位 | 值 | 說明 |
|------|-----|------|
| 分鐘 | 0 | 整點觸發 |
| 小時 | 2 | 凌晨 2 點 |
| 日 | * | 每天 |
| 月 | * | 每月 |
| 星期 | * | 每週 |
| 時區 | Asia/Taipei | GMT+8 台灣時間 |

適合在凌晨執行：原始碼分析耗時較長，不與日間學習 cron 競爭資源。

### openclaw-learning-autodoc（每 6 小時）

| 欄位 | 值 | 說明 |
|------|-----|------|
| 分鐘 | 0 | 整點觸發 |
| 小時 | */6 | 每 6 小時 |
| 日 | * | 每天 |
| 月 | * | 每月 |
| 星期 | * | 每週 |
| 時區 | Asia/Taipei | GMT+8 台灣時間 |

觸發時間：00:00, 06:00, 12:00, 18:00（台灣時間）
每次最多處理 2 個主題 + 1 個實戰教學，約 10-20 分鐘完成。

## 六、Prompt 對應關係

| Cron 任務 | Prompt 檔案 | 輸出目錄 |
|-----------|------------|---------|
| `openclaw-analysis` | `scripts/openclaw-analysis-prompt.md` | `Desktop/openclaw-analysis/<version>/` |
| `openclaw-learning-autodoc` | `scripts/openclaw-learning-prompt.md` | `Desktop/openclaw-learning/docs/` |

References（網路來源）一律儲存至：
`Desktop/openclaw-learning/docs/references/<主題名>-ref.md`

