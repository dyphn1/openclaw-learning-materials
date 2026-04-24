# 股票分析自動化 (Stock Analysis Automation)

> 最後更新：2026-04-23

## 什麼是股票分析自動化？
股票分析自動化是利用 OpenClaw 的 AI 能力與市場數據技能，自動化執行股票篩選、基本面與技術面分析、新聞情緒評估及模擬交易決策的一套工作流程。它結合多專家 AI 代理人（如價值分析師、技術分析師、情緒分析師、風險管理師）進行協作分析，最終生成綜合投資建議，可透過 Web UI、Telegram 或 CLI 指令觸發，大幅降低手動分析股票的時間與複雜度。

## 安裝 / 環境需求
- OpenClaw 已安裝並完成基本 onboarding（參考 02-environment-setup）
- Node.js 18+（若需運行 StockClaw 範例專案）
- 可選：Telegram Bot Token（用於訊息互動）
- 可選：OpenAI 相容的 LLM API 金鑰（如 Claude、Gemini、DeepSeek 等）以啟用深度分析
- 網路連線以取得即時市場資料（Yahoo Finance、CoinGecko 等）

```bash
# 確保 OpenClaw 已啟動
openclaw

# 安裝股票分析相關技能（範例：crypto-stock-market-data）
install skill crypto-stock-market-data
```

## 核心概念
股票分析自動化主要透過以下元件運作：
1. **市場數據技能**：負責取得即時股價、歷史 K 線、公司基本面、加密貨幣資料等。
2. **多代理人協作架構**：
   - 價值分析師：分析財務報表、估值水平。
   - 技術分析師：研究價格趨勢、技術指標、圖表型態。
   - 情緒分析師：掃描新聞、社群媒體、機構持倉。
   - 風險管理師：評估潛在風險、下跌空間、倉位建議。
   - 根代理人：綜合所有專家意見，輸出最終投資建議。
3. **工作流程觸發**：使用者透過指令（如 `/analyze AAPL`）或 Web UI 輸入自然語言請求，OpenClaw 會啟動對應的代理人協作流程。
4. **模擬交易與回測**：支援紙上交易（Paper Trading）與歷史回測，驗證策略在過去市場中的表現。

## CLI 指令說明
雖然股票分析主要透過自然語言觸發，但 OpenClaw 提供以下相關 CLI 指令協助設定與除錯：

```bash
# 查看已安裝的市場數據技能
skill list

# 啟用/停用特定技能
skill enable crypto-stock-market-data
skill disable crypto-stock-market-data

# 查看技能詳細資訊
skill info crypto-stock-market-data

# 設定 LLM 模型（若需自行調整）
config set llm.model claude-sonnet-4-20250514
config set llm.baseUrl https://api.anthropic.com/v1
```

## 實際應用範例

### 場景一：深度分析單一股票
透過自然語言指令請求 OpenClaw 對特定股票進行全方位分析。

**步驟：**
1. 確認 OpenClaw 已啟動並連接到市場數據技能。
2. 在互動介面（Web UI、Telegram 或 CLI）輸入：
   ```
   分析台積電（TSM）的投資價值，包括基本面、技術面與新聞情緒。
   ```
3. OpenClaw 會依序呼叫：
   - 市場數據技能取得 TSM 的即時價格、歷史資料、財務報表。
   - 價值分析師評估其每股盈餘 (EPS)、市盈率 (P/E)、股息率等基本面指標。
   - 技術分析師計算移動平均線、相對強弱指數 (RSI)、MACD 等技術指標。
   - 情緒分析師掃描最近新聞與社群討論，判斷市場情緒是正面、中性還是負面。
   - 風險管理師根據波動率、歷史回測結果提供風險等級與建議倉位。
4. 根代理人彙總所有分析，輸出類似以下的報告：
   ```
   【TSM 深度分析報告】
   價值面：⭐⭐⭐⭐☆（基本面穩健，估值略高）
   技術面：⭐⭐⭐⭐（處於上升趨勢，RSI 60）
   情緒面：⭐⭐⭐⭐（近期新聞偏正面）
   風險評估：中等風險，建議分批進場
   最終建議：持有或小幅增持
   ```

### 場景二：自動化選股與模擬交易
利用 OpenClaw 的選股功能自動篩選符合條件的股票，並執行模擬買賣。

**步驟：**
1. 設定選股條件（例如：市值 > 100 億美元，ROE > 15%，RSI < 30）。
2. 輸入指令：
   ```
   選出符合低估值且超賣的美國股票，並顯示前 5 名。
   ```
3. OpenClaw 會：
   - 呼叫市場數據技能批量取得符合市值門檻的股票清單。
   - 計算每隻股票的 ROE、RSI 等指標。
   - 篩選出符合所有條件的股票，並按評分排序。
   - 回傳結果表格，包含股票代號、現價、目標價、分析摘要。
4. 使用者可進一步對選出的股票執行模擬交易：
   ```
   買入 10 超 AAPL（以市場價格）
   ```
   OpenClaw 會檢查帳戶現金、計算交易成本、更新模擬投資組合。

## 應用主題分類

| 主題 | 適用場景 | 複雜度 |
|------|---------|-------|
| 股票分析自動化 | 個人投資決策、投資研究、模擬交易練習 | ⭐⭐⭐ |
| 自動寫 code | 程式碼生成、重構、除錯輔助 | ⭐⭐ |
| 文件分析 | 法務文件審查、財報解讀、研究論文摘要 | ⭐⭐⭐ |
| 自動化學習 | 個性化課程推薦、知識圖譜建設、語言學習 | ⭐⭐ |
| 資料收集與整理 | 網路爬蟲、競爭情報監視、學術文獻蒐集 | ⭐⭐⭐ |

## 常見問題與排錯

| 問題 | 原因 | 解法 |
|------|------|------|
| 無法取得即時股價 | 市場數據技能未啟用或網路連線問題 | 執行 `skill enable crypto-stock-market-data`，檢查網路連線 |
| 分析結果卡住或無回應 | LLM API 金鑰無效或額度用盡 | 檢查 `config/llm.local.toml` 中的 API Key，或切換至免費額度較高的模型 |
| Telegram 機器人無回應 | Bot Token 錯誤或未完成綁定 | 重新取得 Bot Token，透過 `/start` 完成綁定流程 |
| 分析報告內容過於簡短 | 上下文被壓縮或模型 token 限制 | 增加 `compactionThreshold` 設定或使用更大 context window 的模型 |
| 模擬交易未更新持倉 | 投資組合檔案權限問題或 JSON 格式錯誤 | 檢查 `data/portfolio.json` 權限與語法，確保為有效 JSON |

## 參考資源
- [官方文件](https://docs.openclaw.ai) — 最新官方說明
- [GitHub](https://github.com/openclaw/openclaw) — 原始碼與 Issues
- [Discord](https://discord.gg/clawd) — 社群討論
- [StockClaw: Using OpenClaw to Quickly Build Your AI Stock Manager](https://openclawapi.org/en/blog/2026-03-14-stockclaw-ai-stock-assistant) — 實戰範例與步驟說明
- [Web Scraping 101: Using OpenClaw Browsing Tools for Data Collection](https://stormap.ai/post/web-scraping-101-using-openclaw-browsing-tools-for-data-collection) — 數據收集技術補充

---
*此文件由 AI agent 自動生成，最後更新：2026-04-23*