# Lab 6: sistema di controllo

## Componenti esterni VHDL
- `components/`: `memory.vhd`

## Sequenza di azioni ad alto livello
1. Aspettare segnale di `Start 0 -> 1`
2. Riempire `MEM_A` per intero (iniziare l'analisi solo successivamente)
3. Analisi: calcolare `POWER` e inserirlo in `MEM_B`
4. Aspettare `Start 1 -> 0`, poi segnalare `Done 0 -> 1`

## Dettagli di implementazione

### Pipeline degli ingressi
La funzionalità da implementare è sostanzialmente un filtro FIR di ordine 2.  

> `POWER[i] = a*E[i] + b*E[i-1]`  

Invece di fare due letture da `MEM_A` per ogni `POWER[i]`,
possiamo inserire due registri in cascata che salvino `E[i]` ed `E[i-1]` in modo da fare una sola lettura.
Definiamo inoltre `E[-1] = 0`.

### Calcolo di `POWER`
Riprendiamo l'espressione di `POWER[i]`:

> `POWER[i] = a*E[i] + b*E[i-1]`  

I coefficienti possibili sono:
- `a = 2.25 = 9/4` e `b = 1.75 = 7/4`
- `a = 1.25 = 5/4 = 10/8` e `b = 0.875 = 7/8`

Per calcolare il risultato, consideriamo le rappresentazioni di a e b con denominatore
comune, poi sommiamo `numeratore(a) * E[i] + numeratore(b) * E[i-1]` e dividiamo per il
risultato per `denominatore`, il quale sarà `4` o `8`.
Siccome stiamo lavorando con potenze di `2`, basterà compiere uno shift aritmetico
(quindi con estensione del segno).