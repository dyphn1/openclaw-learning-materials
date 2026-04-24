# 股票分析自動化 - 參考資源摘要

## StockClaw: Using OpenClaw to Quickly Build Your AI Stock Manager
- 來源：https://openclawapi.org/en/blog/2026-03-14-stockclaw-ai-stock-assistant
- 內容：詳細教學如何使用 OpenClaw 建立多代理人股票分析系統，包括：
  - 項目結構：config、skills、prompts、data、src 目錄說明
  - 安裝步驟：克隆專案、安裝依賴、設定 LLM、啟動服務
  - Telegram 整合：建立 Bot、綁定流程
  - 市場數據技能：使用 crypto-stock-market-data 取得價格、歷史資料、公司資訊
  - 投資組合管理：建立 portfolio.json 設定初始現金與持倉
  - 深度股票分析：透過 Web UI 或 Telegram 呼叫價值、技術、情緒、風險分析師
  - 模擬交易：買入/賣出操作、投資組合更新
  - 歷史回測：設定回測期間、避免看ahead bias、計算報酬率與風險指標
  - 常見問題：LLM 連線失敗、Telegram 啟動失敗、市場數據取得失敗、投資組合異常、回測結果不準、內容過長 truncation

## Web Scraping 101: Using OpenClaw Browsing Tools for Data Collection
- 來源：https://stormap.ai/post/web-scraping-101-using-openclaw-browsing-tools-for-data-collection
- 內容：雖聚焦於網路爬蟲，但提供 OpenClaw Browsing Skill 的使用範例與概念，適用於股票分析中的數據收集：
  - 安裝 Browsing Skill：`install skill browsing`
  - 基本腳本範例：導航至網頁、查找元素、提取表格資料
  - 實際案例：從模擬電子商務網站抓取產品標題與價格
  - 最佳實踐：尊重網站政策、避免過度請求、優雅處理錯誤、過濾無關內容、保護隱私
  - 進階技巧：處理無限捲動頁面、驗證碼偵測、使用代理伺服器
  - 與其他工具比較：OpenClaw 在易用性、JavaScript 支援、自動化範圍上優於 Beautiful Soup，介於 Selenium 之間
  - AI 整合範例：將刮取的資料送入 OpenClaw AI 進行摘要或分類

## OpenClaw AI Trading Skills: The Complete 2026 Guide
- 來源：https://aurpay.net/aurspace/openclaw-ai-trading-skills-complete-guide-2026/
- 內容：概覽 OpenClaw 在股票交易中的應用：
  - 各種投資技能的逐步設置、驗證收益數據、風險評估
  - 套利策略在 2026 年的實際應用
  - 強調風險管理與合規性的重要性

---
*摘要自動生成於 2026-04-23，來源為公開網頁資料，僅供學習參考。*