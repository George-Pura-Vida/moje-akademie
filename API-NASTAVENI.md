# Hlasové tréninky a OpenAI API

## Hotové funkce
- Nahrávání mikrofonu u každého tématu, společnosti i vlastní situace, přehrání a stažení záznamu.
- Vložení zvukového souboru již nahraného hovoru do 20 MB.
- Režim „Nahrát + po zastavení AI“ po výslovném souhlasu odešle zvuk na přepis a přepis ke konkrétnímu hodnocení.
- Přepis: gpt-transcribe. Vyhodnocení: gpt-5.6-sol přes Responses API. Model se bez vědomí uživatele nemění.
- Konkrétní citace, opravené formulace, lepší odpověď, návrh reakce klienta, další krok a orientační skóre přesvědčivosti.
- Sebejistota a odolnost jsou vlastní sebehodnocení. Textová AI nezná tón hlasu ani psychický stav.
- Přepis a AI zpětná vazba se ukládají až potvrzením do místní historie. Zvuk je dočasně v paměti stránky; pro uchování jej stáhni.

## Jednorázové bezpečné propojení

OpenAI klíč se nikdy nevkládá do app.js, voice.js, GitHubu ani do veřejného kořene webu.

Nejrychlejší první propojení přes aplikaci:
1. V přihlášeném WebKitty File Manageru otevři v kořeni účtu neveřejný soubor `.moje-akademie/setup-code` a soukromě si zkopíruj jednorázový kód. Nikomu jej neposílej.
2. V hlasovém panelu aplikace rozbal **Dokončit bezpečné propojení OpenAI**.
3. Sám vyplň aktivační kód, OpenAI klíč a nové přístupové heslo (12+ znaků) a potvrď. Agent hodnoty nečte.
4. Kód se spotřebuje, klíč se zapíše mimo webroot a heslo jako hash. Formulář prvního propojení se uzavře. API dostupnost a kredit se ověří prvním skutečným požadavkem.

Alternativně ručně ve WebKitty File Manageru:
1. V kořeni účtu, vedle složek moje-akademie a moje-akademie-git, vytvoř neveřejnou složku `.moje-akademie`.
2. Do ní zkopíruj obsah `config.example.php` jako `config.php`.
3. Přímo v soukromém souboru vyplň svůj OpenAI API klíč a místo ZVOL_VLASTNI_SILNE_HESLO zadej vlastní silné přístupové heslo. Tyto hodnoty neposílej do chatu.
4. Nastav omezená práva složky (700) a souboru (600), pokud to správce hostingu umožňuje.
5. Obnov aplikaci a v hlasovém panelu se přihlas právě tímto heslem. Pro každý zvuk nebo text potvrď odeslání do OpenAI.

Alternativně lze na serveru nastavit OPENAI_API_KEY a ACADEMY_PASSWORD_HASH jako prostředí PHP procesu. Heslový hash musí být vytvořen funkcí password_hash(). Samotné nastavení prostředí v shellu neznamená, že ho zdědí webový PHP proces.

Dokud konfigurace není kompletní, placené požadavky jsou na serveru zablokované a aplikace jasně ukazuje čekající propojení. Lokální záznam je použitelný ihned. Dostupnost modelů a kredit API je nutné ověřit v konkrétním OpenAI projektu.

Server vyžaduje PHP 8.1+, cURL a Fileinfo, HTTPS a povolené odchozí HTTPS do api.openai.com. Pro nahrávky do 20 MB nastav na hostingu upload_max_filesize alespoň 20M a post_max_size alespoň 22M. Při menším limitu použij kratší záznam. Server audio zpracuje jako dočasný upload; nevytváří jeho trvalou kopii. Přenos do OpenAI probíhá pouze po potvrzeném režimu. Responses požadavky mají store=false; to nepředstavuje záruku nulové retence provozovatele API.

Výchozí společný limit je 40 API požadavků za 24 hodin; přepis a vyhodnocení jsou dva samostatné požadavky. Lze jej upravit v soukromé konfiguraci, maximálně na 200. Přístup chrání heslo, HttpOnly relace a CSRF token. JSON záloha obsahuje přepis a hodnocení, nikoli audio.

Mikrofon webové aplikace automaticky nezíská zvuk druhé strany telefonního hovoru. Pro reálné telefonáty nahraj oprávněně pořízený audio soubor, případně použij vhodný způsob záznamu obou stran. API vyhodnocuje přepis a nezaručuje správné rozlišení mluvčích.
