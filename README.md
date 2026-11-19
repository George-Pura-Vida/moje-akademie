# Moje akademie · Hovor s jistotou

Česká webová aplikace pro 5–7minutové tréninky obchodních hovorů. Světlá jarní paleta, mobilní rozhraní s ukotveným hamburger menu.

## Funkce
- 12 modelových scénářů: zahájení, námitky, doporučení a schůzky ve třech prostředích (Golden Gate, Allianz, GG Digital).
- Vlastní situace s oddělenými doloženými podklady, předpoklady a návrhy. Pravost vložených podkladů aplikace nezávisle neověřuje.
- Orientační vyhodnocení podle čtyř textových pravidel; sebejistota a odolnost jsou vlastní sebehodnocení. Nejde o AI posouzení významu ani psychologickou diagnostiku.
- Historie, grafy, opakování slabších témat, filtry a export/obnova JSON.
- Ukládání až explicitním tlačítkem, smazání a obnova s potvrzením. Bez odesílání klientům a bez propojení s účty či kalendářem.

## Nasazení na WebKitty
1. Zvol novou nebo prázdnou cílovou složku webu/subdomény. Při aktualizaci nejprve zálohuj existující soubory.
2. Nahraj vedle sebe `index.html`, `style.css` a `app.js` z kořene tohoto repozitáře (v Sites checkoutu jsou v `dist/`).
3. Pro nasazení ZIPem rozbal `moje-akademie-webkitty.zip` přímo do cílové složky, aby `index.html` byl v jejím kořeni.
4. Zapni HTTPS a otevři web. Není potřeba PHP, databáze, npm, cron ani API klíč.
5. Ověř začátek tréninku, uložení, historii a hamburger menu na mobilu.

Historie a vlastní scénáře jsou v localStorage konkrétního prohlížeče a původu (domény). Nepřenášejí se automaticky mezi Sites, WebKitty, mobilem a počítačem. Pro přenos použij export a obnovu. Vymazání dat prohlížeče může záznamy odstranit. Přístup k webu samotnému případně omez na hostingu; tato statická aplikace nemá vlastní přihlašovací systém.

Všechny výchozí příklady jsou modelové, bez ověřených klientských či produktových údajů. Produktové ceny, výnosy, krytí a podmínky ověřuj samostatně z aktuálních podkladů.
