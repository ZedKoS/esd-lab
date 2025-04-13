## Sequenza di azioni ad alto livello
1. Aspettare segnale di `Start 0 -> 1`
2. Riempire `MEM_A` per intero (iniziare l'analisi solo successivamente)
3. Analisi: calcolare `POWER` e inserirlo in `MEM_B`
4. Aspettare `Start 1 -> 0`, poi segnalare `Done 0 -> 1`

## Dettagli di implementazione
La funzionalità da implementare è sostanzialmente un filtro FIR di ordine 2.  

> `POWER[i] = a*E[i] + b*E[i-1]`  

Invece di fare due letture da `MEM_A` per ogni `POWER[i]`, possiamo inserire due registri in cascata che salvino `E[i]` ed `E[i-1]` in modo da fare una sola lettura.
Definiamo inoltre `E[-1] = 0`.