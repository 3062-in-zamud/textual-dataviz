---
name: textual-dataviz
description: |
  コンテキストに応じた最適な可視化を自動生成する。
  「可視化して」「グラフにして」「図にして」「visualize」等で自動発動。
  データ種別を判定し、ASCII/絵文字ベースの視覚表現を出力。
argument-hint: "\"type=bar\" or \"対象データの説明\""
allowed-tools:
  - Read
  - Bash
  - Write
  - Edit
  - Glob
  - Grep
---

$ARGUMENTS を textual-dataviz スキルに渡して実行してください。
スキル定義は skills/textual-dataviz/SKILL.md に従ってください。
