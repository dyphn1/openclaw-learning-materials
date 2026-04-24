# 實戰教學：使用 OpenClaw 進行股票分析

> 難度：⭐⭐⭐
> 預計時間：30 分鐘
> 最後更新：2026-04-22

## 前言
這個教學將引導您如何使用 OpenClaw 的 stock-analysis 技能來分析股票和加密貨幣，管理投資組合，設定監清單與警報，並利用病毒趨勢掃描器發現熱門投資標的。您將學會安裝技能、設定參數、執行分析以及解讀結果。

## 前置條件
- OpenClaw 已安裝並設定完成（透過 `openclaw onboard` 或 `openclaw setup`）
- 終端機或命令列介面可用
- 網路連線（以存取金融資料 API）

## 完整步驟

### 步驟 1：安裝 stock-analysis 技能
在終端機中執行以下命令安裝 stock-analysis 技能：
```bash
openclaw skills install udiedrichsen/stock-analysis
```
此命令會從 ClawHub 下載並安裝技能到您的 OpenClaw 實例。

### 步驟 2：啟用技能
安裝完成後，啟用該技能：
```bash
openclaw skills enable udiedrichsen/stock-analysis
```
您可以透過 `openclaw skills list` 確認技能已被啟用。

### 步驟 3：設定技能參數（可選）
stock-analysis 技能預設使用 Yahoo Finance 資料，無需額外 API 金鑰。然而，如果您想要啟用 Twitter/X 整合（用於社群情感分析），需要設定相應的憑證：
```bash
# 設定 Twitter/X 憑證（如果適用）
openclaw config set skills.udiedrichsen.stock-analysis.twitter.bearerToken "YOUR_TWITTER_BEARER_TOKEN"
```
此外，您可以調整分析的深度或快速模式：
```bash
# 設定快速模式（跳過慢速分析以獲得更快結果）
openclaw config set skills.udiedrichsen.stock-analysis.fastMode true
```

### 步驟 4：分析單一股票
分析蘋果公司（AAPL）股票：
```bash
openclaw skills run udiedrichsen/stock-analysis analyze AAPL
```
命令會輸出 8 個維度的評分總結，包括盈餘驚喜、基本面、分析師情感等。

### 步驟 5：分析多個股票
同時分析多支股票以比較表現：
```bash
openclaw skills run udiedrichsen/stock-analysis analyze AAPL MSFT GOOGL
```
輸出將會顯示每支股票的評分，方便快速識別相對優勢。

### 步驟 6：執行快速分析
如果您只需要快速檢查（例如在交易時），可以使用快速模式：
```bash
openclaw skills run udiedrichsen/stock-analysis analyze AAPL --fast
```
這會跳過較慢的分析（如歷史模式和深度基本面），專注於關鍵指標。

### 步驟 7：分析加密貨幣
分析比特幣（BTC-USD）和以太坊（ETH-USD）：
```bash
openclaw skills run udiedrichsen/stock-analysis analyze BTC-USD ETH-USD
```
加密貨幣分析使用 3 個維度：市值與類別、BTC 相關性、動能。

### 步驟 8：建立監清單並設定警報
將股票加入監清單並設定目標價格與停損點：
```bash
openclaw skills run udiedrichsen/stock-analysis watchlist add AAPL --target 200 --stop 150
```
列出監清單：
```bash
openclaw skills run udiedrichsen/stock-analysis watchlist list
```
檢查監清單是否觸發警報（價格達到目標或停損）：
```bash
openclaw skills run udiedrichsen/stock-analysis watchlist check --notify
```
如果條件符合，技能會發送通知（依據您的通道設定，可能是 WhatsApp、Telegram 等）。

### 步驟 9：管理投資組合
建立一個名為「我的投資組合」的投資組合：
```bash
openclaw skills run udiedrichsen/stock-analysis portfolio create "我的投資組合"
```
添加持倉：
```bash
openclaw skills run udiedrichsen/stock-analysis portfolio add "我的投資組合" AAPL --quantity 100 --cost 150
```
查看投資組合詳情：
```bash
openclaw skills run udiedrichsen/stock-analysis portfolio show "我的投資組合"
```
輸出將顯示總市值、損益、持倉集中度警告等。

### 步驟 10：使用病毒趨勢掃描器（Hot Scanner）
執行完整掃描（包含所有資料源：CoinGecko、Google News、Yahoo Finance、Twitter/X）：
```bash
openclaw skills run udiedrichsen/stock-analysis hot_scanner
```
執行快速掃描（跳過社交媒體以加速）：
```bash
openclaw skills run udiedrichsen/stock-analysis hot_scanner --no-social
```
取得 JSON 格式輸出以供自動化使用：
```bash
openclaw skills run udiedrichsen/stock-analysis hot_scanner --json
```
掃描結果會顯示熱門股票和加密貨幣，並標示趨勢方向（看漲/看跌）。

### 步驟 11：股息分析
分析派息股票的股息表現（以強生公司 JNJ 為例）：
```bash
openclaw skills run udiedrichsen/stock-analysis dividends JNJ
```
輸出將顯示股息殖利率、派息比率、5 年增長率、連續增加年數和安全評分。

## 進階應用
- **自動每日趨勢報告**：結合 OpenClaw 的 cron 功能，設定每日早上執行熱門掃描並將結果發送到您的通訊頻道。
- **多代理協作**：使用多個 OpenClaw 代理，一個負責掃描熱門標的，另一個負責深度分析篩選出的候選股票。
- **整合交易執行**：雖然 stock-analysis 技能本身不執行交易，但您可以將其作為決策支援，結合其他技能（如自動腳本執行）來下達交易指令。
- **自定義警報條件**：修改技能的設定或使用 OpenClaw 的腳本功能，根據特定條件（如 RSI 超買）觸發更複雜的警報。

## 小結
在這個教學中，您學會了：
- 如何安裝和啟用 stock-analysis 技能
- 執行股票和加密貨幣的基本分析
- 設定監清單與投資組合
- 使用病毒趨勢掃描器發現熱門投資標的
- 進行股息分析和設定警報

透過這些步驟，您現在可以利用 OpenClaw 的強大 AI 能力來輔助您的投資決策，自動化金融資訊的收集與分析流程。隨著您對技能的熟悉，您可以進一步探索其進階功能，並將其整合到更廣泛的自動化工作流程中。

---
*此文件由 AI agent 自動生成，最後更新：2026-04-22*