#!/usr/bin/env bash
# review-inbox.sh — ritual semanal de revisão do inbox de memória federada.
# Processa cada sugestão de /50-inbox/suggested-memory.md interativamente:
#   a = aprovar (anexa ao destino e remove do inbox)
#   e = editar (abre $EDITOR e volta a perguntar)
#   r = rejeitar (remove do inbox)
#   d = adiar  (mantém no inbox)
#   q = sair    (mantém o que sobrar)
# Decisões são registradas em /90-archive/review-log.md.

set -euo pipefail

VAULT="${VAULT_PATH:-$(pwd)/template}"
INBOX="$VAULT/50-inbox/suggested-memory.md"
LOG="$VAULT/90-archive/review-log.md"
MARKER="<!-- Entradas pendentes abaixo desta linha -->"
EDITOR_CMD="${EDITOR:-nano}"

[[ -f "$INBOX" ]] || { echo "Inbox não encontrado: $INBOX" >&2; exit 1; }
mkdir -p "$(dirname "$LOG")"
[[ -f "$LOG" ]] || printf '# 90-archive — Log de revisões do inbox\n\n<!-- Entradas abaixo desta linha -->\n' > "$LOG"

header=$(awk -v m="$MARKER" 'BEGIN{p=1} {print} $0==m{exit}' "$INBOX")
body=$(awk -v m="$MARKER" 'f{print} $0==m{f=1}' "$INBOX")

if [[ -z "${body// }" ]]; then
  echo "Nada no inbox. Tudo já revisado."
  exit 0
fi

# Split entries on blank-line-then-"## " boundaries
mapfile -t entries < <(printf '%s\n' "$body" | awk '
  BEGIN{buf=""}
  /^## / && buf!="" { print buf "\x1e"; buf="" }
  { buf = buf $0 "\n" }
  END{ if (buf!="") print buf "\x1e" }
' | tr '\n' '\v' | tr '\x1e' '\n' )

kept=()
total=${#entries[@]}
idx=0

ts() { date '+%Y-%m-%d %H:%M'; }
field() { printf '%s' "$1" | tr '\v' '\n' | grep -m1 -E "^\*\*$2:\*\*" | sed -E "s/^\*\*$2:\*\*[[:space:]]*//" || true; }
title() { printf '%s' "$1" | tr '\v' '\n' | grep -m1 -E '^## ' | sed 's/^## //'; }

log_decision() {
  local decision="$1" dest="$2" sug="$3" dom="$4"
  printf -- '- %s — **%s** — %s — `%s` — %s\n' "$(ts)" "$decision" "${dom:-?}" "${dest:-—}" "${sug:-—}" >> "$LOG"
}

flush() {
  {
    printf '%s\n' "$header"
    if ((${#kept[@]})); then
      for e in "${kept[@]}"; do printf '%s' "$e" | tr '\v' '\n'; done
    fi
  } > "$INBOX.tmp" && mv "$INBOX.tmp" "$INBOX"
}

quit=0
for entry in "${entries[@]}"; do
  idx=$((idx+1))
  [[ -z "${entry//[[:space:]]/}" ]] && continue
  if (( quit )); then kept+=("$entry"); continue; fi

  dest=$(field "$entry" "Destino sugerido")
  sug=$(field "$entry" "Sugestão")
  dom=$(title "$entry")

  echo
  echo "──────── [$idx/$total] ────────"
  printf '%s\n' "$entry" | tr '\v' '\n'
  echo "────────────────────────────"
  while true; do
    read -r -p "[a]provar  [e]ditar  [r]ejeitar  [d]eferir  [q]uit > " ans </dev/tty || ans=d
    case "${ans,,}" in
      a)
        if [[ -z "$dest" ]]; then
          read -r -p "Destino vazio. Caminho relativo ao vault: " dest </dev/tty
        fi
        target="$VAULT/${dest#./}"; target="${target//\/.\//\/}"
        mkdir -p "$(dirname "$target")"
        [[ -f "$target" ]] || : > "$target"
        { printf '\n'; printf '%s' "$entry" | tr '\v' '\n'; } >> "$target"
        log_decision "aprovado" "$dest" "$sug" "$dom"
        echo "→ anexado em $dest"
        break;;
      e)
        tmp=$(mktemp); printf '%s' "$entry" | tr '\v' '\n' > "$tmp"
        "$EDITOR_CMD" "$tmp" </dev/tty >/dev/tty
        entry=$(cat "$tmp" | tr '\n' '\v'); rm -f "$tmp"
        dest=$(field "$entry" "Destino sugerido"); sug=$(field "$entry" "Sugestão"); dom=$(title "$entry")
        echo "(editado — escolha de novo)"
        ;;
      r) log_decision "rejeitado" "$dest" "$sug" "$dom"; echo "→ rejeitado"; break;;
      d) kept+=("$entry"); log_decision "adiado" "$dest" "$sug" "$dom"; echo "→ adiado"; break;;
      q) kept+=("$entry"); quit=1; break;;
      *) echo "Opção inválida.";;
    esac
  done
done

flush
echo
echo "Revisão concluída. Log: $LOG"
