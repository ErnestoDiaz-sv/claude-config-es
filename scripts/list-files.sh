#!/usr/bin/env bash
set -euo pipefail

category="${1:-all}"
case "$category" in
  skills|agents|hooks|all) ;;
  *) printf 'Usage: %s [skills|agents|hooks|all]\n' "$0" >&2; exit 2 ;;
esac

if [[ "$category" == skills || "$category" == all ]]; then
  printf '%s\n' \
    skills/investigar/SKILL.md \
    skills/office-hours/SKILL.md \
    skills/revisar-plan/SKILL.md \
    skills/limpieza-config/SKILL.md \
    skills/supervisor-de-costos/SKILL.md \
    skills/proyecto-de-codigo-con-ia/SKILL.md \
    skills/ship/SKILL.md
fi
if [[ "$category" == agents || "$category" == all ]]; then
  printf '%s\n' agents/explorador.md agents/implementador.md agents/revisor.md
fi
if [[ "$category" == hooks || "$category" == all ]]; then
  printf '%s\n' hooks/verify-on-stop.sh statusline.sh
fi
