# Message 與 Channels CLI 參考資料

> 最後更新：2026-04-26

## 來源清單

### 來源 1：官方 Message CLI 文件
- **URL**：https://docs.openclaw.ai/cli/message
- **類型**：官方文件
- **擷取日期**：2026-04-26
- **可信度**：高（官方第一方文件）
- **主要內容摘要**：
  - Message CLI 是統一的 outbound 命令，支援多個通道的訊息發送與操作
  - 支援通道：Discord/Google Chat/iMessage/Matrix/Mattermost/Microsoft Teams/Signal/Slack/Telegram/WhatsApp
  - 目標格式支援各通道的特殊格式（如 WhatsApp 的 E.164、Discord 的 channel:id）
  - SecretRef 解析行為：支援通道與帳戶範圍的 SecretRef 解析
  - Action 詳細說明：send、poll、react 等核心功能與通道特定選項
- **用於文件的哪個部分**：
  - Message CLI 基本概念與架構
  - 支援的通道清單與目標格式
  - SecretRef 解析行為說明
  - 各種 Action 的詳細參數與限制

### 來源 2：官方 Channels CLI 文件
- **URL**：https://docs.openclaw.ai/cli/channels
- **類型**：官方文件
- **擷取日期**：2026-04-26
- **可信度**：高（官方第一方文件）
- **主要內容摘要**：
  - Channels CLI 用於管理聊天通道帳戶與 Gateway 上的運行時狀態
  - 核心功能：list、status、capabilities、resolve、logs、add、remove
  - Status 探針行為：--probe 會執行 per-account 檢查，包含 transport state 與 probe 結果
  - 帳戶管理：支援非互動式新增與刪除，各通道有特定的認證參數
  - 路由行為：現有的通道綁定與帳戶範圍路由規則的一致性維護
- **用於文件的哪個部分**：
  - Channels CLI 基本概念與架構
  - 核心命令功能說明
  - 帳戶管理路由行為
  - Status 探針與能力檢查機制

### 來源 3：原始碼 - Message CLI 入口
- **URL**：/Users/daniel.chang/Desktop/openclaw/src/cli/program/register.message.ts
- **類型**：原始碼
- **擷取日期**：2026-04-26
- **可信度**：高（第一手原始碼）
- **主要內容摘要**：
  - Message CLI 註冊了多個子命令：send、broadcast、poll、reactions、read-edit-delete、pins、permissions、search、thread、emoji-sticker、discord-admin
  - 使用 helpers 模式進行參數驗證與執行
  - 支援的 Action 名稱來自 CHANNEL_MESSAGE_ACTION_NAMES 常數
  - 整合了進度顯示、JSON 輸出、Dry-run 等功能
- **用於文件的哪個部分**：
  - Message CLI 命令架構與子命令組織
  - 參數驗證與執行流程
  - 與官方文件的對驗

### 來源 4：原始碼 - Message Send 命令
- **URL**：/Users/daniel.chang/Desktop/openclaw/src/cli/program/message/register.send.ts
- **類型**：原始碼
- **擷取日期**：2026-04-26
- **可信度**：高（第一手原始碼）
- **主要內容摘要**：
  - Send 命令的完整參數定義
  - 必填參數：--target，以及 --message、--media、--presentation 三選一
  - 通道特定選項：--gif-playback (WhatsApp)、--force-document (Telegram)、--silent (Telegram+Discord)
  - Presentation 與 Delivery 支援：傳送語義區塊與傳遞偏好設定
  - Reply-to、thread-id、pin 等互動功能支援
- **用於文件的哪個部分**：
  - Send 命令完整參矩陣
  - 通道特定功能說明
  - Presentation 與 Delivery 系統詳細解說

### 來源 5：原始碼 - Message 命令核心
- **URL**：/Users/daniel.chang/Desktop/openclaw/src/commands/message.ts
- **類型**：原始碼
- **擷取日期**：2026-04-26
- **可信度**：高（第一手原始碼）
- **主要內容摘要**：
  - Message 命令的核心執行流程
  - Secret 範圍解析：resolveMessageSecretScope 函式處理 channel/target/accountId 範圍
  - 配置解析：使用 resolveCommandConfigWithSecrets 處理 SecretRef
  - Action 驗證：CHANNEL_MESSAGE_ACTION_NAMES 常數驗證輸入 action
  - Gateway 整合：使用 GATEWAY_CLIENT_NAMES.CLI 和 GATEWAY_CLIENT_MODES.CLI
  - JSON 輸出格式：包含 action、channel、dryRun、handledBy、payload
- **用於文件的哪個部分**：
  - Message 命令核心執行流程
  - Secret 範圍解析機制
  - Action 驗證與 Gateway 整合
  - JSON 輸出格式詳細說明

### 來源 6：原始碼 - Channels CLI 入口
- **URL**：/Users/daniel.chang/Desktop/openclaw/src/cli/channels-cli.ts
- **類型**：原始碼
- **擷取日期**：2026-04-26
- **可信度**：高（第一手原始碼）
- **主要內容摘要**：
  - Channels CLI 的註冊與命令組織結構
  - 使用動態通道選項：listBundledPackageChannelMetadata()
  - 命令分組：list、status、capabilities、resolve、logs、add、remove、login、logout
  - 帳戶管理：runChannelLogin/runChannelLogout 處理認證流程
  - 動態選項注入：addChannelSetupOptions 函式為各通道注入特定選項
- **用於文件的哪個部分**：
  - Channels CLI 命令架構與動態選項系統
  - 帳戶管理與認證流程
  - 與官方文件的對驗

### 來源 7：原始碼 - Skills CLI
- **URL**：/Users/daniel.chang/Desktop/openclaw/src/cli/skills-cli.ts
- **類型**：原始碼
- **擷取日期**：2026-04-26
- **可信度**：高（第一手原始碼）
- **主要內容摘要**：
  - Skills CLI 命令結構：search、install、update、check、list
  - ClawHub 整合：支援從 ClawHub 搜尋、安裝、更新技能
  - 工作空間技能狀態：使用 buildWorkspaceSkillStatus 建立技能狀態報告
  - 版本管理：支援指定版本安裝與強制覆蓋
  - JSON 輸出支援：部分命令支援 JSON 格式輸出
- **用於文件的哪個部分**：
  - Skills CLI 命令架構與功能
  - ClawHub 整合機制
  - 技能狀態管理系統

## 參考資料使用說明

本參考資料用於深化 `03-cli-reference.md` 中 Message、Channels、Skills 等 CLI 命令的說明，提供原始碼層級的詳細資訊與官方文件的對驗結果。

所有參考資料已按可信度排序，官方文件與原始碼資訊作為主要依據，社群資源作為補充參考。