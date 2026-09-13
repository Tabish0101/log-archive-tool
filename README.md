# 📦 CLI Log Archiver

A lightweight Bash utility to compress system/application logs into timestamped `.tar.gz` archives and maintain an audit history.

## Features
- Compresses target log directories into timestamped archives (`logs_archive_YYYYMMDD_HHMMSS.tar.gz`).
- Automatically maintains an append-only archive log history.
- Built-in validation for missing arguments and non-existent directories.

## Quick Installation

Run this single command in your terminal to install `log-archive` globally:

```bash
curl -sSL https://raw.githubusercontent.com/Tabish0101/log-archive/main/install.sh | bash

```

### Roadmap challenge URL 

[https://roadmap.sh/projects/log-archive-tool](https://roadmap.sh/projects/log-archive-tool)