<?php
// Zkopíruj přes File Manager do .moje-akademie/config.php v kořeni hostingového účtu.
// Soubor musí být MIMO veřejnou složku moje-akademie a MIMO GitHub.
// Doplň své hodnoty přímo ve správě hostingu, neposílej je do chatu.
return [
    'api_key' => '', // OpenAI API klíč
    'password_hash' => password_hash('ZVOL_VLASTNI_SILNE_HESLO', PASSWORD_DEFAULT),
    'daily_requests' => 40, // přepis a vyhodnocení jsou dva samostatné požadavky
];
