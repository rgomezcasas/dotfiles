---
allowed-tools: Bash(/Users/rafa.gomez/.dotfiles/scripts/utils/weekly_git_report:*), Bash(gdate:*)
description: Analiza el trabajo de la semana
model: haiku
---

Genera un resumen estructurado del trabajo realizado por Rafa Gómez desde el lunes de esta semana hasta hoy.

# Contexto
- El lunes de esta semana fue: !`gdate -d 'last monday' +%Y-%m-%d`
- Hoy es: !`gdate +%Y-%m-%d`

## Commits por repositorio:
!`/Users/rafa.gomez/.dotfiles/scripts/utils/weekly_git_report commits`

## Archivos modificados por repositorio:
!`/Users/rafa.gomez/.dotfiles/scripts/utils/weekly_git_report files`

## Mensajes de commits por repositorio:
!`/Users/rafa.gomez/.dotfiles/scripts/utils/weekly_git_report messages`

# IMPORTANTE: Proceso a seguir

Analiza los datos de commits proporcionados arriba y genera el informe siguiendo el formato especificado más abajo.

# Contexto de repositorios

Los repositorios que terminan en `-course` son repositorios de ejemplos de cursos. El nombre del curso se puede inferir del nombre del repositorio. Por ejemplo:
- `infrastructure_design-eventbus-aws-course` → Curso de Infrastructure Design: Event Bus con AWS
- `aggregates-course` → Curso de Aggregates

# Formato del informe

## Resumen
- Periodo: [lunes] - [hoy]
- Total de commits: [número]
- Repositorios activos: [número]

## Detalle por repositorio
Para cada repositorio con actividad:
- **[Nombre repositorio]**
  - Commits: [número]
  - Cambios principales: [resumen de los principales cambios]
  - Días en los que se ha trabajado: [qué días se ha trabajado en este repositorio. Ej: Lunes y martes]
  - Archivos más modificados: [top 3 archivos]

Incluye una sección de insights que tenga Patrones de trabajo identificados y áreas de mayor enfoque.
