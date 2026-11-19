# Automatické nasazení Moje akademie

Cílový web: https://moje-akademie.jirijanousek.cz/

## Aktivní způsob nasazování

WebKitty je propojený s veřejným repozitářem George-Pura-Vida/moje-akademie. Zdrojová kopie je v samostatné složce moje-akademie-git, webové soubory ve složce moje-akademie. Subdoména již míří do této webové složky.

Na WebKitty je zapnutá plánovaná úloha, která každých 5 minut spouští:

```sh
/bin/sh /home/sites/1a/1/1f8017897e/moje-akademie-git/scripts/deploy_webkitty_native.sh --sync
```

Úloha stáhne větev main přes veřejné HTTPS, provede pouze fast-forward aktualizaci a při změně commitu nasadí index.html, style.css a app.js. Do _version.json zapíše identifikátor nasazeného commitu. Nezměněný commit znovu nenasazuje. Heslo k FTP ani token GitHubu nejsou pro tento způsob potřeba.

První přenos byl úspěšně ověřen spuštěním stejného příkazu přes Test Command; webová aplikace se načetla na cílové HTTPS adrese. Úloha byla uložena jako Enabled s intervalem Every 5 minutes.

## Správa

- Změny na větvi main se obvykle projeví do pěti minut plus doba běhu úlohy a případná cache.
- Okamžité stažení repozitáře je možné tlačítkem Deploy ve WebKitty Git Version Control. Pro okamžitou aktualizaci webové složky lze v Scheduled Tasks použít Test Command u této konkrétní úlohy.
- Automat vypneš odškrtnutím Enabled pouze u úlohy obsahující moje-akademie-git.
- Předchozí verze dotčených souborů se zálohují do .deploy-state/backups uvnitř zdrojové kopie, mimo kořen webu.
- Skript nemaže ostatní soubory webu, nezasahuje do ostatních aplikací a používá zámek proti souběžným běhům.
- Nasazení jednotlivých souborů probíhá přejmenováním připravených kopií. Celá sada není atomická; při selhání obnov zálohu nebo zopakuj úlohu.
- Při konfliktu s místními změnami Git fast-forward odmítne. Příčinu nejprve vyřeš, neprováděj reset serverové kopie naslepo.

## GitHub Actions jako alternativní cesta

Soubor .github/workflows/webkitty.yml kontroluje aplikaci. Jeho alternativní FTPS přenos není pro aktivní způsob potřeba. Nezapínej současně WEBKITTY_DEPLOY_ENABLED a další přenos, aby se nasazování nepřekrývalo.

Historie tréninků zůstává v prohlížeči návštěvníka. Na GitHub ani do nasazovací úlohy se neposílá.
