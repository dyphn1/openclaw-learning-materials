# 實戰教學：使用 OpenClaw 進行股票分析自動化

> 難度：⭐⭐⭐
> 預計時間：45 分鐘
> 最後更新：2026-04-23

## 前言
本教學將引導您如何使用 OpenClaw 的 AI 能力與內建技能，建構一個多代理人股票分析系統，自動完成股票選擇、基本面與技術面分析、新聞情緒評估及模擬交易決策。您將學會安裝相關技能、設定 LLM 模型、配置市場數據、透過自然語言指令觸發分析流程，以及使用 Telegram 進行遠端互動。

## 前置條件
- OpenClaw 已安裝並完成基本 onboarding（透過 `openclaw onboard` 或 `openclaw setup`）
- 終端機或命令列介面可用
- 網路連線（以存取金融資料 API 及 LLM 服務）
- 建議準備一個 Telegram 帳號（用於遠端控制及接收分析報告）
- 具備一個 OpenAI 相容的 LLM API 金鑰（如 Claude、Gemini、DeepSeek 等）以啟用深度分析能力
- 安裝 Git（用於版本控制）以及 Node.js 18+（若需運行範例專案）

## 完整步驟

### 步驟 1：安裝市場數據技能
我們將使用 `crypto-stock-market-data` 這個內建技能來取得即時股價、歷史 K 線、公司基本面及加密貨幣資料。

```bash
# 確保 OpenClaw 已啟動
openclaw

# 安裝市場數據技能
install skill crypto-stock-market-data

# 查看技能是否成功安裝
skill list
```

### 步驟 2：設定 LLM 模型
為了讓 OpenClaw 能進行深度分析，我們需要設定一個具備良好推理與程式碼生成能力的語言模型。此範例使用 Claude Sonnet 4.6。

```bash
# 設定模型為 Claude Sonnet 4.6
config set llm.model claude-sonnet-4-20250514
# 設定 Anthropic API 端點（Claude 的 OpenAI 相容介面）
config set llm.baseUrl https://api.anthropic.com/v1
# 請將以下 API Key 替換為您的實際金鑰（注意：請勿提交至版本控制）
config set llm.apiKey sk-ant-your-api-key-here
# 可選：調整 token 上限與溫度以獲得更穩定的輸出
config set llm.maxTokens 4000
config set llm.temperature 0.2
```

### 步驟 3：建立投資組合設定檔
StockClaw 範例中使用 `data/portfolio.json` 來管理模擬投資組合。我們將在 OpenClaw 的工作區中建立類似的結構。

```bash
# 在工作區根目錄建立 data 目錄
mkdir -p data

# 建立範例投資組合檔案
cat > data/portfolio.json << 'EOF'
{
  "cash": 100000,
  "positions": [
    {
      "symbol": "AAPL",
      "shares": 100,
      "entryPrice": 175.5
    },
    {
      "symbol": "MSFT",
      "shares": 50,
      "entryPrice": 380.0
    },
    {
      "symbol": "NVDA",
      "shares": 25,
      "entryPrice": 450.0
    }
  ],
  "createdAt": "2026-03-14T00:00:00Z"
}
EOF
```

### 步驟 4：透過自然語言指令觸發股票分析
現在我們可以使用自然語言指令請求 OpenClaw 對特定股票進行深度分析。OpenClaw 會自動呼叫市場數據技能取得資料，並啟動內建的多代理人分析流程（價值分析師、技術分析師、情緒分析師、風險管理師）。

在 OpenClaw 互動介面（CLI、Telegram、WhatsApp 等）中輸入：

```
對 NVDA 進行深度分析，包括基本面、技術面、新聞情緒與風險評估。
```

您將看到類似以下的執行過程：
1. OpenClaw 呼叫 `crypto-stock-market-data` 取得 NVDA 的即時價格、歷史資料及公司基本資訊。
2. 價值分析師分析財務報表、估值水平（如 EPS、P/E、股息率）。
3. 技術分析師計算移動平均線、相對強弱指數 (RSI)、MACD 等技術指標。
4. 情緒分析師掃描最近新聞與社群討論，判斷市場情緒。
5. 風險管理師根據波動率、歷史回測結果提供風險等級與建議倉位。
6. 根代理人綜合所有專家意見，輸出最終投資建議報告。

### 步驟 5：使用 Telegram 進行遠端控制（可選）
若您想透過手機遠端觸發分析或接收報告，可以設定 Telegram 整合。

```bash
# 在 Telegram 中搜尋 @BotFather，建立新機器人並取得 Bot Token
# 在 OpenClaw 中設定 Telegram
config set telegram.enabled true
config set telegram.botToken YOUR_BOT_TOKEN_HERE
# 重新啟動 OpenClaw 以使設定生效（或透過 reload 指令）
reload
```

設定完成後，在 Telegram 中對您的機器人發送：
```
/analyze NVDA
```
機器人將回傳分析報告。您也可以使用其他指令：
```
/portfolio  - 查看模擬投資組合
/buy AAPL 10 - 模擬買入 10 股 AAPL
/sell MSFT 5 - 模擬賣出 5 股 MSFT
```

### 步驟 6：執行歷史回測驗證策略
OpenClaw 支援使用歷史市場資料進行策略回測。以下範例示範如何對過去 7 天的交易策略進行回測。

在互動介面輸入：
```
將我的投資組合進行歷史回測，回測最近 7 個交易日
```
或透過 Telegram：
```
/backtest my portfolio for the last 7 trading days
```

OpenClaw 會：
1. 準備歷史市場資料（使用 T-1 快照避免看ahead bias）。
2. 隔離每個交易日的決策環境。
3. 模擬每日交易決策。
4. 計算報酬率、最大回撤、夏普比率等指標。
5. 生成詳細回測報告。

### 步驟 7：自動化每日趨勢報告（進階應用）
利用 OpenClaw 的 cron 功能，您可以設定每日自動執行股票掃描並將結果發送到您的通訊頻道。

```bash
# 建立每日早上 8:00 執行熱門掃描的 cron 作業
cron add --schedule "0 8 * * *" --command "skills run crypto-stock-market-data hot_scanner --notify telegram"
# 查看已設定的 cron 作業
cron list
```

這樣，您每天早上都會收到當天熱門股票與加密貨幣的掃描結果。

## 進階應用
- **多代理協作擴展**：除了內建的四大分析師，您可以開發自訂代理人（例如：宏觀經濟分析師、產業週期分析師）並將它們加入分析流程。
- **整合外部數據源**：透過 MCP（Model Context Protocol）或自訂技能，整合更多金融數據源如 Alpha Vantage、Finnhub 或台灣證券交易所資料。
- **自訂交易策略**：開發專屬的選股與交易策略腳本，結合 OpenClaw 的執行環境進行自動化盤中交易。
- **風險管理儀表板**：使用 OpenClaw 的 UI 能力或網頁介面建構個人化的投資組合監控儀表板，即時顯示持倉盈虧、風險曝露與分析建議。

## 小結
在這個教學中，您學會了：
- 如何安裝並設定市場數據技能與 LLM 模型以啟用深度分析能力。
- 建立模擬投資組合設定檔以進行投資管理。
- 透過自然語言指令觸發多代理人股票分析流程，獲得價值、技術、情緒與風險的綜合評估。
- 使用 Telegram 進行遠端控制及接收分析報告。
- 執行歷史回測驗證投資策略的過往表現。
- 利用 cron 功能自動化每日趨勢報告。

透過這些步驟，您現在可以利用 OpenClaw 的強大 AI 能力來輔助投資決策，自動化金融資訊的收集與分析流程。隨著您對系統的熟悉，您可以進一步探索其擴展性，將其整合到更廣泛的自動化工作流程中，例如自動化財報解讀、市場情緒監控或量化交易策略的開發與回測。

---
*此文件由 AI agent 自動生成，最後更新：2026-04-23*