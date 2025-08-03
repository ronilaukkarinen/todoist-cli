#!/bin/bash

# Simple Todoist CLI to list tasks by creation date
# Usage: todoist.sh [token]
# Set TODOIST_TOKEN environment variable or pass token as argument

# ========== SETTINGS ==========
IGNORE_RECURRING=true       # Filter out recurring tasks
IGNORE_SUBTASKS=true        # Filter out subtasks  
NEWEST_FIRST=true           # Sort newest first (true) or oldest first (false)
# ==============================

TOKEN="$1"

# Show help
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "Usage: $0 [token]"
    echo "  token               Todoist API token (or set TODOIST_TOKEN env var)"
    echo ""
    echo "Settings (edit script to change):"
    echo "  IGNORE_RECURRING=$IGNORE_RECURRING"
    echo "  IGNORE_SUBTASKS=$IGNORE_SUBTASKS"
    echo "  NEWEST_FIRST=$NEWEST_FIRST"
    echo ""
    echo "Get your token from: https://todoist.com/prefs/integrations"
    exit 0
fi

# Use environment variable if no token provided
TOKEN="${TOKEN:-$TODOIST_TOKEN}"

if [ -z "$TOKEN" ]; then
    echo "Error: Todoist API token required"
    echo "Usage: $0 [token]"
    echo "Or set TODOIST_TOKEN environment variable"
    echo "Get your token from: https://todoist.com/prefs/integrations"
    exit 1
fi

# Build filter parameter
FILTER=""
if [ "$IGNORE_RECURRING" = true ] && [ "$IGNORE_SUBTASKS" = true ]; then
    FILTER="?filter=!recurring%20%26%20!subtask"
elif [ "$IGNORE_RECURRING" = true ]; then
    FILTER="?filter=!recurring"
elif [ "$IGNORE_SUBTASKS" = true ]; then
    FILTER="?filter=!subtask"
fi

# Fetch tasks and sort by created_at
curl -s -H "Authorization: Bearer $TOKEN" \
     "https://api.todoist.com/rest/v2/tasks${FILTER}" | \
NEWEST_FIRST="$NEWEST_FIRST" python3 -c "
import json, sys, os
from datetime import datetime

# ANSI color codes
RED = '\033[91m'
GREEN = '\033[92m'
YELLOW = '\033[93m'
BLUE = '\033[94m'
MAGENTA = '\033[95m'
CYAN = '\033[96m'
WHITE = '\033[97m'
RESET = '\033[0m'
BOLD = '\033[1m'

try:
    data = json.load(sys.stdin)
    
    # Sort by created_at - filtering is done via API now
    newest_first = os.environ.get('NEWEST_FIRST', 'false').lower() == 'true'
    sorted_tasks = sorted(data, key=lambda x: x['created_at'], reverse=newest_first)
    
    if not sorted_tasks:
        print(f'{YELLOW}No tasks found{RESET}')
        sys.exit(0)
    
    # Get date range
    oldest_date = datetime.fromisoformat(sorted_tasks[0]['created_at'].replace('Z', '+00:00'))
    newest_date = datetime.fromisoformat(sorted_tasks[-1]['created_at'].replace('Z', '+00:00'))
    days_span = (newest_date - oldest_date).days + 1
    
    for task in sorted_tasks:
        created = task['created_at'][:10]  # Just the date part
        content = task['content']
        task_id = task['id']
        url = f'https://app.todoist.com/app/task/{task_id}'
        
        # Color the output
        print(f'{CYAN}{created}{RESET} | {WHITE}{content}{RESET} | {BLUE}{url}{RESET}')
    
    # Footer
    task_count = len(sorted_tasks)
    print(f'{BOLD}{MAGENTA}--- {task_count} tasks for {days_span} days timespan{RESET}')
        
except Exception as e:
    print(f'Error parsing JSON: {e}', file=sys.stderr)
    sys.exit(1)
"