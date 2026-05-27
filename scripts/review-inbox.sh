#!/usr/bin/env bash
# review-inbox.sh — ritual semanal de revisão do inbox de memória federada.
# Processa cada sugestão de /90-inbox/suggested-memory.md interativamente:
#   a = aprovar (anexa ao destino e remove do inbox)
#   e = editar (abre $EDITOR e volta a perguntar)
#   r = rejeitar (remove do inbox)
#   d = adiar  (mantém no inbox)
#   q = sair    (mantém o que sobrar)
# Decisões são registradas em /99-archive/review-log.md.

set -euo pipefail

VAULT="${VAULT_PATH:-$(pwd)/template}"
INBOX="$VAULT/90-inbox/suggested-memory.md"
LOG="$VAULT/99-archive/review-log.md"
MARKER="<!-- Entradas pendentes abaixo desta linha -->"
EDITOR_CMD="${EDITOR:-nano}"

[[ -f "$INBOX" ]] || { echo "Inbox não encontrado: $INBOX" >&2; exit 1; }
mkdir -p "$(dirname "$LOG")"
[[ -f "$LOG" ]] || printf '# 99-archive — Log de revisões do inbox\n\n<!-- Entradas abaixo desta linha -->\n' > "$LOG"

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
fm() { printf '%s' "$1" | tr '\v' '\n' | grep -m1 -E "^$2:" | sed -E "s/^$2:[[:space:]]*//"; }

log_archive() {
  local kind="$1" dest="$2" dom="$3"
  printf -- '- %s — **%s** — %s — `%s`\n' "$(ts)" "$kind" "${dom:-?}" "${dest:-—}" >> "$LOG"
}

# Pré-pass: classificação automática por confidence/risk/ttl
auto_kept=()       # entradas que vão para revisão humana
silent_kept=()     # entradas mantidas no inbox sem apresentar (aprovação lazy)
for entry in "${entries[@]}"; do
  [[ -z "${entry//[[:space:]]/}" ]] && continue
  conf=$(fm "$entry" "confidence")
  risk=$(fm "$entry" "risk")
  ttl=$(fm "$entry" "ttl_days")
  dom=$(fm "$entry" "domain")
  # Sem classificação → vai para revisão humana
  if [[ -z "$conf" || -z "$risk" ]]; then
    auto_kept+=("$entry"); continue
  fi
  # High risk → sempre revisão humana
  if [[ "$risk" == "high" ]]; then
    auto_kept+=("$entry"); continue
  fi
  # Hypothesis → fica para humano
  if [[ "$conf" == "hypothesis" ]]; then
    auto_kept+=("$entry"); continue
  fi
  # Verified + low + ttl vencido (<=7) → promove auto
  if [[ "$conf" == "verified" && "$risk" == "low" && -n "$ttl" && "$ttl" -le 7 ]]; then
    target="$VAULT/20-domains/${dom:-uncategorized}/auto-promoted.md"
    mkdir -p "$(dirname "$target")"
    [[ -f "$target" ]] || : > "$target"
    { printf '\n'; printf '%s' "$entry" | tr '\v' '\n'; } >> "$target"
    log_archive "auto_promoted" "20-domains/${dom:-uncategorized}/auto-promoted.md" "$dom"
    continue
  fi
  # Verified + medium → mantém no inbox sem apresentar (aprovação lazy)
  if [[ "$conf" == "verified" && "$risk" == "medium" ]]; then
    silent_kept+=("$entry")
    log_archive "pending_lazy" "90-inbox/suggested-memory.md" "$dom"
    continue
  fi
  # Default: vai para humano
  auto_kept+=("$entry")
done
entries=("${auto_kept[@]}")
total=${#entries[@]}

log_decision() {
  local decision="$1" dest="$2" sug="$3" dom="$4"
  printf -- '- %s — **%s** — %s — `%s` — %s\n' "$(ts)" "$decision" "${dom:-?}" "${dest:-—}" "${sug:-—}" >> "$LOG"
}

flush() {
  {
    printf '%s\n' "$header"
    # Mantidos silenciosamente (verified+medium, aprovação lazy)
    if ((${#silent_kept[@]})); then
      for e in "${silent_kept[@]}"; do printf '%s' "$e" | tr '\v' '\n'; done
    fi
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
        log_decision "human_approved" "$dest" "$sug" "$dom"
        echo "→ anexado em $dest"
        break;;
      e)
        tmp=$(mktemp); printf '%s' "$entry" | tr '\v' '\n' > "$tmp"
        "$EDITOR_CMD" "$tmp" </dev/tty >/dev/tty
        entry=$(cat "$tmp" | tr '\n' '\v'); rm -f "$tmp"
        dest=$(field "$entry" "Destino sugerido"); sug=$(field "$entry" "Sugestão"); dom=$(title "$entry")
        echo "(editado — escolha de novo)"
        ;;
      r) log_decision "human_rejected" "$dest" "$sug" "$dom"; echo "→ rejeitado"; break;;
      d) kept+=("$entry"); log_decision "human_deferred" "$dest" "$sug" "$dom"; echo "→ adiado"; break;;
      q) kept+=("$entry"); quit=1; break;;
      *) echo "Opção inválida.";;
    esac
  done
done

flush
echo
echo "Revisão concluída. Log: $LOG"
