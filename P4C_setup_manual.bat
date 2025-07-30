@echo off
setlocal enabledelayedexpansion

echo ===============================================
echo    CONFIGURAZIONE P4C - MODALITA MANUALE
echo ===============================================
echo.
echo Questo script configurera P4C senza automatismi.
echo Gestire manualmente eventuali popup Java.
echo.
set /p userChoice="Procedere con la configurazione? (s/n): "
if not "!userChoice!"=="s" if not "!userChoice!"=="S" (
    echo Configurazione annullata.
    pause
    exit /b
)
echo.

REM === TERMINAZIONE PROCESSI JAVAW ATTIVI ===
echo Terminazione processi javaw in esecuzione...
taskkill /f /im javaw.exe >nul 2>&1

REM === CONTROLLO INSTALLAZIONE JAVA 8 ===
echo.
echo === CONTROLLO INSTALLAZIONE JAVA 8 ===
echo Verifica installazione Java 8...

set "java8Found=false"

REM Controllo nel registro per Java 8
for /f "tokens=3" %%A in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Runtime Environment" /v CurrentVersion 2^>nul ^| findstr "CurrentVersion"') do (
    if "%%A"=="1.8" set "java8Found=true"
)

REM Se non trovato in HKEY_LOCAL_MACHINE, controlla in HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node
if not "%java8Found%"=="true" (
    for /f "tokens=3" %%A in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\JavaSoft\Java Runtime Environment" /v CurrentVersion 2^>nul ^| findstr "CurrentVersion"') do (
        if "%%A"=="1.8" set "java8Found=true"
    )
)

if "%java8Found%"=="false" (
    echo ATTENZIONE: Java 8 NON trovato nel sistema
    echo Si consiglia di installare Java 8 prima di continuare
    echo.
    set /p userChoice="Continuare senza Java 8? (s/n): "
    if not "!userChoice!"=="s" if not "!userChoice!"=="S" (
        echo Configurazione annullata.
        pause
        exit /b
    )
) else (
    echo Java 8 trovato nel sistema - OK
)

REM === COPIA FILE IN C:\P4C ===
echo.
echo === COPIA FILE IN C:\P4C ===
if not exist "C:\P4C" mkdir "C:\P4C"
echo Copiando file nella cartella C:\P4C...

REM Lista file da copiare
set files=galileo.bat galileo.jnlp guida.txt Icona_Galileo.ico deployment.properties tinyserver.jnlp sfondo_popup.png favicon.png
for %%f in (%files%) do (
    if exist "%~dp0%%f" (
        copy "%~dp0%%f" "C:\P4C\" >nul 2>&1
        if exist "C:\P4C\%%f" (
            echo   [OK] %%f copiato
        ) else (
            echo   [ERROR] Errore copia %%f
        )
    ) else (
        echo   [SKIP] %%f non trovato nella cartella di origine
    )
)

REM === RIMOZIONE FILE GALILEO PRECEDENTI ===
echo.
echo === RIMOZIONE FILE GALILEO PRECEDENTI ===
echo Rimozione file galileo precedenti dal Desktop...

REM Elimina file galileo.jnlp dal Desktop
if exist "%USERPROFILE%\Desktop\galileo.jnlp" (
    del "%USERPROFILE%\Desktop\galileo.jnlp" >nul 2>&1
    echo   [OK] galileo.jnlp rimosso dal Desktop
)

REM Elimina file con nome galileo (senza estensione) dal Desktop
if exist "%USERPROFILE%\Desktop\galileo" (
    del "%USERPROFILE%\Desktop\galileo" >nul 2>&1
    echo   [OK] galileo rimosso dal Desktop
)

REM === CREAZIONE COLLEGAMENTO GALILEO ===
echo.
echo === CREAZIONE COLLEGAMENTO GALILEO ===
echo Creazione collegamento galileo.bat sul Desktop...

REM Crea script VBS temporaneo per creare il collegamento
echo Set objShell = CreateObject("WScript.Shell") > "%TEMP%\create_shortcut.vbs"
echo Set objShortcut = objShell.CreateShortcut("%USERPROFILE%\Desktop\galileo.lnk") >> "%TEMP%\create_shortcut.vbs"
echo objShortcut.TargetPath = "C:\P4C\galileo.bat" >> "%TEMP%\create_shortcut.vbs"
echo objShortcut.WorkingDirectory = "C:\P4C" >> "%TEMP%\create_shortcut.vbs"
echo objShortcut.IconLocation = "C:\P4C\Icona_Galileo.ico" >> "%TEMP%\create_shortcut.vbs"
echo objShortcut.Description = "Avvia Galileo P4C" >> "%TEMP%\create_shortcut.vbs"
echo objShortcut.Save >> "%TEMP%\create_shortcut.vbs"

REM Esegui lo script VBS
cscript.exe //nologo "%TEMP%\create_shortcut.vbs"
if exist "%USERPROFILE%\Desktop\galileo.lnk" (
    echo   [OK] Collegamento galileo.lnk creato sul Desktop
) else (
    echo   [ERROR] Errore nella creazione del collegamento
)

REM Pulisci file temporaneo
del "%TEMP%\create_shortcut.vbs" >nul 2>&1

REM === AVVIO SISTEMA TRAY JAVA8 ===
echo.
echo === CONFIGURAZIONE SISTEMA TRAY JAVA8 ===
echo Configurazione sistema tray per monitoraggio Java 8...

REM Crea script PowerShell per system tray
echo Add-Type -AssemblyName System.Windows.Forms > "C:\P4C\java8_tray_monitor.ps1"
echo Add-Type -AssemblyName System.Drawing >> "C:\P4C\java8_tray_monitor.ps1"
echo. >> "C:\P4C\java8_tray_monitor.ps1"
echo # Crea icona system tray >> "C:\P4C\java8_tray_monitor.ps1"
echo $notifyIcon = New-Object System.Windows.Forms.NotifyIcon >> "C:\P4C\java8_tray_monitor.ps1"
echo. >> "C:\P4C\java8_tray_monitor.ps1"
echo # Carica icona (prima prova favicon.png, poi Icona_Galileo.ico come fallback) >> "C:\P4C\java8_tray_monitor.ps1"
echo try { >> "C:\P4C\java8_tray_monitor.ps1"
echo     if (Test-Path "C:\P4C\favicon.png") { >> "C:\P4C\java8_tray_monitor.ps1"
echo         $bitmap = New-Object System.Drawing.Bitmap("C:\P4C\favicon.png") >> "C:\P4C\java8_tray_monitor.ps1"
echo         $notifyIcon.Icon = [System.Drawing.Icon]::FromHandle($bitmap.GetHicon()) >> "C:\P4C\java8_tray_monitor.ps1"
echo     } elseif (Test-Path "C:\P4C\Icona_Galileo.ico") { >> "C:\P4C\java8_tray_monitor.ps1"
echo         $notifyIcon.Icon = New-Object System.Drawing.Icon("C:\P4C\Icona_Galileo.ico") >> "C:\P4C\java8_tray_monitor.ps1"
echo     } else { >> "C:\P4C\java8_tray_monitor.ps1"
echo         # Icona predefinita di sistema >> "C:\P4C\java8_tray_monitor.ps1"
echo         $notifyIcon.Icon = [System.Drawing.SystemIcons]::Information >> "C:\P4C\java8_tray_monitor.ps1"
echo     } >> "C:\P4C\java8_tray_monitor.ps1"
echo } catch { >> "C:\P4C\java8_tray_monitor.ps1"
echo     $notifyIcon.Icon = [System.Drawing.SystemIcons]::Information >> "C:\P4C\java8_tray_monitor.ps1"
echo } >> "C:\P4C\java8_tray_monitor.ps1"
echo. >> "C:\P4C\java8_tray_monitor.ps1"
echo $notifyIcon.Text = "Java8" >> "C:\P4C\java8_tray_monitor.ps1"
echo $notifyIcon.Visible = $false >> "C:\P4C\java8_tray_monitor.ps1"
echo. >> "C:\P4C\java8_tray_monitor.ps1"
echo # Loop di monitoraggio >> "C:\P4C\java8_tray_monitor.ps1"
echo while ($true) { >> "C:\P4C\java8_tray_monitor.ps1"
echo     try { >> "C:\P4C\java8_tray_monitor.ps1"
echo         # Controlla specificamente processi Java 8 (non tutti i javaw) >> "C:\P4C\java8_tray_monitor.ps1"
echo         $java8Found = $false >> "C:\P4C\java8_tray_monitor.ps1"
echo         $javawProcesses = Get-Process -Name "javaw" -ErrorAction SilentlyContinue >> "C:\P4C\java8_tray_monitor.ps1"
echo         foreach ($process in $javawProcesses) { >> "C:\P4C\java8_tray_monitor.ps1"
echo             try { >> "C:\P4C\java8_tray_monitor.ps1"
echo                 $processPath = $process.Path >> "C:\P4C\java8_tray_monitor.ps1"
echo                 if ($processPath -like "*jre8*" -or $processPath -like "*1.8*") { >> "C:\P4C\java8_tray_monitor.ps1"
echo                     $java8Found = $true >> "C:\P4C\java8_tray_monitor.ps1"
echo                     break >> "C:\P4C\java8_tray_monitor.ps1"
echo                 } >> "C:\P4C\java8_tray_monitor.ps1"
echo             } catch { >> "C:\P4C\java8_tray_monitor.ps1"
echo                 # Se non riesce a ottenere il path, assume sia Java 8 >> "C:\P4C\java8_tray_monitor.ps1"
echo                 $java8Found = $true >> "C:\P4C\java8_tray_monitor.ps1"
echo                 break >> "C:\P4C\java8_tray_monitor.ps1"
echo             } >> "C:\P4C\java8_tray_monitor.ps1"
echo         } >> "C:\P4C\java8_tray_monitor.ps1"
echo         >> "C:\P4C\java8_tray_monitor.ps1"
echo         if ($java8Found) { >> "C:\P4C\java8_tray_monitor.ps1"
echo             if (-not $notifyIcon.Visible) { >> "C:\P4C\java8_tray_monitor.ps1"
echo                 $notifyIcon.Visible = $true >> "C:\P4C\java8_tray_monitor.ps1"
echo             } >> "C:\P4C\java8_tray_monitor.ps1"
echo         } else { >> "C:\P4C\java8_tray_monitor.ps1"
echo             if ($notifyIcon.Visible) { >> "C:\P4C\java8_tray_monitor.ps1"
echo                 $notifyIcon.Visible = $false >> "C:\P4C\java8_tray_monitor.ps1"
echo             } >> "C:\P4C\java8_tray_monitor.ps1"
echo         } >> "C:\P4C\java8_tray_monitor.ps1"
echo     } catch { >> "C:\P4C\java8_tray_monitor.ps1"
echo         # Ignora errori >> "C:\P4C\java8_tray_monitor.ps1"
echo     } >> "C:\P4C\java8_tray_monitor.ps1"
echo     >> "C:\P4C\java8_tray_monitor.ps1"
echo     Start-Sleep -Seconds 3 >> "C:\P4C\java8_tray_monitor.ps1"
echo } >> "C:\P4C\java8_tray_monitor.ps1"

echo   [OK] Script tray Java8 creato in C:\P4C\java8_tray_monitor.ps1

REM Avvia il sistema tray automaticamente
start /min "" powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\P4C\java8_tray_monitor.ps1"
echo   [OK] Sistema tray Java8 avviato

REM === CONFIGURAZIONE DEPLOYMENT PROPERTIES ===
echo.
echo === CONFIGURAZIONE DEPLOYMENT PROPERTIES ===
echo Configurazione deployment.properties Java...

REM Configura deployment properties per utente corrente e Default
set "deployment_folder_default=C:\Users\Default\AppData\LocalLow\Sun\Java\Deployment"
set "deployment_folder_current=%USERPROFILE%\AppData\LocalLow\Sun\Java\Deployment"

if not exist "%deployment_folder_default%" mkdir "%deployment_folder_default%" >nul 2>&1
if not exist "%deployment_folder_current%" mkdir "%deployment_folder_current%" >nul 2>&1

if exist "C:\P4C\deployment.properties" (
    copy "C:\P4C\deployment.properties" "%deployment_folder_default%\" >nul 2>&1
    copy "C:\P4C\deployment.properties" "%deployment_folder_current%\" >nul 2>&1
    echo   [OK] deployment.properties configurato
) else (
    echo   [SKIP] deployment.properties non trovato
)

REM === CONFIGURAZIONE COMPLETATA ===
echo.
echo ===============================================
echo    CONFIGURAZIONE P4C COMPLETATA
echo ===============================================
echo.
echo RIEPILOGO OPERAZIONI:
echo - File copiati in C:\P4C
echo - Collegamento galileo.lnk creato sul Desktop  
echo - Sistema tray Java8 avviato automaticamente
echo - Configurazione deployment properties completata
echo.
echo NOTA: L'icona Java8 apparirà nel system tray SOLO quando 
echo       processi Java 8 sono attivi (non altre versioni Java).
echo.
pause

endlocal
echo [STEP 1/7] Configurazione ambiente di sicurezza...
timeout /t 2 /nobreak >nul
timeout /t 2 /nobreak >nul

REM === STEP 20: TERMINAZIONE PROCESSI JAVAWS ATTIVI ===
echo [STEP 2/7] Pulizia processi Java esistenti...
set "javaws_found=false"

REM Cerca tutti i processi javaws.exe e salva i PID
for /f "tokens=2 delims=," %%a in ('tasklist /fi "imagename eq javaw.exe" /fo csv /nh 2^>nul') do (
    if not "%%a"=="" (
        set "javaws_found=true"
        taskkill /PID %%a /f >nul 2>&1
    )
)

if "%javaws_found%"=="true" (
    timeout /t 2 /nobreak >nul
)

REM === STEP 30: PREPARAZIONE CARTELLE ===
echo [STEP 3/7] Configurazione cartelle di sistema...

REM Imposta la versione desiderata di Java
set "java_version=jre8"

REM Definisci i percorsi per le cartelle e i file
set "p4c_folder=C:\P4C"
set "galileo_folder=C:\Galileo"
set "p4c_jnlp_source=%~dp0tinyserver.jnlp"
set "galileo_jnlp_source=%~dp0galileo.jnlp"
set "p4c_jnlp_dest=%p4c_folder%\tinyserver.jnlp"
set "galileo_jnlp_dest=%galileo_folder%\galileo.jnlp"

REM Crea le cartelle
if not exist "%p4c_folder%" mkdir "%p4c_folder%" >nul 2>&1
if not exist "%galileo_folder%" mkdir "%galileo_folder%" >nul 2>&1

REM Copia i file JNLP
if exist "%p4c_jnlp_source%" copy "%p4c_jnlp_source%" "%p4c_jnlp_dest%" >nul 2>&1
if exist "%galileo_jnlp_source%" copy "%galileo_jnlp_source%" "%galileo_jnlp_dest%" >nul 2>&1

REM === STEP 40: CONFIGURAZIONE JAVA DEPLOYMENT ===
echo [STEP 4/6] Configurazione Java deployment...

REM Copia il file deployment.properties nella cartella di deployment di Java
set "deployment_source=%~dp0deployment.properties"
set "deployment_folder_default=C:\Users\Default\AppData\LocalLow\Sun\Java\Deployment"
set "deployment_folder_current=%USERPROFILE%\AppData\LocalLow\Sun\Java\Deployment"
set "deployment_dest_default=%deployment_folder_default%\deployment.properties"
set "deployment_dest_current=%deployment_folder_current%\deployment.properties"

if exist "%deployment_source%" (
    copy "%deployment_source%" "%deployment_dest_default%" /Y >nul 2>&1
    copy "%deployment_source%" "%deployment_dest_current%" /Y >nul 2>&1
)

REM === STEP 50: AVVIO APPLICAZIONI JAVA ===
echo [STEP 5/6] Avvio applicazioni Java...
echo.
echo ATTENZIONE: Gestire manualmente eventuali popup Java che appariranno.
echo Cliccare su "Esegui" o "OK" quando richiesto.
echo.

REM Imposta la versione desiderata di Java
set "java_version=jre8"

REM Trova la versione di Java installata che contiene la stringa jre8 nel percorso
set "java_path="
for /d %%i in ("C:\Program Files (x86)\Java\*") do (
    if "%%~nxi" equ "jre8" (
        set "java_path=C:\Program Files (x86)\Java\jre8\bin\javaws.exe" 
        goto :BreakLoop
    )
)
:BreakLoop

REM Se il percorso di Java è stato trovato, esegui il comando
if defined java_path (
    echo Avvio P4C con Java 8...
    "%java_path%" "C:\P4C\tinyserver.jnlp"
) else (
    echo ATTENZIONE: Java 8 non trovato. Tentativo con Java predefinito...
    javaws "C:\P4C\tinyserver.jnlp"
)

echo [STEP 6/6] Avvio applicazione DirectConnect...
"C:\Program Files (x86)\Java\jre6\bin\javaws" -Xnosplash \\SRV-FS01\Link-ICT\Hitech\direct-connect.jnlp
del /Y %homepath%\Desktop\directconnect.lnk >nul 2>&1

echo.
echo ===============================================
echo    INSTALLAZIONE P4C COMPLETATA
echo ===============================================
echo.
echo L'installazione e stata completata con successo.
echo Le applicazioni Java sono state avviate.
echo.
echo Gestire manualmente eventuali popup Java rimanenti.
echo.
pause

endlocal
-----