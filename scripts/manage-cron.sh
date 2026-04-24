#!/usr/bin/env bash
# =============================================================================
# OpenClaw 學習資料自動化 - Cron 任務管理腳本
# =============================================================================
# 使用方式：
#   ./manage-cron.sh add     -- 新增 cron 任務
#   ./manage-cron.sh list    -- 列出所有任務
#   ./manage-cron.sh run     -- 立即手動觸發一次
#   ./manage-cron.sh status  -- 查看任務狀態
#   ./manage-cron.sh pause   -- 暫停任務
#   ./manage-cron.sh resume  -- 恢復任務
#   ./manage-cron.sh remove  -- 刪除任務
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_FILE="$SCRIPT_DIR/openclaw-learning-prompt.md"
JOB_NAME="openclaw-learning-autodoc"
CRON_EXPR="0 */4 * * *"
TIMEZONE="Asia/Taipei"

# 取得 job ID（如果已存在）
get_job_id() {
  openclaw cron list --json 2>/dev/null \
    | grep -A2 "\"name\": \"$JOB_NAME\"" \
    | grep '"id"' \
    | awk -F'"' '{print $4}' \
    | head -1
}

case "${1:-help}" in
  add)
    echo "🦞 新增 OpenClaw 學習資料 cron 任務..."
    echo "   排程：每 4 小時（$CRON_EXPR）"
    echo "   時區：$TIMEZONE"
    echo ""

    if [ ! -f "$PROMPT_FILE" ]; then
      echo "❌ 找不到提示詞檔案：$PROMPT_FILE"
      exit 1
    fi

    PROMPT_CONTENT=$(cat "$PROMPT_FILE")

    openclaw cron add \
      --name "$JOB_NAME" \
      --cron "$CRON_EXPR" \
      --tz "$TIMEZONE" \
      --session isolated \
      --message "$PROMPT_CONTENT" \
      --announce \
      --stagger 60s

    echo ""
    echo "✅ Cron 任務已建立！"
    echo "   執行 './manage-cron.sh list' 查看任務 ID"
    ;;

  list)
    echo "📋 目前所有 cron 任務："
    openclaw cron list
    ;;

  run)
    JOB_ID=$(get_job_id)
    if [ -z "$JOB_ID" ]; then
      echo "❌ 找不到任務 '$JOB_NAME'，請先執行 add"
      exit 1
    fi
    echo "🚀 立即觸發任務（Job ID: $JOB_ID）..."
    openclaw cron run "$JOB_ID"
    echo "✅ 已排入執行佇列，使用 'status' 查看進度"
    ;;

  status)
    JOB_ID=$(get_job_id)
    if [ -z "$JOB_ID" ]; then
      echo "❌ 找不到任務 '$JOB_NAME'"
      exit 1
    fi
    echo "📊 任務狀態（Job ID: $JOB_ID）："
    openclaw cron show "$JOB_ID"
    echo ""
    echo "📜 最近執行記錄："
    openclaw cron runs --id "$JOB_ID"
    ;;

  pause)
    JOB_ID=$(get_job_id)
    if [ -z "$JOB_ID" ]; then
      echo "❌ 找不到任務 '$JOB_NAME'"
      exit 1
    fi
    echo "⏸️  暫停任務（Job ID: $JOB_ID）..."
    openclaw cron edit "$JOB_ID" --pause
    echo "✅ 任務已暫停"
    ;;

  resume)
    JOB_ID=$(get_job_id)
    if [ -z "$JOB_ID" ]; then
      echo "❌ 找不到任務 '$JOB_NAME'"
      exit 1
    fi
    echo "▶️  恢復任務（Job ID: $JOB_ID）..."
    openclaw cron edit "$JOB_ID" --resume
    echo "✅ 任務已恢復"
    ;;

  remove)
    JOB_ID=$(get_job_id)
    if [ -z "$JOB_ID" ]; then
      echo "❌ 找不到任務 '$JOB_NAME'"
      exit 1
    fi
    echo "⚠️  確認刪除任務 '$JOB_NAME'（Job ID: $JOB_ID）？[y/N]"
    read -r confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      openclaw cron delete "$JOB_ID"
      echo "✅ 任務已刪除"
    else
      echo "取消操作"
    fi
    ;;

  logs)
    echo "📄 最新執行日誌："
    LOG_DIR="/Users/daniel.chang/Desktop/openclaw-learning/logs"
    LATEST_LOG=$(ls -t "$LOG_DIR"/autodoc-*.log 2>/dev/null | head -1)
    if [ -n "$LATEST_LOG" ]; then
      echo "檔案：$LATEST_LOG"
      echo "---"
      cat "$LATEST_LOG"
    else
      echo "尚無執行日誌（任務尚未執行）"
    fi
    ;;

  help|*)
    echo "🦞 OpenClaw 學習資料 Cron 管理腳本"
    echo ""
    echo "使用方式："
    echo "  ./manage-cron.sh add     新增 cron 任務（每 4 小時）"
    echo "  ./manage-cron.sh list    列出所有任務"
    echo "  ./manage-cron.sh run     立即手動觸發一次"
    echo "  ./manage-cron.sh status  查看任務狀態與執行歷史"
    echo "  ./manage-cron.sh pause   暫停任務"
    echo "  ./manage-cron.sh resume  恢復任務"
    echo "  ./manage-cron.sh remove  刪除任務"
    echo "  ./manage-cron.sh logs    查看最新執行日誌"
    ;;
esac
