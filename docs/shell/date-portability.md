# Date Command Portability

The `date` command has different syntax between GNU date (Linux) and BSD date (macOS). This causes failures when the same alias or script runs across both systems.

## The Problem

**macOS (BSD date):** Use `-v` for relative dates
```bash
date -v-30d +%Y%m%d    # 30 days ago
```

**GNU date (Linux/Nix):** Use `-d` for relative dates
```bash
date -d "30 days ago" +%Y%m%d
```

Running one syntax on the wrong system throws `invalid option` errors.

## Safe Pattern

Use conditional fallback to support both:

```bash
date -d "30 days ago" +%Y%m%d 2>/dev/null || date -v-30d +%Y%m%d
```

This attempts GNU syntax first, suppresses error output (`2>/dev/null`), and falls back to BSD syntax if it fails.

## Where Used

- `config/shell/aliases.sh` — `ccusage` alias

## Alternative: Fixed Dates

For scripts that don't need relative dates, hardcode dates in `YYYYMMDD` format to avoid the issue entirely:

```bash
npx ccusage@latest --since 20260203
```

## Related References

- Man pages: `man date` on your system to see which syntax is available
- When adding new aliases/scripts with date logic, apply the safe pattern above
