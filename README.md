GUIDA CONFIGURAZIONE DI P4C AUTOMATICA O MANUALE

0) Aprire carella “Galileo x P4C”;

1) DA ADMIN:
- Cliccare sul file “jre-8u5-windows-i586.exe” per installare la java 8;
- Sulla prima scheda cliccare "installa" senza modificare niente;
 - Attendere il completamento;
 - Verificare che il flag: “ripristina prompt di sicurezza” sia DISATTIVATO;
 - Cliccare “avanti” e completare l’installazione;

   
2) DA ADMIN (solo la prima volta) avviare il file "P4C_Setup_Auto.bat":
Questo script automatizza completamente l'installazione del sistema P4C senza bisogno di intervento
dell'utente.
Per la prima esecuzione serve essere admin per poter creare il collegamento in
"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp" per l'esecuzione automatica all'avvio.
OBIETTIVO PRINCIPALE
- Far coesistere due processi di java 6 e java 8 in modo tale da permettere il corretto funzionamento a
Galileo (java 6) e P4C (java 8).
- Automatizzare tutto il processo.
File necessari all'esecuzione di "P4C_Setup_Auto.bat":
- "tinyserver.jnlp" - Applicazione P4C;
- "galileo.jnlp" - Applicazione Galileo;
- "galileo.bat" - Script per avvio Galileo con Java 6;
- "deployment.properties" - Configurazione Java;
- "Icona_Galileo.ico" - Icona per il collegamento di Galileo su desktop;
- "sfondo_popup.png" - Sfondo del popup bloccante dell'utente (opzionale);
COSA VEDE L'UTENTE
- Una finestra fullscreen che copre tutto lo schermo;
- Una progress bar che avanza lentamente per 45 secondi;
- Messaggi che spiegano cosa sta succedendo;
- L'avviso: "SE NECESSARIO CLICCARE “ESEGUI” AL TERMINE";
USCITA DI EMERGENZA
- Premere Ctrl+O per interrompere tutto immediatamente:
- Lo script ferma tutti i processi e chiude l'interfaccia;
OPERAZIONI DEL BAT:
AVVIO
- Nasconde la finestra del prompt
- Crea l'interfaccia di blocco fullscreen
- Termina eventuali processi javaw.exe aperti (che riavvierà alla fine)
GESTIONE FILE E CARTELLE
- Crea la cartella "C:\Galileo";
- Copia il ‘galielo.jnlp’ in “C:\Galileo”;
- Crea la cartella "C:\P4C" e copia dentro tutti i file della cartella corrente;
- Elimina eventuali collegamenti già esistenti di Galileo presenti sul desktop;
- Crea il collegamento "Galileo.bat", con icona personalizzata, sul desktop per l’esecuzione di Galileo con
Java 6;
CONFIGURAZIONE AUTOMATICA
- Per l'esecuzione automatica all'avvio per tutti gli utenti esistenti e nuovi, crea un collegamento di
"P4C_setup_auto.bat" (presente in "C:\P4C") in "C:\ProgramData\Microsoft\Windows\Start
Menu\Programs\StartUp";
- Imposta le configurazioni Java necessarie copiando il file "deployment.properties" in
"C:\Users\Default\AppData\LocalLow\Sun\Java\Deployment" e nell'equivalente della cartella relativa
all'utente: "C:\Users\UTENTE-LOGGATO\AppData\LocalLow\Sun\Java\Deployment";
GESTIONE POPUP JAVA
- AUTOMATICAMENTE gestisce i popup che appaiono:
- "Aggiornamento necessario" → preme TAB+TAB+ENTER;
- "Avvio applicazione in corso" → aspetta 20 secondi per l'uscita del popup di sicurezza di java poi preme
ENTER;
- In caso di popup di errore → preme ENTER per chiudere il popup e riavvia tutto il bat;
FINALIZZAZIONE
- Chiude l'interfaccia di blocco;
- Termina tutti i processi di automazione;
- Avvia il processo del directconnect.lnk da "C:\Users\Public\Documents";
- La Configurazione è completata;

3) CONFIGURAZIONE MANUALE
Se dovesse essere necessario eseguire "P4C_setup_manual.bat" che svolge le stesse operazioni del
punto 2 ma senza blocco per l'utente e con gestione manuale dei popup in modo da avere pieno controllo:

Per la corretta configurazione i popup vanno gestiti nel modo seguente:
- All’avviso dell’aggiornamento necessario selezionare “In seguito”;
- Attendere il completamento delle operazioni;
- All'apertura del popup di java che richiede conferma per eseguire il programma: Cliccare “Esegui”;

4) CONTROLLO DELLA CORRETTA ESECUZIONE:
Aprire gestione attività:
- Tasto destro sulla barra delle applicazioni
- Dal menu a tendina cliccare "Gestione attività"
- Andare nella scheda "Utenti" (se necessario espandere i processi dell'utente)
- Cercare il processo "Java(TM) Platform SE binary" (se tutto è corretto dovrebbero essercene due)
- Cliccare con il tasto destro e selezionare "proprietà"
Controllare che nel percorso ci sia jre6\bin per un processo e jre8\bin per l’altro
 
