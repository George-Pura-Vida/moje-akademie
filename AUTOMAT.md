# Automatické nasazení na WebKitty

Cílový web: https://moje-akademie.jirijanousek.cz/

Workflow po změně hlavní aplikace na větvi main zkontroluje soubory. Automatický přenos je záměrně neaktivní, dokud není výslovně zapnut proměnnou níže. Žádné hostingové heslo není součástí repozitáře.

## Jednorázové nastavení

V GitHub repozitáři otevři Settings → Secrets and variables → Actions.

Do Repository secrets vlož:

| Název | Hodnota |
| --- | --- |
| WEBKITTY_FTP_HOST | Přesný FTP server uvedený v WebKitty FTP Details, bez protokolu |
| WEBKITTY_FTP_USER | FTP uživatelské jméno |
| WEBKITTY_FTP_PASSWORD | Heslo FTP účtu |
| WEBKITTY_REMOTE_DIR | Ověřená kořenová složka této subdomény z pohledu FTP účtu |

Cestu nepřebírej podle odhadu. Pokud FTP účet začíná přímo v kořeni této aplikace, použij `/`. Vhodný je samostatný účet omezený na složku akademie. Ověř podporu explicitního FTPS a platný certifikát hostitele. Skript neposílá nešifrované FTP a neobchází kontrolu certifikátu.

Volitelná Repository variable `WEBKITTY_FTP_PORT` mění výchozí port 21.

WebKitty musí přenos z GitHub runneru povolit. Případné omezení přístupu řeš nastavením konkrétního FTP účtu / povoleného runneru; workflow nic neodemyká a nemění nastavení hostingu.

## První nasazení

1. Zálohuj dosavadní tři soubory cílového webu, pokud existují.
2. V Actions vyber **Moje akademie – WebKitty**, klikni **Run workflow**, zvol main a zaškrtni potvrzení nasazení.
3. Ověř úspěch přenosu a funkčnost aplikace na cílové adrese.
4. Chceš-li nasazovat automaticky při dalších změnách aplikace na main, přidej v **Variables** hodnotu `WEBKITTY_DEPLOY_ENABLED` = `true`.
5. Automatické nasazování vypneš změnou této hodnoty na `false`.

Skript přepisuje pouze `style.css`, `app.js` a `index.html`, v tomto pořadí. Ostatní soubory nemaže. Přenos není atomický: při selhání již může být část souborů nová. Zopakuj úspěšně celý přenos nebo obnov zálohu. Nové sloučené změny na main jsou po zapnutí automatu automaticky nasazovány.

Toto nastavení nenahrazuje DNS, založení subdomény ani HTTPS na hostingu. Osobní historie tréninků zůstává v prohlížeči a do GitHubu se neodesílá.
