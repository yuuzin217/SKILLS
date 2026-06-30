---
name: design-md
description: Follow, validate, and convert the DESIGN.md format specification for visual identity and design tokens, using the @google/design.md CLI.
---

# DESIGN.md

> [!NOTE]
> This skill is based on the [design.md](https://github.com/google/design.md) project by Google, licensed under the Apache License 2.0.
> A copy of the license is available in the [LICENSE](file:///C:/Users/yuuzi/work/gemini-skill.md/design-md/LICENSE) file.

DESIGN.md is a self-contained, plain-text representation of a design system. It combines machine-readable design tokens (YAML front matter) with human-readable design rationale (markdown prose) to give coding agents a persistent, structured understanding of a design system.

For the full detailed format specification, see [spec.md](references/spec.md).

## CLI Reference

The `@google/design.md` package provides a CLI for linting, diffing, and exporting `DESIGN.md` files.

### Installation & Run

You can run the CLI directly using `npx`:

```bash
npx @google/design.md lint DESIGN.md
```

#### Windows / PowerShell Command Resolution Tip
On Windows/PowerShell (including modern `pwsh`), the `.md` suffix in the bin name can collide with markdown file associations. Use the dot-free `designmd` alias by pointing `npx` at the package explicitly with `-p`:

```powershell
npx -p @google/design.md designmd lint DESIGN.md
```

### CLI Commands

- **`lint`**: Validate a `DESIGN.md` file for structural correctness and WCAG contrast ratio compliance.
  ```powershell
  npx -p @google/design.md designmd lint DESIGN.md
  ```
- **`diff`**: Compare two `DESIGN.md` files and report token-level changes.
  ```powershell
  npx -p @google/design.md designmd diff DESIGN.md DESIGN-v2.md
  ```
- **`export`**: Export design tokens to other formats (e.g. Tailwind v3 JSON theme, Tailwind v4 CSS theme, or W3C Design Tokens format).
  ```powershell
  # Tailwind v3 theme JSON (extends theme)
  npx -p @google/design.md designmd export --format json-tailwind DESIGN.md > tailwind.theme.json

  # Tailwind v4 theme CSS
  npx -p @google/design.md designmd export --format css-tailwind DESIGN.md > theme.css

  # W3C DTCG tokens JSON
  npx -p @google/design.md designmd export --format dtcg DESIGN.md > tokens.json
  ```
- **`spec`**: Output the full specification.
  ```powershell
  npx -p @google/design.md designmd spec --rules
  ```

## Format Summary

### File Structure
1. **YAML front matter** — delimited by `---` at the top of the file, containing token schemas (colors, typography, rounded, spacing, components).
2. **Markdown body** — `##` sections in canonical order (Overview, Colors, Typography, Layout, Elevation & Depth, Shapes, Components, Do's and Don'ts).

### Syntax Example
```markdown
---
name: Heritage
colors:
  primary: "#1A1C1E"
  secondary: "#6C7278"
  tertiary: "#B8422E"
  neutral: "#F7F5F2"
typography:
  h1:
    fontFamily: Public Sans
    fontSize: 3rem
  body-md:
    fontFamily: Public Sans
    fontSize: 1rem
rounded:
  sm: 4px
  md: 8px
spacing:
  sm: 8px
  md: 16px
components:
  button-primary:
    backgroundColor: "{colors.tertiary}"
    textColor: "{colors.neutral}"
    rounded: "{rounded.sm}"
    padding: 12px
---

## Overview
Architectural Minimalism.

## Colors
- **Primary (#1A1C1E):** Deep ink for text.
...
```

## Agent Guidelines
When editing, reviewing, or generating design systems:
1. Always use standard naming conventions (e.g., `primary`, `secondary`, `neutral`, `body-md`, `headline-lg`, etc.).
2. Prefer using token references (`{colors.primary}`) in `components` to maintain consistency.
3. Validate modified or newly created `DESIGN.md` files using the `lint` command of the CLI.
