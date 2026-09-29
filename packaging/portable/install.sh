#!/usr/bin/env sh
set -e

# Determinar directorios de instalacion segun permisos
if [ "$(id -u)" -eq 0 ]; then
    PREFIX="${PREFIX:-/usr/local}"
    TERMINFO_DIR="${TERMINFO_DIR:-/usr/share/terminfo}"
    MAN_DIR="${MAN_DIR:-/usr/local/share/man/man1}"
    APP_DIR="${APP_DIR:-/usr/local/share/applications}"
    ICON_DIR="${ICON_DIR:-/usr/local/share/pixmaps}"
    BIN_DIR="${PREFIX}/bin"
    echo "[INFO] Modo root detectado. Instalando a nivel de sistema en ${PREFIX}..."
else
    PREFIX="${PREFIX:-${HOME}/.local}"
    TERMINFO_DIR="${TERMINFO_DIR:-${HOME}/.terminfo}"
    MAN_DIR="${MAN_DIR:-${HOME}/.local/share/man/man1}"
    APP_DIR="${APP_DIR:-${HOME}/.local/share/applications}"
    ICON_DIR="${ICON_DIR:-${HOME}/.local/share/icons}"
    BIN_DIR="${PREFIX}/bin"
    echo "[INFO] Modo usuario detectado. Instalando en ${PREFIX}..."
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 1. Instalar binarios
mkdir -p "${BIN_DIR}"
if [ -f "${SCRIPT_DIR}/bin/not-st" ]; then
    cp -f "${SCRIPT_DIR}/bin/not-st" "${BIN_DIR}/not-st"
    chmod 755 "${BIN_DIR}/not-st"
    echo "[OK] Binario instalado: ${BIN_DIR}/not-st"
elif [ -f "${SCRIPT_DIR}/bin/st" ]; then
    cp -f "${SCRIPT_DIR}/bin/st" "${BIN_DIR}/not-st"
    chmod 755 "${BIN_DIR}/not-st"
    echo "[OK] Binario instalado: ${BIN_DIR}/not-st"
fi

if [ -f "${SCRIPT_DIR}/bin/st-urlhandler" ]; then
    cp -f "${SCRIPT_DIR}/bin/st-urlhandler" "${BIN_DIR}/st-urlhandler"
    chmod 755 "${BIN_DIR}/st-urlhandler"
    echo "[OK] Script urlhandler instalado: ${BIN_DIR}/st-urlhandler"
fi

# 2. Instalar terminfo
if command -v tic >/dev/null 2>&1 && [ -f "${SCRIPT_DIR}/st.info" ]; then
    echo "[INFO] Compilando terminfo con tic..."
    tic -sx -o "${TERMINFO_DIR}" "${SCRIPT_DIR}/st.info" 2>/dev/null || {
        echo "[WARNING] tic no pudo compilar directamente, copiando base terminfo precompilada..."
        mkdir -p "${TERMINFO_DIR}"
        [ -d "${SCRIPT_DIR}/terminfo" ] && cp -rf "${SCRIPT_DIR}/terminfo/"* "${TERMINFO_DIR}/"
    }
elif [ -d "${SCRIPT_DIR}/terminfo" ]; then
    echo "[INFO] Copiando terminfo precompilado..."
    mkdir -p "${TERMINFO_DIR}"
    cp -rf "${SCRIPT_DIR}/terminfo/"* "${TERMINFO_DIR}/"
fi
echo "[OK] Terminfo registrado en ${TERMINFO_DIR}"

# 3. Instalar acceso directo (.desktop) e icono
if [ -f "${SCRIPT_DIR}/assets/st.desktop" ]; then
    mkdir -p "${APP_DIR}"
    cp -f "${SCRIPT_DIR}/assets/st.desktop" "${APP_DIR}/st.desktop"
    chmod 644 "${APP_DIR}/st.desktop"
    echo "[OK] Acceso directo instalado: ${APP_DIR}/st.desktop"
fi

if [ -f "${SCRIPT_DIR}/assets/st.png" ]; then
    mkdir -p "${ICON_DIR}"
    cp -f "${SCRIPT_DIR}/assets/st.png" "${ICON_DIR}/st.png"
    chmod 644 "${ICON_DIR}/st.png"
    echo "[OK] Icono instalado: ${ICON_DIR}/st.png"
fi

# 4. Instalar manual
if [ -f "${SCRIPT_DIR}/doc/st.1" ]; then
    mkdir -p "${MAN_DIR}"
    cp -f "${SCRIPT_DIR}/doc/st.1" "${MAN_DIR}/st.1"
    chmod 644 "${MAN_DIR}/st.1"
    echo "[OK] Manual instalado: ${MAN_DIR}/st.1"
fi

echo ""
echo "[OK] Instalacion finalizada correctamente."
if [ "$(id -u)" -ne 0 ]; then
    case ":$PATH:" in
        *":${BIN_DIR}:"*) ;;
        *) echo "[NOTE] Asegurate de que ${BIN_DIR} este en tu variable PATH de tu shell." ;;
    esac
fi
