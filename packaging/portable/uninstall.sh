#!/usr/bin/env sh
set -e

if [ "$(id -u)" -eq 0 ]; then
    PREFIX="${PREFIX:-/usr/local}"
    TERMINFO_DIR="${TERMINFO_DIR:-/usr/share/terminfo}"
    MAN_DIR="${MAN_DIR:-/usr/local/share/man/man1}"
    APP_DIR="${APP_DIR:-/usr/local/share/applications}"
    ICON_DIR="${ICON_DIR:-/usr/local/share/pixmaps}"
    BIN_DIR="${PREFIX}/bin"
    echo "[INFO] Modo root detectado. Desinstalando archivos del sistema en ${PREFIX}..."
else
    PREFIX="${PREFIX:-${HOME}/.local}"
    TERMINFO_DIR="${TERMINFO_DIR:-${HOME}/.terminfo}"
    MAN_DIR="${MAN_DIR:-${HOME}/.local/share/man/man1}"
    APP_DIR="${APP_DIR:-${HOME}/.local/share/applications}"
    ICON_DIR="${ICON_DIR:-${HOME}/.local/share/icons}"
    BIN_DIR="${PREFIX}/bin"
    echo "[INFO] Modo usuario detectado. Desinstalando archivos de usuario en ${PREFIX}..."
fi

rm -f "${BIN_DIR}/not-st" "${BIN_DIR}/st" "${BIN_DIR}/st-urlhandler"
rm -f "${APP_DIR}/st.desktop"
rm -f "${ICON_DIR}/st.png"
rm -f "${MAN_DIR}/st.1"
rm -f "${TERMINFO_DIR}/s/st" "${TERMINFO_DIR}/s/st-256color" "${TERMINFO_DIR}/s/st-mono" "${TERMINFO_DIR}/s/st-meta" "${TERMINFO_DIR}/s/st-meta-256color" 2>/dev/null || true

echo "[OK] Desinstalacion completada."
