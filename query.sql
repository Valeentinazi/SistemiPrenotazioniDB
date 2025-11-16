QUERY SQL PROJECT WORK VALENTINA
---------------------------------------

1: Elenco dei biglietti con più tratte: 

SELECT 
    b.id_biglietto,
    b.data_emissione,
    b.prezzo,
    COUNT(bl.id) AS numero_tratte
FROM biglietto b
JOIN biglietto_linea bl 
    ON bl.id_biglietto = b.id_biglietto
GROUP BY b.id_biglietto, b.data_emissione, b.prezzo
HAVING COUNT(bl.id) > 1;

2: Ricerca tratte tra due stazioni:

SELECT 
    p.id AS id_percorso,
    p.stazione_partenza,
    p.stazione_arrivo,
    p.data_viaggio,
    t.numero_treno,
    t.tipo_treno
FROM percorso p
JOIN biglietto_linea bl ON bl.id_percorso = p.id
JOIN treno t ON t.id = bl.id_treno
WHERE p.stazione_partenza = 'BariCentrale'
  AND p.stazione_arrivo = 'Foggia';


3. Verifica validità di un biglietto:

SELECT 
    b.id_biglietto,
    b.data_emissione,
    b.prezzo,
    b.stato,
    COUNT(bl.id) AS numero_tratte
FROM biglietto b
LEFT JOIN biglietto_linea bl 
    ON bl.id_biglietto = b.id_biglietto
WHERE b.id_biglietto = 7   -- cambia ID
GROUP BY b.id_biglietto, b.data_emissione, b.prezzo, b.stato;


4. Ultimi 4 pagamenti effettuati:

SELECT 
    p.id_pagamento,
    p.id_biglietto,
    p.metodo,
    p.importo,
    p.data_pagamento
FROM pagamento p
ORDER BY p.data_pagamento DESC
LIMIT 4;



5. Visualizzazione dei posti disponibili per un determinato treno e data:

SELECT 
    cp.id_treno,
    cp.data,
    cp.classe,
    cp.posti_capienti AS posti_disponibili
FROM capienza_posti cp
WHERE cp.id_treno = 9806
AND cp.data = '2025-11-22';


6. Gestione di cambi e scali

SELECT 
    b.id_biglietto,
    
    COUNT(bl.id) AS numero_tratte,
    
    CASE 
        WHEN COUNT(bl.id) > 1 THEN COUNT(bl.id) - 1
        ELSE 0
    END AS numero_cambi,

    STRING_AGG(
        CONCAT(
            'Tratta ', bl.ordine, ': ',
            p.stazione_partenza, ' → ', p.stazione_arrivo,
            ' (Treno ', t.numero_treno, ')'
        ),
        ' | ' ORDER BY bl.ordine
    ) AS dettaglio_tratte,

    STRING_AGG(DISTINCT t.numero_treno::text, ', ') AS treni_coinvolti

FROM biglietto b
JOIN biglietto_linea bl ON bl.id_biglietto = b.id_biglietto
JOIN percorso p ON p.id = bl.id_percorso
JOIN treno t ON t.id = bl.id_treno

GROUP BY b.id_biglietto
ORDER BY b.id_biglietto;
