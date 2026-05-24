# 📦 Log Archive Tool

A CLI tool to compress and archive logs with timestamps, keeping your system clean.

## Features
- Accepts any log directory as an argument
- Compresses logs into a `.tar.gz` file with timestamp
- Stores archives in `~/log_archives/`
- Logs every archive operation to an activity log
- Color-coded terminal output

## Installation

```bash
git clone https://github.com/YOUR_USERNAME/log-archive-tool.git
cd log-archive-tool

# Install globally
sudo cp log-archive.sh /usr/local/bin/log-archive
sudo chmod +x /usr/local/bin/log-archive
```

## Usage

```bash
log-archive <log-directory>
```

### Examples

```bash
# Archive system logs
sudo log-archive /var/log

# Archive custom logs
log-archive /home/user/app/logs
```

## Output

Archives are saved to `~/log_archives/` with the naming format:
