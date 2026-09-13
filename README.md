# 📦 CLI Log Archiver

A lightweight Bash utility to compress system/application logs into timestamped `.tar.gz` archives and maintain an audit history.

## Features
- Compresses target log directories into timestamped archives (`logs_archive_YYYYMMDD_HHMMSS.tar.gz`).
- Automatically maintains an append-only archive log history.
- Built-in validation for missing arguments and non-existent directories.

## Quick Installation

Run this single command in your terminal to install `log-archive` globally:

```bash
curl -sSL https://raw.githubusercontent.com/Tabish0101/log-archive-tool/main/install.sh | bash
```

This installs to `/usr/local/bin`, prompting for `sudo` only if that directory
isn't writable. To install somewhere else — no elevation needed:

```bash
curl -sSL https://raw.githubusercontent.com/Tabish0101/log-archive-tool/main/install.sh | INSTALL_DIR="$HOME/.local/bin" bash
```

Or install from a clone, which uses the local `bin/log-archive` instead of downloading:

```bash
git clone https://github.com/Tabish0101/log-archive-tool.git
cd log-archive-tool
./install.sh
```

## Usage

After installation, `log-archive` is available from any directory:

```bash
log-archive <log-directory>
```

Examples:

```bash
# Archive a relative directory
log-archive ./sample-logs

# Archive an absolute system path (may need sudo to read /var/log)
sudo log-archive /var/log
```

Output:

```text
Compressing logs from './sample-logs'...
Success! Archive saved to: archived_logs/logs_archive_20250913_154448.tar.gz
Logged archive history in: archived_logs/archive_history.log
```

Notes:
- Archives are written to an `archived_logs/` folder created in your **current working directory**, not next to the target log directory. `cd` to where you want the archives kept before running the command.
- Every run appends one line to `archived_logs/archive_history.log`.
- The command exits with status `1` and a message if the argument is missing or the directory does not exist.

## Create a Sample Log File and Test

You can verify the tool without touching real system logs.

**1. Create a throwaway directory with a few sample log files:**

```bash
mkdir -p ~/log-archive-demo/sample-logs
cd ~/log-archive-demo

for file in syslog auth.log app.log; do
  for i in 1 2 3; do
    echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] $file entry $i"
  done > "sample-logs/$file"
done
```

**2. Run the command against it:**

```bash
log-archive sample-logs
```

**3. Confirm the archive and history were created:**

```bash
ls -l archived_logs
cat archived_logs/archive_history.log
```

Expected history entry:

```text
[2025-09-13 15:44:48] Archived sample-logs -> logs_archive_20250913_154448.tar.gz
```

**4. Inspect the archive contents without extracting:**

```bash
tar -tzf archived_logs/logs_archive_*.tar.gz
```

```text
sample-logs/
sample-logs/app.log
sample-logs/auth.log
sample-logs/syslog
```

**5. Check the validation paths:**

```bash
log-archive                 # Error: Missing log directory.
log-archive /does-not-exist # Error: Directory '/does-not-exist' does not exist.
```

**6. Clean up:**

```bash
cd ~ && rm -rf ~/log-archive-demo
```

### Roadmap challenge URL 

[https://roadmap.sh/projects/log-archive-tool](https://roadmap.sh/projects/log-archive-tool)