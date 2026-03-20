# textual-dataviz

ASCII/Unicode text-based data visualization skill for [Claude Code](https://claude.com/claude-code).

Automatically detects data types in conversation context and generates terminal-friendly visualizations using block characters and emoji.

## Chart Types

| Type | Use Case | Output Example |
|------|----------|----------------|
| Bar Chart | Ratios, percentages | `Food █████░░░ 65%` |
| Trend Chart | Time series | `Week 1: ████░░ 40% ↗️` |
| Heatmap | Completion tracking | `✅✅⬜✅✅⬜✅` |
| Tree | Directory, hierarchy | `├── src/` |
| Comparison Table | Month-over-month | Markdown table + diff emoji |
| Summary Chart | Distribution, ranking | `████ 45 items` |
| Status | Progress stages | `🟥🟧🟨🟩 (0-100%)` |
| Flow Diagram | Workflow, dependencies | `A → B → C` |

## Installation

### Via Claude Code Plugin (Recommended)

```bash
claude plugin install textual-dataviz
```

### Manual

```bash
git clone https://github.com/3062-in-zamud/textual-dataviz.git
cd textual-dataviz
bash install.sh
```

## Usage

### Trigger Words

The skill activates automatically when you say:
- Japanese: "可視化して", "グラフにして", "図にして", "チャートで見せて"
- English: "visualize", "show as chart", "draw diagram"

### Slash Command

```
/textual-dataviz type=bar
/textual-dataviz "show directory structure"
```

### Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `type` | auto-detect | Chart type (bar/trend/heatmap/tree/table/status/flow) |
| `output` | terminal | Output target (terminal/file/daily-note) |
| `width` | 20 | Chart width in characters |
| `target` | context | Explicit data source |

## Examples

### Bar Chart
```
Category Spending (2026-01):

Food       ████████████░░░░░░░░  65% (¥45,000)
Housing    ██████████████████░░  90% (¥80,000)
Transport  ████░░░░░░░░░░░░░░░░  20% (¥15,000)
```

### Trend Chart
```
Exercise - Weekly Trend (8 weeks):

Week 1: ████░░░░░░░░░░░░░░░░ 20%
Week 2: ████████░░░░░░░░░░░░ 40% ↗️
Week 3: ████████████░░░░░░░░ 60% ↗️
Week 4: ████████████████████ 100% 🎉

Trend: Improving 📈 (+400% from Week 1)
```

### Status Chart
```
Project Progress:

Design     🟩🟩🟩🟩 100% (Complete)
Backend    🟨🟨🟨░  75% (In Progress)
Testing    🟧░░░  25% (Started)
Deploy     🟥░░░   0% (Not Started)
```

## License

MIT License - see [LICENSE](LICENSE)
