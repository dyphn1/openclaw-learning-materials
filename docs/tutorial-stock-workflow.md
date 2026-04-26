# 實戰教學：使用 OpenClaw 進行股票分析完整工作流程

> 難度：⭐⭐⭐
> 預計時間：30 分鐘
> 最後更新：2026-04-24

## 前言
本教學將指導您如何使用 OpenClaw 建立一個完整的股票分析自動化工作流程。涵蓋從市場數據擷取、技術分析、新聞情緒分析到最終報告生成的整個流程。完成本教學後，您將能夠建立一個自動化的股票監控系統，能夠即時分析市場數據並生成投資建議報告。

## 前置條件
- OpenClaw 已安裝並設定完成
- 具備基本的 JavaScript/TypeScript 程式能力
- 了解股票市場基本概念
- 準備好 API 金鑰（用於市場數據擷取）
- 熟悉 OpenClaw CLI 基本操作

## 完整步驟

### 步驟 1：設定市場數據擷取

首先設定 OpenClaw 以擷取市場數據。我們將配置台股與美股的數據源。

```bash
# 查看可用的市場數據提供者
openclaw config get models --json

# 設定市場數據提供者
openclaw config set models.twse '{"provider":"twse","enabled":true}' --strict-json
openclaw config set models.yfinance '{"provider":"yfinance","enabled":true}' --strict-json

# 驗證設定
openclaw config validate
```

設定檔範例：
```json5
{
  "models": {
    "twse": {
      "provider": "twse",
      "enabled": true,
      "symbols": ["2330", "2317", "2454"]
    },
    "yfinance": {
      "provider": "yfinance", 
      "enabled": true,
      "symbols": ["AAPL", "GOOGL", "MSFT"]
    }
  }
}
```

### 步驟 2：建立技術分析 Agent

建立一個專門用於技術分析的 Agent，設定其技能與模型偏好。

```bash
# 建立技術分析 Agent
openclaw agents create --name technical-analysis-agent \
  --skills "technical-analysis,chart-patterns,indicators" \
  --model "gpt-4-turbo" \
  --contextLimits '{"memory":5000,"toolResults":3000}'

# 設定 Agent 的市場數據權限
openclaw config set agents.list.0.tools '["market-data","chart-analysis","indicator-calculation"]' --strict-json
```

Agent 設定檔：
```json5
{
  "agents": {
    "list": [
      {
        "id": "technical-analysis-agent",
        "name": "技術分析 Agent",
        "skills": ["technical-analysis", "chart-patterns", "indicators"],
        "model": "gpt-4-turbo",
        "contextLimits": {
          "memory": 5000,
          "toolResults": 3000
        },
        "tools": ["market-data", "chart-analysis", "indicator-calculation"]
      }
    ]
  }
}
```

### 步驟 3：配置技術指標計算

設定 OpenClaw 計算常用的技術指標，如 RSI、MACD、布林通道等。

```bash
# 設定技術指標參數
openclaw config set analysis.indicators.rsi '{"period":14,"overbought":70,"oversold":30}' --strict-json
openclaw config set analysis.indicators.macd '{"fast":12,"slow":26,"signal":9}' --strict-json
openclaw config set analysis.indicators.bollinger '{"period":20,"stdDev":2}' --strict-json

# 驗證技術指標設定
openclaw config validate
```

### 步驟 4：建立新聞情緒分析 Agent

建立一個用於分析新聞與市場情緒的 Agent。

```bash
# 建立情緒分析 Agent
openclaw agents create --name sentiment-analysis-agent \
  --skills "sentiment-analysis,news-classification,market-sentiment" \
  --model "claude-3-sonnet" \
  --contextLimits '{"memory":8000,"toolResults":4000}"

# 設定新聞數據源
openclaw config set news.providers '{"enabled":true,"sources":["reuters","bloomberg","cnbc"]}' --strict-json
```

### 步驟 5：建立定時分析任務

使用 OpenClaw 的 cron 功能建立定時分析任務。

```bash
# 建立每日盤後分析任務
openclaw cron add \
  --name "daily-market-analysis" \
  --schedule "0 18 * * 1-5" \
  --session "technical-analysis-agent" \
  --prompt "分析今日台股與美股市場走勢，重點關注：1) 主要指標變化 2) 成交量異動 3) 新聞情緒 4) 技術分析訊號" \
  --announce \
  --account "trading-bot"

# 建立即時監控任務（每5分鐘檢查一次）
openclaw cron add \
  --name "real-time-monitor" \
  --schedule "*/5 * * * 1-5" \
  --session "technical-analysis-agent" \
  --prompt "監控關注股價異動，當價格波動超過5%時發送警報" \
  --no-deliver \
  --account "monitoring-bot"

# 檢查任務狀態
openclaw cron list
```

### 步驟 6：設定報告生成模板

建立用於生成分析報告的模板與格式。

```bash
# 建立報告生成 Agent
openclaw agents create --name report-generator-agent \
  --skills "report-generation,financial-analysis,visualization" \
  --model "gpt-4-turbo" \
  --contextLimits '{"memory":10000,"toolResults":5000}"

# 設定報告格式偏好
openclaw config set reports.format '{"type":"markdown","includeCharts":true,"sections":["summary","technical","sentiment","recommendation"]}' --strict-json
```

### 步驟 7：建立警報通知系統

設定當市場出現異常時的警報通知。

```bash
# 設定警報條件
openclaw config set alerts.thresholds '{"priceDrop":5,"volumeSpike":200,"rsiOversold":30,"macdSignal":true}' --strict-json

# 建立警報通知任務
openclaw cron add \
  --name "price-alert-checker" \
  --schedule "*/10 * * * 1-5" \
  --session "technical-analysis-agent" \
  --prompt "檢查所有關注股是否觸發警報條件，若觸發則生成詳細警報訊息" \
  --announce \
  --account "alert-system"
```

### 步驟 8：設定數據持久化

配置市場數據與分析結果的存儲。

```bash
# 設定數據庫連線
openclaw config set database.type "sqlite"
openclaw config set database.path "~/.openclaw/market-data.db"

# 設定數據保留策略
openclaw config set data.retention '{"marketData":"30d","analysisResults":"90d","reports":"1y"}' --strict-json
```

### 步驟 9：建立監控與診斷

設定系統監控與診斷功能。

```bash
# 設定日誌級別
openclaw config set logging.level "info"

# 設定監控警報
openclaw config set monitoring.alerts '{"apiFailures":3,"dataLatency":300000,"memoryUsage":0.8}' --strict-json

# 啟動監控任務
openclaw cron add \
  --name "system-monitor" \
  --schedule "*/30 * * * *" \
  --session "report-generator-agent" \
  --prompt "檢查系統狀態與數據品質，生成監控報告" \
  --no-deliver \
  --account "system-monitor"
```

### 步驟 10：最終產出與驗證

驗證整個工作流程是否正常運作。

```bash
# 手動執行一次分析任務
openclaw cron run --name "daily-market-analysis"

# 檢查任務執行歷史
openclaw cron runs --name "daily-market-analysis" --limit 5

# 查看生成的報告
openclaw config get reports.outputDir --json

# 驗證系統狀態
openclaw doctor
```

## 進階應用

### 數據整合與擴展

```bash
# 整合額外的數據源
openclaw config set datafeeds.crypto '{"enabled":true,"provider":"binance","symbols":["BTCUSDT","ETHUSDT"]}' --strict-json
openclaw config set datafeeds.options '{"enabled":true,"provider":"marketdata","symbols":["AAPL_250524_C170"]}' --strict-json

# 設定數據清理任務
openclaw cron add \
  --name "data-cleanup" \
  --schedule "0 2 * * *" \
  --session "report-generator-agent" \
  --prompt "清理過期的數據與報告，保留符合retention政策的內容" \
  --no-deliver \
  --account "maintenance"
```

### 高級分析策略

```bash
# 設定機器學習模型
openclaw config set ml.models '{"trend-prediction":{"type":"lstm","features":["price","volume","rsi","macd"]},"sentiment-analysis":{"type":"transformer","model":"finbert"}}' --strict-json

# 建立策略回測任務
openclaw cron add \
  --name "backtesting" \
  --schedule "0 20 * * 1-5" \
  --session "technical-analysis-agent" \
  --prompt "執行策略回測，分析過去30天的交易表現與風險指標" \
  --announce \
  --account "backtesting"
```

### 風險管理

```bash
# 設定風險管理參數
openclaw config set risk.management '{"maxPositionSize":0.1,"stopLoss":0.05,"takeProfit":0.15,"maxDrawdown":0.2}' --strict-json

# 建立風險監控任務
openclaw cron add \
  --name "risk-monitor" \
  --schedule "*/15 * * * 1-5" \
  --session "report-generator-agent" \
  --prompt "監控投資組合風險，檢查倉位集中度、VAR、最大回撤等指標" \
  --announce \
  --account "risk-management"
```

## 小結

本教學展示了如何使用 OpenClaw 建立一個完整的股票分析自動化工作流程。關鍵學習點包括：

1. **多層架構設計**：將數據擷取、技術分析、情緒分析、報告生成分離到不同 Agent
2. **定時任務管理**：使用 cron 功能建立不同頻率的分析任務
3. **數據管道設計**：從市場數據到最終報告的完整數據流
4. **風險管理整合**：將風險監控納入日常工作流程
5. **系統監控與維護**：確保系統穩定運作的監控機制

透過這個架構，您可以建立一個既能即時響應市場變化，又能進行深度分析的自動化股票分析系統。根據您的具體需求，可以進一步擴展功能，如加入更多的技術指標、機器學習模型或整合其他數據源。

---
*此文件由 AI agent 自動生成並持續更新*

## 更新記錄
- 2026-04-24：建立完整的股票分析工作流程教學，包含10個詳細步驟與進階應用場景