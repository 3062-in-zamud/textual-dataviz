# 可視化パターン詳細テンプレート集

このファイルはSKILL.mdから必要時のみ読み込まれる詳細テンプレート集です。

---

## 1. 横棒グラフテンプレート（比率・割合）

### 基本形式

```
ラベル  ████████████░░░░░░░░  XX% (数値)
```

### パラメータ

| パラメータ | デフォルト | 説明 |
|-----------|-----------|------|
| `width` | 20 | バーの幅（文字数） |
| `label_width` | 10 | ラベルの幅（文字数、右詰め） |
| `show_value` | true | 数値を表示するか |
| `show_percentage` | true | 割合を表示するか |
| `sort` | desc | ソート順（desc/asc/none） |

### 生成アルゴリズム

```python
def generate_bar_chart(data, width=20, label_width=10):
    """
    data: [{"label": "食費", "value": 45000, "total": 100000}, ...]
    """
    output = []

    # ソート（降順）
    sorted_data = sorted(data, key=lambda x: x['value'], reverse=True)

    for item in sorted_data:
        label = item['label'].ljust(label_width)
        value = item['value']
        total = item['total']
        percentage = (value / total * 100) if total > 0 else 0

        # バー生成
        filled_width = int((value / total) * width)
        bar = '█' * filled_width + '░' * (width - filled_width)

        # フォーマット
        line = f"{label} {bar} {percentage:>5.1f}% (¥{value:,})"
        output.append(line)

    return "\n".join(output)
```

### 使用例

**入力データ**:
```json
[
  {"label": "食費", "value": 45000, "total": 100000},
  {"label": "住居", "value": 80000, "total": 100000},
  {"label": "交通", "value": 15000, "total": 100000}
]
```

**出力**:
```
カテゴリ別支出:

住居       ████████████████░░░░  80.0% (¥80,000)
食費       █████████░░░░░░░░░░░  45.0% (¥45,000)
交通       ███░░░░░░░░░░░░░░░░░  15.0% (¥15,000)
```

---

## 2. トレンドチャートテンプレート（時系列推移）

### 基本形式

```
Week N: ████████████░░░░░░░░ XX% (変化率)
```

### パラメータ

| パラメータ | デフォルト | 説明 |
|-----------|-----------|------|
| `width` | 20 | バーの幅 |
| `show_trend_arrow` | true | トレンド矢印を表示 |
| `show_change_rate` | true | 変化率を表示 |
| `period_type` | week | 期間タイプ（day/week/month） |

### トレンド矢印ルール

| 変化率 | 矢印 |
|-------|-----|
| +10%以上 | ↗️ |
| +5%〜+10% | → |
| -5%〜+5% | → |
| -10%〜-5% | ↘️ |
| -10%以下 | ↘️ |

### 生成アルゴリズム

```python
def generate_trend_chart(data, width=20):
    """
    data: [{"label": "Week 1", "value": 20, "max_value": 100}, ...]
    """
    output = []

    for i, item in enumerate(data):
        label = item['label']
        value = item['value']
        max_value = item['max_value']
        percentage = (value / max_value * 100) if max_value > 0 else 0

        # バー生成
        filled_width = int((value / max_value) * width)
        bar = '█' * filled_width + '░' * (width - filled_width)

        # 変化率計算（前期比）
        change_rate = ""
        trend_arrow = ""
        if i > 0:
            prev_value = data[i-1]['value']
            change = ((value - prev_value) / prev_value * 100) if prev_value > 0 else 0

            # トレンド矢印
            if change >= 10:
                trend_arrow = " ↗️"
            elif change <= -10:
                trend_arrow = " ↘️"
            else:
                trend_arrow = " →"

            change_rate = f" ({change:+.1f}%)"

        # フォーマット
        line = f"{label}: {bar} {percentage:.0f}%{change_rate}{trend_arrow}"
        output.append(line)

    # 総括
    first_value = data[0]['value']
    last_value = data[-1]['value']
    total_change = ((last_value - first_value) / first_value * 100) if first_value > 0 else 0

    if total_change >= 20:
        summary = f"\nトレンド: 改善傾向 📈 ({total_change:+.0f}% from {data[0]['label']})"
    elif total_change <= -20:
        summary = f"\nトレンド: 悪化傾向 📉 ({total_change:+.0f}% from {data[0]['label']})"
    else:
        summary = f"\nトレンド: 横ばい → ({total_change:+.0f}% from {data[0]['label']})"

    output.append(summary)

    return "\n".join(output)
```

### 使用例

```
Exercise - 週次推移（8週間）:

Week 1: ████░░░░░░░░░░░░░░░░ 20%
Week 2: ████████░░░░░░░░░░░░ 40% (+100.0%) ↗️
Week 3: ████████████░░░░░░░░ 60% (+50.0%) ↗️
Week 4: ████████████████░░░░ 80% (+33.3%) ↗️
Week 5: ████████████████░░░░ 80% (+0.0%) →
Week 6: ██████████████░░░░░░ 70% (-12.5%) ↘️
Week 7: ████████████████░░░░ 80% (+14.3%) ↗️
Week 8: ████████████████████ 100% (+25.0%) 🎉

トレンド: 改善傾向 📈 (+400% from Week 1)
```

---

## 3. ヒートマップテンプレート（完了/未完了）

### 基本形式

```
Week N: ✅✅✅✅✅⬜⬜
```

### 絵文字定義

| 状態 | 絵文字 | 説明 |
|-----|-------|------|
| 完了 | ✅ | タスク完了 |
| 未完了 | ⬜ | タスク未完了（記録あり） |
| 未記録 | ⚫ | 記録なし |
| 今日 | 🔵 | 今日の日付 |
| 未来 | ⚪ | 未来の日付 |

### 生成アルゴリズム

```python
def generate_heatmap(data, days=30):
    """
    data: [{"date": "2026-03-01", "completed": true, "tracked": true}, ...]
    """
    from datetime import datetime

    output = []
    today = datetime.now().date()

    # 日付順にソート
    sorted_data = sorted(data, key=lambda x: x['date'])[-days:]

    weeks = []
    current_week = []

    for entry in sorted_data:
        date = datetime.strptime(entry['date'], "%Y-%m-%d").date()

        # 絵文字選択
        if date > today:
            emoji = '⚪'
        elif date == today:
            emoji = '🔵'
        elif entry['completed']:
            emoji = '✅'
        elif entry['tracked']:
            emoji = '⬜'
        else:
            emoji = '⚫'

        current_week.append(emoji)

        # 7日ごとに週を区切る
        if len(current_week) == 7:
            weeks.append(''.join(current_week))
            current_week = []

    # 最後の週（7日未満）
    if current_week:
        weeks.append(''.join(current_week))

    # フォーマット
    output.append(f"直近{days}日間:\n")
    for i, week in enumerate(weeks, 1):
        output.append(f"Week {i}: {week}")

    # 凡例
    output.append("\n凡例: ✅ 完了 | ⬜ 未完了 | ⚫ 未記録")

    # 統計
    completed_count = sum(1 for e in sorted_data if e['completed'] and datetime.strptime(e['date'], "%Y-%m-%d").date() <= today)
    tracked_count = sum(1 for e in sorted_data if e['tracked'] and datetime.strptime(e['date'], "%Y-%m-%d").date() <= today)

    if tracked_count > 0:
        completion_rate = (completed_count / tracked_count) * 100
        output.append(f"完了率: {completed_count}/{tracked_count} ({completion_rate:.0f}%)")

    # ストリーク計算
    current_streak = 0
    for entry in reversed(sorted_data):
        if datetime.strptime(entry['date'], "%Y-%m-%d").date() > today:
            continue
        if entry['completed']:
            current_streak += 1
        else:
            break

    if current_streak > 0:
        output.append(f"現在のストリーク: {current_streak}日 🔥")

    return "\n".join(output)
```

### 使用例

```
Exercise - 直近30日間:

Week 1: ✅✅✅✅✅⬜⬜
Week 2: ✅✅✅⬜✅✅✅
Week 3: ✅✅✅✅✅✅⬜
Week 4: ✅✅✅✅🔵⚪⚪

凡例: ✅ 完了 | ⬜ 未完了 | ⚫ 未記録
完了率: 23/28 (82%)
現在のストリーク: 4日 🔥
```

---

## 4. ツリーテンプレート（構造・階層）

### 基本記号

| 記号 | 用途 |
|-----|------|
| `├──` | 中間の子要素 |
| `└──` | 最後の子要素 |
| `│` | 親の継続線 |
| `    ` | インデント（4スペース） |

### 生成アルゴリズム

```python
def generate_tree(root_path, max_depth=3, current_depth=0, prefix=""):
    """
    ディレクトリツリーを生成
    """
    import os

    if current_depth >= max_depth:
        return []

    output = []

    try:
        items = sorted(os.listdir(root_path))
    except PermissionError:
        return [f"{prefix}[Permission Denied]"]

    dirs = [i for i in items if os.path.isdir(os.path.join(root_path, i))]
    files = [i for i in items if os.path.isfile(os.path.join(root_path, i))]

    # ディレクトリを先に表示
    all_items = dirs + files

    for i, item in enumerate(all_items):
        is_last = (i == len(all_items) - 1)
        item_path = os.path.join(root_path, item)
        is_dir = os.path.isdir(item_path)

        # 記号選択
        if is_last:
            connector = "└── "
            extension = "    "
        else:
            connector = "├── "
            extension = "│   "

        # 表示名
        display_name = item + "/" if is_dir else item
        output.append(f"{prefix}{connector}{display_name}")

        # 再帰（ディレクトリのみ）
        if is_dir and current_depth + 1 < max_depth:
            sub_tree = generate_tree(
                item_path,
                max_depth,
                current_depth + 1,
                prefix + extension
            )
            output.extend(sub_tree)

    return output
```

### 使用例

```
プロジェクト構造:

project/
├── src/
│   ├── components/
│   │   ├── Header.tsx
│   │   ├── Footer.tsx
│   │   └── Button.tsx
│   ├── pages/
│   │   ├── index.tsx
│   │   └── about.tsx
│   └── utils/
│       └── helpers.ts
├── public/
│   ├── images/
│   └── favicon.ico
├── package.json
└── README.md
```

---

## 5. 比較テーブルテンプレート（前月比等）

### 基本形式

```
| 項目 | 今月 | 前月 | 前月比 |
|------|------|------|--------|
| 収入 | ¥XXX | ¥XXX | +X% 🟢 |
```

### 差分絵文字

| 変化 | 絵文字 | 基準 |
|-----|-------|------|
| 増加（良） | 🟢 | 収入、貯蓄率等 |
| 増加（悪） | 🔴 | 支出、負債等 |
| 減少（良） | 🟢 | 支出、負債等 |
| 減少（悪） | 🔴 | 収入、貯蓄率等 |
| 変化なし | ⚪ | ±0% |

### 生成アルゴリズム

```python
def generate_comparison_table(data, is_positive_increase=True):
    """
    data: [
        {"label": "収入", "current": 450000, "previous": 420000},
        ...
    ]
    is_positive_increase: 増加が良い指標か（収入=True、支出=False）
    """
    output = []

    # ヘッダー
    output.append("| 項目 | 今月 | 前月 | 前月比 |")
    output.append("|------|------|------|--------|")

    for item in data:
        label = item['label']
        current = item['current']
        previous = item['previous']

        # 変化率計算
        if previous > 0:
            change_rate = ((current - previous) / previous) * 100
        else:
            change_rate = 0

        # 絵文字選択
        if abs(change_rate) < 0.1:
            emoji = "⚪"
        elif change_rate > 0:
            emoji = "🟢" if is_positive_increase else "🔴"
        else:
            emoji = "🔴" if is_positive_increase else "🟢"

        # フォーマット
        current_str = f"¥{current:,}" if isinstance(current, int) else f"{current:.1f}%"
        previous_str = f"¥{previous:,}" if isinstance(previous, int) else f"{previous:.1f}%"
        change_str = f"{change_rate:+.1f}% {emoji}"

        output.append(f"| {label} | {current_str} | {previous_str} | {change_str} |")

    return "\n".join(output)
```

### 使用例

```
月次収支比較:

| 項目 | 今月 | 前月 | 前月比 |
|------|------|------|--------|
| 収入合計 | ¥450,000 | ¥420,000 | +7.1% 🟢 |
| 支出合計 | ¥280,000 | ¥295,000 | -5.1% 🟢 |
| 収支差額 | ¥170,000 | ¥125,000 | +36.0% 🟢 |
| 貯蓄率 | 37.8% | 29.8% | +8.0pt 🟢 |
```

---

## 6. 集計テンプレート（棒グラフ+表）

### 基本形式

```
Alice  ████████████████████ 120件 (40%)
```

### 生成アルゴリズム

```python
def generate_summary_chart(data, width=20, show_total=True):
    """
    data: [{"label": "Alice", "value": 120}, ...]
    """
    output = []

    # 合計値計算
    total = sum(item['value'] for item in data)

    # ソート（降順）
    sorted_data = sorted(data, key=lambda x: x['value'], reverse=True)

    for item in sorted_data:
        label = item['label'].ljust(10)
        value = item['value']
        percentage = (value / total * 100) if total > 0 else 0

        # バー生成
        filled_width = int((value / total) * width)
        bar = '█' * filled_width + '░' * (width - filled_width)

        # フォーマット
        line = f"{label} {bar} {value:>4}件 ({percentage:.0f}%)"
        output.append(line)

    # 合計行
    if show_total:
        separator = "─" * 40
        output.append(separator)
        output.append(f"{'合計':<10} {' ' * width} {total:>4}件 (100%)")

    return "\n".join(output)
```

### 使用例

```
コミット数（メンバー別）:

Alice      ████████████████████ 120件 (40%)
Bob        ██████████████░░░░░░  85件 (28%)
Carol      ██████████░░░░░░░░░░  60件 (20%)
Dave       ██████░░░░░░░░░░░░░░  35件 (12%)
────────────────────────────────────────
合計                            300件 (100%)
```

---

## 7. ステータステンプレート（段階的進捗）

### 段階色定義

| 範囲 | 色 | 意味 |
|-----|---|------|
| 0-25% | 🟥 | 未着手/遅延 |
| 26-50% | 🟧 | 開始/遅れあり |
| 51-75% | 🟨 | 進行中 |
| 76-100% | 🟩 | 完了間近/完了 |

### 生成アルゴリズム

```python
def generate_status_chart(data):
    """
    data: [{"label": "設計", "progress": 100}, ...]
    """
    output = []

    for item in data:
        label = item['label'].ljust(15)
        progress = item['progress']

        # 色選択
        if progress <= 25:
            color = '🟥'
        elif progress <= 50:
            color = '🟧'
        elif progress <= 75:
            color = '🟨'
        else:
            color = '🟩'

        # バー生成（4セグメント）
        filled_count = int(progress / 25)
        bar = color * filled_count + '░' * (4 - filled_count)

        # ステータステキスト
        if progress == 100:
            status = "(完了)"
        elif progress >= 75:
            status = "(ほぼ完了)"
        elif progress >= 50:
            status = "(進行中)"
        elif progress >= 25:
            status = "(開始)"
        else:
            status = "(未着手)"

        # フォーマット
        line = f"{label} {bar} {progress:>3}% {status}"
        output.append(line)

    # 凡例
    output.append("\n色凡例: 🟥 0-25% | 🟧 26-50% | 🟨 51-75% | 🟩 76-100%")

    return "\n".join(output)
```

### 使用例

```
プロジェクト進捗:

設計フェーズ       🟩🟩🟩🟩 100% (完了)
実装フェーズ       🟨🟨🟨░  75% (ほぼ完了)
テストフェーズ     🟧░░░  25% (開始)
デプロイ           🟥░░░   0% (未着手)

色凡例: 🟥 0-25% | 🟧 26-50% | 🟨 51-75% | 🟩 76-100%
```

---

## 8. フローテンプレート（矢印図）

### 基本記号

| 記号 | 用途 |
|-----|------|
| `→` | 順次フロー |
| `⇒` | 強調フロー |
| `↓` | 分岐・下方向 |
| `↑` | 合流・上方向 |
| `┌─` | 分岐開始 |
| `└─` | 分岐終了 |

### 生成パターン

**順次フロー**:
```
A → B → C → D
```

**分岐フロー**:
```
A → B ┌→ C → E
      └→ D → E
```

**条件分岐**:
```
開発 → テスト → ステージング → 本番
         ↓
      バグ修正 ⇒ 再テスト
```

### 使用例

```
デプロイフロー:

開発 → コミット → CI/CD
                   ↓
              テスト合格?
              /       \
            YES       NO
             ↓         ↓
        ステージング  修正
             ↓         ↓
          承認待ち → 再テスト
             ↓
          本番デプロイ
```

---

## カスタマイズガイド

### 幅の調整

全パターンで `width` パラメータで調整可能:

```python
# 幅10文字
generate_bar_chart(data, width=10)

# 幅30文字
generate_bar_chart(data, width=30)
```

### 色のカスタマイズ

絵文字を変更することで色・表現を変更可能:

```python
# デフォルト
completed = '✅'
not_completed = '⬜'

# カスタム
completed = '🟢'
not_completed = '⚪'
```

### ソート順の変更

```python
# 降順（デフォルト）
sorted_data = sorted(data, key=lambda x: x['value'], reverse=True)

# 昇順
sorted_data = sorted(data, key=lambda x: x['value'])

# ソートなし
sorted_data = data
```

---

**Version**: 1.0.0
**Created**: 2026-03-03
**Parent**: `skills/textual-dataviz/SKILL.md`
