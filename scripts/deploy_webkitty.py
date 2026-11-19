"""Upload only the three application files using verified explicit FTPS."""
import ftplib
import os
from pathlib import Path
import ssl
import sys

FILES = ("style.css", "app.js", "index.html")


def main():
    required = ("WEBKITTY_FTP_HOST", "WEBKITTY_FTP_USER", "WEBKITTY_FTP_PASSWORD", "WEBKITTY_REMOTE_DIR")
    missing = [key for key in required if not os.environ.get(key, "").strip()]
    if missing:
        print("::error::Chybí nastavení: " + ", ".join(missing))
        return 1
    remote = os.environ["WEBKITTY_REMOTE_DIR"]
    if any(c in remote for c in ("\r", "\n", "\x00")) or ".." in remote.split("/"):
        print("::error::Neplatná cílová složka.")
        return 1
    for name in FILES:
        if not Path(name).is_file() or not Path(name).stat().st_size:
            print("::error::Chybí soubor aplikace: " + name)
            return 1
    try:
        # Certificate and hostname validation stay enabled. Never fall back to plain FTP.
        with ftplib.FTP_TLS(context=ssl.create_default_context(), timeout=45) as ftp:
            ftp.connect(os.environ["WEBKITTY_FTP_HOST"], int(os.environ.get("WEBKITTY_FTP_PORT") or "21"))
            ftp.login(os.environ["WEBKITTY_FTP_USER"], os.environ["WEBKITTY_FTP_PASSWORD"])
            ftp.prot_p()
            # The directory must already exist and be confirmed in hosting settings.
            ftp.cwd(remote)
            for name in FILES:
                with Path(name).open("rb") as source:
                    ftp.storbinary("STOR " + name, source)
                print("Nahráno: " + name)
            ftp.quit()
    except Exception:
        # Server exceptions may contain account details; do not print them in public logs.
        print("::error::Přenos selhal. Ověř FTPS hostitele, certifikát, port, oprávnění, složku a dostupnost FTP z runneru. Část souborů již mohla být aktualizována.")
        return 1
    print("Přenos tří souborů byl dokončen. Ověř web https://moje-akademie.jirijanousek.cz/.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
