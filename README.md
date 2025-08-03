# 🤖 Minimal Todoist-CLI

![bash](https://img.shields.io/badge/bash-%23121011.svg?style=for-the-badge&color=%23222222&logo=gnu-bash&logoColor=white) ![Todoist](https://img.shields.io/badge/todoist-badge?style=for-the-badge&logo=todoist&logoColor=%23ffffff&color=%23E44332) 

## List tasks with bash 🦾

A simple, dependency-free bash script to list your Todoist tasks sorted by creation date (oldest first) with colorized output and clickable task links.

## Features

- **Colorized output** - Easy to read with colored dates, tasks, and URLs
- **Chronological sorting** - Tasks sorted by creation date (oldest first)
- **Clickable task links** - Direct links to tasks in Todoist
- **Filtering options** - Skip recurring tasks and subtasks
- **Summary statistics** - Shows task count and date range
- **Zero dependencies** - Only requires `curl`, `python3`, and standard bash

## Installation

1. Clone or download the script:
2. 
```bash
git clone https://github.com/ronilaukkarinen/todoist-cli
cd todoist-cli
chmod +x todoist.sh
```

2. Create a symlink for easy access:
3. 
```bash
sudo ln -s /path/to/todoist-cli/todoist.sh /usr/local/bin/todoist
```

3. Get your Todoist API token from [https://todoist.com/prefs/integrations](https://todoist.com/prefs/integrations)

4. Set your token as an environment variable:
5. 
```bash
export TODOIST_TOKEN="your_token_here"
# Add to your ~/.bashrc or ~/.zshrc to make it permanent
```

## Usage

```bash
# Basic usage (uses TODOIST_TOKEN env var)
todoist

# Filter out recurring tasks
todoist --ignore-recurring

# Filter out subtasks
todoist --ignore-subtasks

# Use both filters
todoist --ignore-recurring --ignore-subtasks

# Show help
todoist --help
```

## Example Output

```
2024-01-15 | Buy groceries | https://todoist.com/showTask?id=123456
2024-01-16 | Review project proposal | https://todoist.com/showTask?id=123457
2024-01-17 | Schedule dentist appointment | https://todoist.com/showTask?id=123458
--- 3 tasks for 3 days timespan
```

## Requirements

- `bash` (any modern version)
- `curl` (for API requests)
- `python3` (for JSON parsing and date handling)
- Valid Todoist API token

## API token setup

1. Go to [Todoist Integrations](https://todoist.com/prefs/integrations)
2. Scroll down to "API token" section
3. Copy your token
4. Either:
   - Set `TODOIST_TOKEN` environment variable, or
   - Pass token as script argument

## License

MIT License - feel free to modify and distribute!
