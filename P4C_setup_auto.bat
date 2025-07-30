@echo off > NUL

REM === NASCONDI FINESTRA BAT ===
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class Win32 { [DllImport(\"user32.dll\")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow); [DllImport(\"kernel32.dll\")] public static extern IntPtr GetConsoleWindow(); }'; $hwnd = [Win32]::GetConsoleWindow(); [Win32]::ShowWindow($hwnd, 0)" >nul 2>&1

setlocal enabledelayedexpansion

REM === AVVIO IMMEDIATO BLOCCO UTENTE ===
echo Avvio interfaccia di blocco utente...

REM Crea flag di controllo per il blocco
echo running > "%TEMP%\p4c_installation_running.flag"

REM Crea script PowerShell per bloccare l'interfaccia utente
echo Add-Type -AssemblyName System.Windows.Forms > "%TEMP%\block_user_interface.ps1"
echo Add-Type -AssemblyName System.Drawing >> "%TEMP%\block_user_interface.ps1"
echo. >> "%TEMP%\block_user_interface.ps1"
echo # Crea finestra di blocco a schermo intero >> "%TEMP%\block_user_interface.ps1"
echo $form = New-Object System.Windows.Forms.Form >> "%TEMP%\block_user_interface.ps1"
echo $form.Text = "INSTALLAZIONE P4C IN CORSO..." >> "%TEMP%\block_user_interface.ps1"
echo $form.FormBorderStyle = "None" >> "%TEMP%\block_user_interface.ps1"
echo $form.WindowState = "Normal" >> "%TEMP%\block_user_interface.ps1"
echo $screenBounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds >> "%TEMP%\block_user_interface.ps1"
echo $form.Size = $screenBounds.Size >> "%TEMP%\block_user_interface.ps1"
echo $form.Location = New-Object System.Drawing.Point(0, 0) >> "%TEMP%\block_user_interface.ps1"
echo $form.StartPosition = "Manual" >> "%TEMP%\block_user_interface.ps1"
echo $form.TopMost = $true >> "%TEMP%\block_user_interface.ps1"
echo $form.MaximizeBox = $false >> "%TEMP%\block_user_interface.ps1"
echo $form.MinimizeBox = $false >> "%TEMP%\block_user_interface.ps1"
echo $form.ControlBox = $false >> "%TEMP%\block_user_interface.ps1"
echo $form.ShowInTaskbar = $true >> "%TEMP%\block_user_interface.ps1"
echo # Imposta immagine di sfondo se esiste (cerca prima in C:\P4C poi nella cartella originale) >> "%TEMP%\block_user_interface.ps1"
echo $backgroundImagePath = "C:\P4C\sfondo_popup.png" >> "%TEMP%\block_user_interface.ps1"
echo if (-not (Test-Path $backgroundImagePath)) { $backgroundImagePath = "%~dp0sfondo_popup.png" } >> "%TEMP%\block_user_interface.ps1"
echo if (Test-Path $backgroundImagePath) { >> "%TEMP%\block_user_interface.ps1"
echo     try { >> "%TEMP%\block_user_interface.ps1"
echo         $form.BackgroundImage = [System.Drawing.Image]::FromFile($backgroundImagePath) >> "%TEMP%\block_user_interface.ps1"
echo         $form.BackgroundImageLayout = "Stretch" >> "%TEMP%\block_user_interface.ps1"
echo     } catch { >> "%TEMP%\block_user_interface.ps1"
echo         $form.BackColor = [System.Drawing.Color]::FromArgb(62, 130, 194) >> "%TEMP%\block_user_interface.ps1"
echo     } >> "%TEMP%\block_user_interface.ps1"
echo } else { >> "%TEMP%\block_user_interface.ps1"
echo     $form.BackColor = [System.Drawing.Color]::FromArgb(62, 130, 194) >> "%TEMP%\block_user_interface.ps1"
echo } >> "%TEMP%\block_user_interface.ps1"
echo. >> "%TEMP%\block_user_interface.ps1"
echo # Mantiene sempre la finestra in primo piano e forza fullscreen >> "%TEMP%\block_user_interface.ps1"
echo $form.Add_Shown({ >> "%TEMP%\block_user_interface.ps1"
echo     $form.WindowState = "Normal" >> "%TEMP%\block_user_interface.ps1"
echo     $form.FormBorderStyle = "None" >> "%TEMP%\block_user_interface.ps1"
echo     $form.Size = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Size >> "%TEMP%\block_user_interface.ps1"
echo     $form.Location = New-Object System.Drawing.Point(0, 0) >> "%TEMP%\block_user_interface.ps1"
echo     $form.TopMost = $true >> "%TEMP%\block_user_interface.ps1"
echo     $form.Activate() >> "%TEMP%\block_user_interface.ps1"
echo     $form.BringToFront() >> "%TEMP%\block_user_interface.ps1"
echo }) >> "%TEMP%\block_user_interface.ps1"
echo. >> "%TEMP%\block_user_interface.ps1"
echo # Previene perdita di focus - torna sempre in primo piano >> "%TEMP%\block_user_interface.ps1"
echo $form.Add_Deactivate({ >> "%TEMP%\block_user_interface.ps1"
echo     $form.TopMost = $true >> "%TEMP%\block_user_interface.ps1"
echo     $form.Activate() >> "%TEMP%\block_user_interface.ps1"
echo     $form.BringToFront() >> "%TEMP%\block_user_interface.ps1"
echo }) >> "%TEMP%\block_user_interface.ps1"
echo. >> "%TEMP%\block_user_interface.ps1"
echo # Etichetta principale >> "%TEMP%\block_user_interface.ps1"
echo $label = New-Object System.Windows.Forms.Label >> "%TEMP%\block_user_interface.ps1"
echo $label.Text = "CONFIGURAZIONE P4C IN CORSO`n`n`nIL PROCESSO TERMINERA' AUTOMATICAMENTE`n`nATTENDERE IL COMPLETAMENTO`n`nCi vorra' circa un minuto..." >> "%TEMP%\block_user_interface.ps1"
echo $screenWidth = $screenBounds.Width >> "%TEMP%\block_user_interface.ps1"
echo $screenHeight = $screenBounds.Height >> "%TEMP%\block_user_interface.ps1"
echo $label.Size = New-Object System.Drawing.Size(($screenWidth - 100), 300) >> "%TEMP%\block_user_interface.ps1"
echo $label.Location = New-Object System.Drawing.Point(50, ($screenHeight / 2 - 250)) >> "%TEMP%\block_user_interface.ps1"
echo $label.Font = New-Object System.Drawing.Font("Arial", 16, [System.Drawing.FontStyle]::Bold) >> "%TEMP%\block_user_interface.ps1"
echo $label.TextAlign = "MiddleCenter" >> "%TEMP%\block_user_interface.ps1"
echo $label.ForeColor = [System.Drawing.Color]::White >> "%TEMP%\block_user_interface.ps1"
echo $label.BackColor = [System.Drawing.Color]::Transparent >> "%TEMP%\block_user_interface.ps1"
echo $form.Controls.Add($label) >> "%TEMP%\block_user_interface.ps1"
echo. >> "%TEMP%\block_user_interface.ps1"
echo # Progress bar animata >> "%TEMP%\block_user_interface.ps1"
echo $progressBar = New-Object System.Windows.Forms.ProgressBar >> "%TEMP%\block_user_interface.ps1"
echo $progressBar.Size = New-Object System.Drawing.Size(($screenWidth - 100), 40) >> "%TEMP%\block_user_interface.ps1"
echo $progressBar.Location = New-Object System.Drawing.Point(50, ($screenHeight / 2 + 50)) >> "%TEMP%\block_user_interface.ps1"
echo $progressBar.Style = "Marquee" >> "%TEMP%\block_user_interface.ps1"
echo $progressBar.MarqueeAnimationSpeed = 40 >> "%TEMP%\block_user_interface.ps1"
echo $progressBar.Minimum = 0 >> "%TEMP%\block_user_interface.ps1"
echo $progressBar.Maximum = 100 >> "%TEMP%\block_user_interface.ps1"
echo $progressBar.Value = 0 >> "%TEMP%\block_user_interface.ps1"
echo $progressBar.ForeColor = [System.Drawing.Color]::FromArgb(213, 226, 239) >> "%TEMP%\block_user_interface.ps1"
echo $progressBar.BackColor = [System.Drawing.Color]::FromArgb(18, 80, 146) >> "%TEMP%\block_user_interface.ps1"
echo $form.Controls.Add($progressBar) >> "%TEMP%\block_user_interface.ps1"
echo. >> "%TEMP%\block_user_interface.ps1"
echo # Label per status >> "%TEMP%\block_user_interface.ps1"
echo $statusLabel = New-Object System.Windows.Forms.Label >> "%TEMP%\block_user_interface.ps1"
echo $statusLabel.Text = "CONFIGURAZIONE SISTEMA E GESTIONE AUTOMATICA POPUP JAVA..." >> "%TEMP%\block_user_interface.ps1"
echo $statusLabel.Size = New-Object System.Drawing.Size(($screenWidth - 100), 60) >> "%TEMP%\block_user_interface.ps1"
echo $statusLabel.Location = New-Object System.Drawing.Point(50, ($screenHeight / 2 + 120)) >> "%TEMP%\block_user_interface.ps1"
echo $statusLabel.Font = New-Object System.Drawing.Font("Arial", 12) >> "%TEMP%\block_user_interface.ps1"
echo $statusLabel.TextAlign = "MiddleCenter" >> "%TEMP%\block_user_interface.ps1"
echo $statusLabel.ForeColor = [System.Drawing.Color]::White >> "%TEMP%\block_user_interface.ps1"
echo $statusLabel.BackColor = [System.Drawing.Color]::Transparent >> "%TEMP%\block_user_interface.ps1"
echo $form.Controls.Add($statusLabel) >> "%TEMP%\block_user_interface.ps1"
echo. >> "%TEMP%\block_user_interface.ps1"
echo # Etichetta di avviso con bordi arrotondati >> "%TEMP%\block_user_interface.ps1"
echo $warningLabel = New-Object System.Windows.Forms.Label >> "%TEMP%\block_user_interface.ps1"
echo $warningLabel.Text = "ATTENZIONE: SE NECESSARIO CLICCARE  ""ESEGUI"" AL TERMINE!" >> "%TEMP%\block_user_interface.ps1"
echo $warningLabel.Size = New-Object System.Drawing.Size(($screenWidth - 100), 80) >> "%TEMP%\block_user_interface.ps1"
echo $warningLabel.Location = New-Object System.Drawing.Point(50, ($screenHeight / 2 + 200)) >> "%TEMP%\block_user_interface.ps1"
echo $warningLabel.Font = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Bold) >> "%TEMP%\block_user_interface.ps1"
echo $warningLabel.TextAlign = "MiddleCenter" >> "%TEMP%\block_user_interface.ps1"
echo $warningLabel.ForeColor = [System.Drawing.Color]::Black >> "%TEMP%\block_user_interface.ps1"
echo $warningLabel.BackColor = [System.Drawing.Color]::FromArgb(247, 166, 0) >> "%TEMP%\block_user_interface.ps1"
echo. >> "%TEMP%\block_user_interface.ps1"
echo # Crea bordi arrotondati usando Region >> "%TEMP%\block_user_interface.ps1"
echo $radius = 60 >> "%TEMP%\block_user_interface.ps1"
echo $rect = New-Object System.Drawing.Rectangle(0, 0, $warningLabel.Width, $warningLabel.Height) >> "%TEMP%\block_user_interface.ps1"
echo $path = New-Object System.Drawing.Drawing2D.GraphicsPath >> "%TEMP%\block_user_interface.ps1"
echo $path.AddArc($rect.X, $rect.Y, $radius, $radius, 180, 90) >> "%TEMP%\block_user_interface.ps1"
echo $path.AddArc($rect.Right - $radius, $rect.Y, $radius, $radius, 270, 90) >> "%TEMP%\block_user_interface.ps1"
echo $path.AddArc($rect.Right - $radius, $rect.Bottom - $radius, $radius, $radius, 0, 90) >> "%TEMP%\block_user_interface.ps1"
echo $path.AddArc($rect.X, $rect.Bottom - $radius, $radius, $radius, 90, 90) >> "%TEMP%\block_user_interface.ps1"
echo $path.CloseFigure() >> "%TEMP%\block_user_interface.ps1"
echo $warningLabel.Region = New-Object System.Drawing.Region($path) >> "%TEMP%\block_user_interface.ps1"
echo. >> "%TEMP%\block_user_interface.ps1"
echo $form.Controls.Add($warningLabel) >> "%TEMP%\block_user_interface.ps1"
echo. >> "%TEMP%\block_user_interface.ps1"
echo # Variabile per scorciatoia di emergenza (Ctrl+O) >> "%TEMP%\block_user_interface.ps1"
echo $emergencyExit = $false >> "%TEMP%\block_user_interface.ps1"
echo. >> "%TEMP%\block_user_interface.ps1"
echo # Variabili per progress bar basata su tempo >> "%TEMP%\block_user_interface.ps1"
echo $startTime = Get-Date >> "%TEMP%\block_user_interface.ps1"
echo $totalDurationSeconds = 45 >> "%TEMP%\block_user_interface.ps1"
echo $progressBarContinuous = $false >> "%TEMP%\block_user_interface.ps1"
echo. >> "%TEMP%\block_user_interface.ps1"
echo # Timer per controllare il flag di uscita e mantenere priorità >> "%TEMP%\block_user_interface.ps1"
echo $timer = New-Object System.Windows.Forms.Timer >> "%TEMP%\block_user_interface.ps1"
echo $timer.Interval = 500 >> "%TEMP%\block_user_interface.ps1"
echo $timer.Add_Tick({ >> "%TEMP%\block_user_interface.ps1"
echo     # PRIORITA MASSIMA: Controlla flag di emergenza >> "%TEMP%\block_user_interface.ps1"
echo     if (Test-Path "%TEMP%\p4c_emergency_stop.flag") { >> "%TEMP%\block_user_interface.ps1"
echo         $script:emergencyExit = $true >> "%TEMP%\block_user_interface.ps1"
echo         $form.Close() >> "%TEMP%\block_user_interface.ps1"
echo         return >> "%TEMP%\block_user_interface.ps1"
echo     } >> "%TEMP%\block_user_interface.ps1"
echo     >> "%TEMP%\block_user_interface.ps1"
echo     # Controlla se deve chiudere >> "%TEMP%\block_user_interface.ps1"
echo     if (-not (Test-Path "%TEMP%\p4c_installation_running.flag")) { >> "%TEMP%\block_user_interface.ps1"
echo         $form.Close() >> "%TEMP%\block_user_interface.ps1"
echo         return >> "%TEMP%\block_user_interface.ps1"
echo     } >> "%TEMP%\block_user_interface.ps1"
echo     >> "%TEMP%\block_user_interface.ps1"
echo     # Mantiene sempre la finestra in primo piano >> "%TEMP%\block_user_interface.ps1"
echo     try { >> "%TEMP%\block_user_interface.ps1"
echo         $form.TopMost = $true >> "%TEMP%\block_user_interface.ps1"
echo         $form.BringToFront() >> "%TEMP%\block_user_interface.ps1"
echo         >> "%TEMP%\block_user_interface.ps1"
echo         # Aggiorna messaggio basato sui processi attivi >> "%TEMP%\block_user_interface.ps1"
echo         $javawProcesses = Get-Process -Name "javaw" -ErrorAction SilentlyContinue >> "%TEMP%\block_user_interface.ps1"
echo         >> "%TEMP%\block_user_interface.ps1"
echo         # Controlla il file di fase per aggiornare il messaggio e calcola progress basato su tempo >> "%TEMP%\block_user_interface.ps1"
echo         $currentTime = Get-Date >> "%TEMP%\block_user_interface.ps1"
echo         $elapsedSeconds = ($currentTime - $script:startTime).TotalSeconds >> "%TEMP%\block_user_interface.ps1"
echo         $progressPercent = [Math]::Min(100, ($elapsedSeconds / $script:totalDurationSeconds) * 100) >> "%TEMP%\block_user_interface.ps1"
echo         >> "%TEMP%\block_user_interface.ps1"
echo         # Aggiorna progress bar a modalità continua >> "%TEMP%\block_user_interface.ps1"
echo         if (-not $script:progressBarContinuous) { >> "%TEMP%\block_user_interface.ps1"
echo             $script:progressBar.Style = "Continuous" >> "%TEMP%\block_user_interface.ps1"
echo             $script:progressBarContinuous = $true >> "%TEMP%\block_user_interface.ps1"
echo         } >> "%TEMP%\block_user_interface.ps1"
echo         >> "%TEMP%\block_user_interface.ps1"
echo         $script:progressBar.Value = [int]$progressPercent >> "%TEMP%\block_user_interface.ps1"
echo         $script:progressBar.Refresh() >> "%TEMP%\block_user_interface.ps1"
echo         >> "%TEMP%\block_user_interface.ps1"
echo         # Aggiorna messaggio in base alla fase corrente se disponibile >> "%TEMP%\block_user_interface.ps1"
echo         if (Test-Path "%TEMP%\p4c_phase.txt") { >> "%TEMP%\block_user_interface.ps1"
echo             try { >> "%TEMP%\block_user_interface.ps1"
echo                 $phaseContent = Get-Content "%TEMP%\p4c_phase.txt" -ErrorAction SilentlyContinue >> "%TEMP%\block_user_interface.ps1"
echo                 if ($phaseContent) { >> "%TEMP%\block_user_interface.ps1"
echo                     $script:statusLabel.Text = $phaseContent >> "%TEMP%\block_user_interface.ps1"
echo                 } >> "%TEMP%\block_user_interface.ps1"
echo             } catch { } >> "%TEMP%\block_user_interface.ps1"
echo         } elseif ($javawProcesses) { >> "%TEMP%\block_user_interface.ps1"
echo             $script:statusLabel.Text = "POPUP JAVA RILEVATI - GESTIONE AUTOMATICA IN CORSO..." >> "%TEMP%\block_user_interface.ps1"
echo             $script:statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(213, 226, 239) >> "%TEMP%\block_user_interface.ps1"
echo         } else { >> "%TEMP%\block_user_interface.ps1"
echo             # Se non ci sono fasi specifiche e non ci sono processi Java, usa messaggio default >> "%TEMP%\block_user_interface.ps1"
echo             if (-not (Test-Path "%TEMP%\p4c_phase.txt")) { >> "%TEMP%\block_user_interface.ps1"
echo                 $script:statusLabel.Text = "CONFIGURAZIONE SISTEMA E GESTIONE AUTOMATICA POPUP JAVA..." >> "%TEMP%\block_user_interface.ps1"
echo             } >> "%TEMP%\block_user_interface.ps1"
echo         } >> "%TEMP%\block_user_interface.ps1"
echo         >> "%TEMP%\block_user_interface.ps1"
echo         # Assicura sempre il colore corretto >> "%TEMP%\block_user_interface.ps1"
echo         $script:statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(213, 226, 239) >> "%TEMP%\block_user_interface.ps1"
echo     } catch { >> "%TEMP%\block_user_interface.ps1"
echo         # Ignora errori >> "%TEMP%\block_user_interface.ps1"
echo     } >> "%TEMP%\block_user_interface.ps1"
echo }) >> "%TEMP%\block_user_interface.ps1"
echo $timer.Start() >> "%TEMP%\block_user_interface.ps1"
echo. >> "%TEMP%\block_user_interface.ps1"
echo # Gestione tasti per scorciatoia di emergenza (Ctrl+O) e blocco altre combinazioni >> "%TEMP%\block_user_interface.ps1"
echo $form.Add_KeyDown({ >> "%TEMP%\block_user_interface.ps1"
echo     param($sender, $e) >> "%TEMP%\block_user_interface.ps1"
echo     >> "%TEMP%\block_user_interface.ps1"
echo     # SCORCIATOIA DI EMERGENZA: Ctrl+O per uscita immediata >> "%TEMP%\block_user_interface.ps1"
echo     if ($e.Control -and $e.KeyCode -eq "O") { >> "%TEMP%\block_user_interface.ps1"
echo         $script:emergencyExit = $true >> "%TEMP%\block_user_interface.ps1"
echo         Write-Host "SCORCIATOIA DI EMERGENZA ATTIVATA - ARRESTO IMMEDIATO" >> "%TEMP%\block_user_interface.ps1"
echo         >> "%TEMP%\block_user_interface.ps1"
echo         # Crea flag di emergenza per arresto BAT >> "%TEMP%\block_user_interface.ps1"
echo         try { >> "%TEMP%\block_user_interface.ps1"
echo             "emergency_stop" ^| Out-File -FilePath "%TEMP%\p4c_emergency_stop.flag" -Encoding ASCII >> "%TEMP%\block_user_interface.ps1"
echo         } catch { } >> "%TEMP%\block_user_interface.ps1"
echo         >> "%TEMP%\block_user_interface.ps1"
echo         # Termina IMMEDIATAMENTE tutti i processi correlati >> "%TEMP%\block_user_interface.ps1"
echo         try { >> "%TEMP%\block_user_interface.ps1"
echo             # Termina processi javaw >> "%TEMP%\block_user_interface.ps1"
echo             Get-Process -Name "javaw" -ErrorAction SilentlyContinue ^| Stop-Process -Force >> "%TEMP%\block_user_interface.ps1"
echo             # Termina script VBS popup handler >> "%TEMP%\block_user_interface.ps1"
echo             Get-Process -Name "cscript" -ErrorAction SilentlyContinue ^| Stop-Process -Force >> "%TEMP%\block_user_interface.ps1"
echo             Get-Process -Name "wscript" -ErrorAction SilentlyContinue ^| Stop-Process -Force >> "%TEMP%\block_user_interface.ps1"
echo             # Termina processi PowerShell di automazione (eccetto questo) >> "%TEMP%\block_user_interface.ps1"
echo             $currentPid = $PID >> "%TEMP%\block_user_interface.ps1"
echo             Get-Process -Name "powershell" -ErrorAction SilentlyContinue ^| Where-Object { $_.Id -ne $currentPid } ^| Stop-Process -Force >> "%TEMP%\block_user_interface.ps1"
echo             # Termina processi batch P4C_setup >> "%TEMP%\block_user_interface.ps1"
echo             Get-Process -Name "cmd" -ErrorAction SilentlyContinue ^| Where-Object { $_.CommandLine -like "*P4C_setup*" } ^| Stop-Process -Force >> "%TEMP%\block_user_interface.ps1"
echo         } catch { } >> "%TEMP%\block_user_interface.ps1"
echo         >> "%TEMP%\block_user_interface.ps1"
echo         # Rimuovi tutti i flag >> "%TEMP%\block_user_interface.ps1"
echo         try { >> "%TEMP%\block_user_interface.ps1"
echo             Remove-Item "%TEMP%\p4c_installation_running.flag" -Force -ErrorAction SilentlyContinue >> "%TEMP%\block_user_interface.ps1"
echo             Remove-Item "%TEMP%\p4c_finalizing.flag" -Force -ErrorAction SilentlyContinue >> "%TEMP%\block_user_interface.ps1"
echo             Remove-Item "%TEMP%\p4c_restart_needed.flag" -Force -ErrorAction SilentlyContinue >> "%TEMP%\block_user_interface.ps1"
echo         } catch { } >> "%TEMP%\block_user_interface.ps1"
echo         >> "%TEMP%\block_user_interface.ps1"
echo         # Chiudi finestra immediatamente >> "%TEMP%\block_user_interface.ps1"
echo         $form.Close() >> "%TEMP%\block_user_interface.ps1"
echo         return >> "%TEMP%\block_user_interface.ps1"
echo     } >> "%TEMP%\block_user_interface.ps1"
echo     >> "%TEMP%\block_user_interface.ps1"
echo     # Blocca Ctrl+W, Ctrl+F4, Alt+F4 e altre combinazioni pericolose >> "%TEMP%\block_user_interface.ps1"
echo     if (($e.Control -and $e.KeyCode -eq "W") -or >> "%TEMP%\block_user_interface.ps1"
echo         ($e.Control -and $e.KeyCode -eq "F4") -or >> "%TEMP%\block_user_interface.ps1"
echo         ($e.Alt -and $e.KeyCode -eq "F4") -or >> "%TEMP%\block_user_interface.ps1"
echo         ($e.KeyCode -eq "Escape") -or >> "%TEMP%\block_user_interface.ps1"
echo         ($e.Alt -and $e.KeyCode -eq "Tab") -or >> "%TEMP%\block_user_interface.ps1"
echo         ($e.Control -and $e.KeyCode -eq "Tab")) { >> "%TEMP%\block_user_interface.ps1"
echo         $e.Handled = $true >> "%TEMP%\block_user_interface.ps1"
echo         $e.SuppressKeyPress = $true >> "%TEMP%\block_user_interface.ps1"
echo         return >> "%TEMP%\block_user_interface.ps1"
echo     } >> "%TEMP%\block_user_interface.ps1"
echo }) >> "%TEMP%\block_user_interface.ps1"
echo. >> "%TEMP%\block_user_interface.ps1"
echo # Impedisce la chiusura della finestra (eccetto per emergenza) >> "%TEMP%\block_user_interface.ps1"
echo $form.Add_FormClosing({ >> "%TEMP%\block_user_interface.ps1"
echo     param($sender, $e) >> "%TEMP%\block_user_interface.ps1"
echo     # Permetti chiusura immediata se attivata scorciatoia di emergenza >> "%TEMP%\block_user_interface.ps1"
echo     if ($script:emergencyExit) { >> "%TEMP%\block_user_interface.ps1"
echo         return >> "%TEMP%\block_user_interface.ps1"
echo     } >> "%TEMP%\block_user_interface.ps1"
echo     # Permetti la chiusura solo se il flag non esiste più >> "%TEMP%\block_user_interface.ps1"
echo     if (Test-Path "%TEMP%\p4c_installation_running.flag") { >> "%TEMP%\block_user_interface.ps1"
echo         $e.Cancel = $true >> "%TEMP%\block_user_interface.ps1"
echo     } else { >> "%TEMP%\block_user_interface.ps1"
echo         # Quando il popup si chiude, termina tutti i processi di gestione >> "%TEMP%\block_user_interface.ps1"
echo         try { >> "%TEMP%\block_user_interface.ps1"
echo             # Termina script VBS popup handler >> "%TEMP%\block_user_interface.ps1"
echo             Get-Process -Name "cscript" -ErrorAction SilentlyContinue ^| Where-Object { $_.CommandLine -like "*popup_handler.vbs*" } ^| Stop-Process -Force -ErrorAction SilentlyContinue >> "%TEMP%\block_user_interface.ps1"
echo             Get-Process -Name "wscript" -ErrorAction SilentlyContinue ^| Where-Object { $_.CommandLine -like "*popup_handler.vbs*" } ^| Stop-Process -Force -ErrorAction SilentlyContinue >> "%TEMP%\block_user_interface.ps1"
echo             # Termina processi PowerShell di automazione >> "%TEMP%\block_user_interface.ps1"
echo             Get-Process -Name "powershell" -ErrorAction SilentlyContinue ^| Where-Object { $_.CommandLine -like "*SendKeys*" } ^| Stop-Process -Force -ErrorAction SilentlyContinue >> "%TEMP%\block_user_interface.ps1"
echo         } catch { >> "%TEMP%\block_user_interface.ps1"
echo             # Ignora errori di terminazione >> "%TEMP%\block_user_interface.ps1"
echo         } >> "%TEMP%\block_user_interface.ps1"
echo     } >> "%TEMP%\block_user_interface.ps1"
echo }) >> "%TEMP%\block_user_interface.ps1"
echo. >> "%TEMP%\block_user_interface.ps1"
echo # Abilita KeyEvents >> "%TEMP%\block_user_interface.ps1"
echo $form.KeyPreview = $true >> "%TEMP%\block_user_interface.ps1"
echo. >> "%TEMP%\block_user_interface.ps1"
echo # Mostra la finestra >> "%TEMP%\block_user_interface.ps1"
echo $form.ShowDialog() >> "%TEMP%\block_user_interface.ps1"

REM Avvia il blocco UI in background
start /min "" powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "%TEMP%\block_user_interface.ps1"
echo Interfaccia di blocco utente attivata
echo.

REM === TERMINAZIONE PROCESSI JAVAW ATTIVI ===
echo TERMINAZIONE PROCESSI JAVA ESISTENTI... > "%TEMP%\p4c_phase.txt"
echo Ricerca processi javaw.exe attivi...
set "javaw_found=false"

REM Cerca tutti i processi javaw.exe e salva i PID
for /f "tokens=2 delims=," %%a in ('tasklist /fi "imagename eq javaw.exe" /fo csv /nh 2^>nul') do (
    if not "%%a"=="" (
        set "javaw_found=true"
        echo Trovato processo javaw.exe con PID: %%a
        echo Terminazione processo PID %%a...
        taskkill /PID %%a /f >nul 2>&1
        if !errorlevel! equ 0 (
            echo Processo PID %%a terminato con successo
        ) else (
            echo ATTENZIONE: Impossibile terminare processo PID %%a
        )
    )
)

if "%javaw_found%"=="false" (
    echo Nessun processo javaw.exe attivo trovato
) else (
    echo Attesa 2 secondi dopo terminazione processi...
    timeout /t 2 /nobreak >nul
)



REM Imposta la versione desiderata di Java
set "java_version=jre8"

REM Definisci i percorsi per le cartelle e i file
set "p4c_folder=C:\P4C"
set "galileo_folder=C:\Galileo"
set "p4c_jnlp_source=%~dp0tinyserver.jnlp"
set "galileo_jnlp_source=%~dp0galileo.jnlp"
set "p4c_jnlp_dest=%p4c_folder%\tinyserver.jnlp"
set "galileo_jnlp_dest=%galileo_folder%\galileo.jnlp"

echo Creazione cartelle e copia file JNLP...
echo CREAZIONE CARTELLE E COPIA FILE JNLP... > "%TEMP%\p4c_phase.txt"

REM Crea la cartella P4C se non esiste
if not exist "%p4c_folder%" (
    mkdir "%p4c_folder%"
    echo Creata cartella P4C: %p4c_folder%
) else (
    echo Cartella P4C già esistente
)

REM Copia il file tinyserver.jnlp se esiste
if exist "%p4c_jnlp_source%" (
    copy "%p4c_jnlp_source%" "%p4c_jnlp_dest%"
    if exist "%p4c_jnlp_dest%" (
        echo Copiato tinyserver.jnlp in %p4c_jnlp_dest%
    ) else (
        powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('ERRORE: Impossibile copiare il file tinyserver.jnlp in %p4c_jnlp_dest%. Verificare i permessi di scrittura.', 'Errore Copia File', 'OK', 'Error')"
        echo ERRORE: Impossibile copiare tinyserver.jnlp
    )
) else (
    echo ATTENZIONE: File tinyserver.jnlp non trovato nella cartella corrente!
)

REM Crea la cartella Galileo se non esiste
if not exist "%galileo_folder%" (
    mkdir "%galileo_folder%"
    echo Creata cartella Galileo: %galileo_folder%
) else (
    echo Cartella Galileo già esistente
)

REM Copia il file galileo.jnlp se esiste
if exist "%galileo_jnlp_source%" (
    copy "%galileo_jnlp_source%" "%galileo_jnlp_dest%"
    if exist "%galileo_jnlp_dest%" (
        echo Copiato galileo.jnlp in %galileo_jnlp_dest%
    ) else (
        powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('ERRORE: Impossibile copiare il file galileo.jnlp in %galileo_jnlp_dest%. Verificare i permessi di scrittura.', 'Errore Copia File', 'OK', 'Error')"
        echo ERRORE: Impossibile copiare galileo.jnlp
    )
) else (
    echo ATTENZIONE: File galileo.jnlp non trovato nella cartella corrente!
)

REM === PULIZIA FILE GALILEO SUL DESKTOP (PRIMA DELLA CREAZIONE COLLEGAMENTO) ===
echo Pulizia preventiva file contenenti "galileo" sul desktop...
set "desktop_path=%USERPROFILE%\Desktop"
set "files_found=false"

REM Cerca e elimina tutti i file che contengono "galileo" nel nome (case insensitive)
for %%f in ("%desktop_path%\*galileo*") do (
    if exist "%%f" (
        echo Eliminazione file: %%f
        del /Q "%%f" >nul 2>&1
        if !errorlevel! equ 0 (
            echo File eliminato con successo: %%~nxf
            set "files_found=true"
        ) else (
            echo ATTENZIONE: Impossibile eliminare: %%~nxf
        )
    )
)

REM Cerca anche con varianti maiuscole/minuscole
for %%f in ("%desktop_path%\*Galileo*") do (
    if exist "%%f" (
        echo Eliminazione file: %%f
        del /Q "%%f" >nul 2>&1
        if !errorlevel! equ 0 (
            echo File eliminato con successo: %%~nxf
            set "files_found=true"
        ) else (
            echo ATTENZIONE: Impossibile eliminare: %%~nxf
        )
    )
)

for %%f in ("%desktop_path%\*GALILEO*") do (
    if exist "%%f" (
        echo Eliminazione file: %%f
        del /Q "%%f" >nul 2>&1
        if !errorlevel! equ 0 (
            echo File eliminato con successo: %%~nxf
            set "files_found=true"
        ) else (
            echo ATTENZIONE: Impossibile eliminare: %%~nxf
        )
    )
)

if "%files_found%"=="false" (
    echo Nessun file contenente "galileo" trovato sul desktop
) else (
    echo Pulizia preventiva file galileo completata
)
echo.

REM Crea collegamento sul desktop per galileo.bat (usando la copia in C:\P4C)
set "galileo_bat_source=%~dp0galileo.bat"
set "galileo_bat_dest=C:\P4C\galileo.bat"
set "desktop_path=%USERPROFILE%\Desktop"
set "shortcut_name=Galileo.lnk"

if exist "%galileo_bat_source%" (
    echo CREAZIONE COLLEGAMENTO SUL DESKTOP... > "%TEMP%\p4c_phase.txt"
    echo Creazione collegamento sul desktop per galileo.bat...
    echo Usando la copia robusta in: %galileo_bat_dest%
    powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%desktop_path%\%shortcut_name%'); $Shortcut.TargetPath = '%galileo_bat_dest%'; $Shortcut.WorkingDirectory = 'C:\P4C'; $Shortcut.IconLocation = 'C:\P4C\Icona_Galileo.ico'; $Shortcut.Save()"
    echo Collegamento creato sul desktop: %desktop_path%\%shortcut_name%
    echo NOTA: Il collegamento punta alla copia robusta in C:\P4C\ (accessibile a tutti)
) else (
    echo ATTENZIONE: File galileo.bat non trovato nella cartella corrente!
)

REM === AUTO-COPIA SCRIPT IN POSIZIONE PERMANENTE ===
REM Copia il BAT corrente in C:\P4C\ per garantire accesso universale
set "p4c_script_dest=C:\P4C\P4C_setup_auto.bat"
set "current_script=%~f0"

echo Auto-copia script in posizione permanente...
echo AUTO-COPIA SCRIPT IN POSIZIONE PERMANENTE... > "%TEMP%\p4c_phase.txt"
echo Script corrente: %current_script%
echo Destinazione: %p4c_script_dest%

REM Copia sempre il script corrente nella cartella P4C (sovrascrive se esiste)
copy "%current_script%" "%p4c_script_dest%" /Y >nul 2>&1
if exist "%p4c_script_dest%" (
    echo Script copiato con successo in %p4c_script_dest%
    echo NOTA: Tutti gli utenti potranno accedere allo script da questa posizione
) else (
    echo ATTENZIONE: Impossibile copiare script in %p4c_script_dest%
    echo Fallback: utilizzo script originale (potenzialmente problematico per altri utenti)
    set "p4c_script_dest=%current_script%"
)

REM Copia anche i file di supporto necessari
set "support_files_copied=false"
if exist "%~dp0tinyserver.jnlp" (
    copy "%~dp0tinyserver.jnlp" "C:\P4C\tinyserver.jnlp" /Y >nul 2>&1
    set "support_files_copied=true"
)
if exist "%~dp0galileo.jnlp" (
    copy "%~dp0galileo.jnlp" "C:\P4C\galileo.jnlp" /Y >nul 2>&1
    set "support_files_copied=true"
)
if exist "%~dp0deployment.properties" (
    copy "%~dp0deployment.properties" "C:\P4C\deployment.properties" /Y >nul 2>&1
    set "support_files_copied=true"
)
if exist "%~dp0galileo.bat" (
    copy "%~dp0galileo.bat" "C:\P4C\galileo.bat" /Y >nul 2>&1
    set "support_files_copied=true"
)
if exist "%~dp0Icona_Galileo.ico" (
    copy "%~dp0Icona_Galileo.ico" "C:\P4C\Icona_Galileo.ico" /Y >nul 2>&1
    set "support_files_copied=true"
)
if exist "%~dp0sfondo_popup.png" (
    copy "%~dp0sfondo_popup.png" "C:\P4C\sfondo_popup.png" /Y >nul 2>&1
    set "support_files_copied=true"
)
if exist "%~dp0favicon.png" (
    copy "%~dp0favicon.png" "C:\P4C\favicon.png" /Y >nul 2>&1
    echo Copiato favicon.png per icona system tray Java8
    set "support_files_copied=true"
)

if "%support_files_copied%"=="true" (
    echo File di supporto copiati in C:\P4C\
)

REM === CONFIGURAZIONE AVVIO AUTOMATICO ROBUSTO ===
REM Crea collegamento nella cartella di avvio automatico per P4C_setup.bat
set "startup_path_user=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "startup_path_all=%ProgramData%\Microsoft\Windows\Start Menu\Programs\StartUp"
set "p4c_setup_source=%p4c_script_dest%"
set "startup_shortcut_name=P4C_Setup_Auto.lnk"

echo Creazione collegamento nella cartella di avvio automatico per tutti gli utenti...
echo CONFIGURAZIONE AVVIO AUTOMATICO ROBUSTO... > "%TEMP%\p4c_phase.txt"
echo Percorso cartella Startup (tutti utenti): %startup_path_all%
echo Script sorgente (ROBUSTO): %p4c_setup_source%
echo VANTAGGIO: Il collegamento punta a C:\P4C\ accessibile a tutti gli utenti

REM Crea la cartella Startup per tutti gli utenti se non esiste
if not exist "%startup_path_all%" (
    mkdir "%startup_path_all%" >nul 2>&1
    echo Creata cartella Startup per tutti gli utenti
)

REM Crea il collegamento nella cartella Startup per tutti gli utenti
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%startup_path_all%\%startup_shortcut_name%'); $Shortcut.TargetPath = '%p4c_setup_source%'; $Shortcut.WorkingDirectory = 'C:\P4C'; $Shortcut.WindowStyle = 1; $Shortcut.Save()"

if exist "%startup_path_all%\%startup_shortcut_name%" (
    echo Collegamento ROBUSTO creato nella cartella Startup per tutti gli utenti: %startup_path_all%\%startup_shortcut_name%
    echo NOTA: Lo script si avvierà automaticamente all'avvio di Windows per TUTTI gli utenti
    echo ROBUSTO: Il collegamento punta a C:\P4C\P4C_setup_auto.bat (accessibile universalmente)
    
    REM Rimuovi eventuale collegamento duplicato per utente corrente
    if exist "%startup_path_user%\%startup_shortcut_name%" (
        del "%startup_path_user%\%startup_shortcut_name%" >nul 2>&1
        echo Rimosso collegamento duplicato per utente corrente (priorità a quello globale robusto)
    )
) else (
    echo ATTENZIONE: Impossibile creare collegamento nella cartella Startup per tutti gli utenti
    echo Tentativo fallback: creazione per utente corrente...
    
    REM Fallback: crea per utente corrente se non riesce per tutti
    if not exist "%startup_path_user%" (
        mkdir "%startup_path_user%" >nul 2>&1
        echo Creata cartella Startup per utente corrente
    )
    
    REM Prima di creare, controlla se esiste già quello globale
    if exist "%startup_path_all%\%startup_shortcut_name%" (
        echo Collegamento globale già esistente - non creo quello per utente corrente
        echo NOTA: Verrà utilizzato il collegamento globale robusto esistente
    ) else (
        powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%startup_path_user%\%startup_shortcut_name%'); $Shortcut.TargetPath = '%p4c_setup_source%'; $Shortcut.WorkingDirectory = 'C:\P4C'; $Shortcut.WindowStyle = 1; $Shortcut.Save()"
        
        if exist "%startup_path_user%\%startup_shortcut_name%" (
            echo Collegamento fallback creato per utente corrente: %startup_path_user%\%startup_shortcut_name%
            echo NOTA: Anche il fallback punta alla copia robusta in C:\P4C\
        ) else (
            echo ERRORE: Impossibile creare collegamento di avvio automatico
        )
    )
)

REM Copia il file deployment.properties nella cartella di deployment di Java
set "deployment_source=%~dp0deployment.properties"
set "deployment_folder_default=C:\Users\Default\AppData\LocalLow\Sun\Java\Deployment"
set "deployment_folder_current=%USERPROFILE%\AppData\LocalLow\Sun\Java\Deployment"
set "deployment_dest_default=%deployment_folder_default%\deployment.properties"
set "deployment_dest_current=%deployment_folder_current%\deployment.properties"

if exist "%deployment_source%" (
    echo CONFIGURAZIONE JAVA DEPLOYMENT... > "%TEMP%\p4c_phase.txt"
    echo Configurazione deployment.properties...
    echo Percorso sorgente: %deployment_source%
    
    REM Copia nella cartella Default (per nuovi utenti)
    echo Copia in cartella Default: %deployment_dest_default%
    copy "%deployment_source%" "%deployment_dest_default%" /Y >nul 2>&1
    if exist "%deployment_dest_default%" (
        echo Copiato deployment.properties in Default
    ) else (
        powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('ERRORE: Impossibile copiare deployment.properties nella cartella Default. La cartella potrebbe non esistere o non ci sono permessi di scrittura.', 'Errore Copia File', 'OK', 'Error')"
        echo ERRORE: Impossibile copiare deployment.properties in Default
    )
    
    REM Copia nella cartella dell'utente corrente
    echo Copia in cartella utente corrente: %deployment_dest_current%
    copy "%deployment_source%" "%deployment_dest_current%" /Y >nul 2>&1
    if exist "%deployment_dest_current%" (
        echo Copiato deployment.properties per utente corrente
    ) else (
        powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('ERRORE: Impossibile copiare deployment.properties per utente corrente. La cartella potrebbe non esistere o non ci sono permessi di scrittura.', 'Errore Copia File', 'OK', 'Error')"
        echo ERRORE: Impossibile copiare deployment.properties per utente corrente
    )
) else (
    echo ATTENZIONE: File deployment.properties non trovato nella cartella corrente!
    echo Percorso cercato: %deployment_source%
)

echo Configurazione completata!
echo.

REM === PREPARAZIONE GESTIONE POPUP JAVA ===
echo PREPARAZIONE GESTIONE POPUP JAVA... > "%TEMP%\p4c_phase.txt"
echo Preparazione sistema di gestione popup Java...

REM Crea uno script VBS temporaneo per gestire i popup Java
echo Set objShell = CreateObject("WScript.Shell") > "%TEMP%\popup_handler.vbs"
echo Set objFSO = CreateObject("Scripting.FileSystemObject") >> "%TEMP%\popup_handler.vbs"
echo. >> "%TEMP%\popup_handler.vbs"
echo ' Timeout di 40 secondi per gestire tutti i popup >> "%TEMP%\popup_handler.vbs"
echo startTime = Timer >> "%TEMP%\popup_handler.vbs"
echo timeout = 40 >> "%TEMP%\popup_handler.vbs"
echo popupCount = 0 >> "%TEMP%\popup_handler.vbs"
echo firstPopupHandled = False >> "%TEMP%\popup_handler.vbs"
echo waitStartTime = 0 >> "%TEMP%\popup_handler.vbs"
echo errorDetected = False >> "%TEMP%\popup_handler.vbs"
echo. >> "%TEMP%\popup_handler.vbs"
echo Do While Timer - startTime ^< timeout >> "%TEMP%\popup_handler.vbs"
echo     On Error Resume Next >> "%TEMP%\popup_handler.vbs"
echo     popupHandled = False >> "%TEMP%\popup_handler.vbs"
echo. >> "%TEMP%\popup_handler.vbs"
echo     ' PRIORITA 1: Controlla popup di errore >> "%TEMP%\popup_handler.vbs"
echo     If objShell.AppActivate("errore") Or objShell.AppActivate("error") Or objShell.AppActivate("Error") Or objShell.AppActivate("Errore") Then >> "%TEMP%\popup_handler.vbs"
echo         WScript.Sleep 300 >> "%TEMP%\popup_handler.vbs"
echo         objShell.SendKeys "{ENTER}" >> "%TEMP%\popup_handler.vbs"
echo         WScript.Sleep 2000 >> "%TEMP%\popup_handler.vbs"
echo         errorDetected = True >> "%TEMP%\popup_handler.vbs"
echo         ' Crea flag per riavvio >> "%TEMP%\popup_handler.vbs"
echo         Set flagFile = objFSO.CreateTextFile("%TEMP%\p4c_restart_needed.flag", True) >> "%TEMP%\popup_handler.vbs"
echo         flagFile.WriteLine "restart" >> "%TEMP%\popup_handler.vbs"
echo         flagFile.Close >> "%TEMP%\popup_handler.vbs"
echo         Exit Do >> "%TEMP%\popup_handler.vbs"
echo. >> "%TEMP%\popup_handler.vbs"
echo     ' PRIORITA 2: Cerca popup "Aggiornamento necessario" (primo popup) >> "%TEMP%\popup_handler.vbs"
echo     ElseIf Not firstPopupHandled And (objShell.AppActivate("Aggiornamento necessario") Or objShell.AppActivate("obsoleta") Or objShell.AppActivate("outdated") Or objShell.AppActivate("aggiornamento")) Then >> "%TEMP%\popup_handler.vbs"
echo         WScript.Sleep 300 >> "%TEMP%\popup_handler.vbs"
echo         objShell.SendKeys "{TAB}{TAB}{ENTER}" >> "%TEMP%\popup_handler.vbs"
echo         popupCount = popupCount + 1 >> "%TEMP%\popup_handler.vbs"
echo         firstPopupHandled = True >> "%TEMP%\popup_handler.vbs"
echo         waitStartTime = Timer >> "%TEMP%\popup_handler.vbs"
echo         popupHandled = True >> "%TEMP%\popup_handler.vbs"
echo         WScript.Sleep 800 >> "%TEMP%\popup_handler.vbs"
echo. >> "%TEMP%\popup_handler.vbs"
echo     ' PRIORITA 3: Cerca popup "Avvio applicazione in corso" (secondo popup) >> "%TEMP%\popup_handler.vbs"
echo     ElseIf (objShell.AppActivate("Avvio applicazione in corso...") Or objShell.AppActivate("Avvio applicazione") Or objShell.AppActivate("application starting") Or objShell.AppActivate("starting")) Then >> "%TEMP%\popup_handler.vbs"
echo         WScript.Sleep 20000 >> "%TEMP%\popup_handler.vbs"
echo         ' Invio ENTER diretto per tentativo standard >> "%TEMP%\popup_handler.vbs"
echo         objShell.SendKeys "{ENTER}" >> "%TEMP%\popup_handler.vbs"
echo         WScript.Sleep 500 >> "%TEMP%\popup_handler.vbs"
echo         popupCount = popupCount + 1 >> "%TEMP%\popup_handler.vbs"
echo         ' Continua a monitorare per eventuali popup tardivi >> "%TEMP%\popup_handler.vbs"
echo     End If >> "%TEMP%\popup_handler.vbs"
echo. >> "%TEMP%\popup_handler.vbs"
echo     ' Pausa tra controlli >> "%TEMP%\popup_handler.vbs"
echo     If Not popupHandled Then >> "%TEMP%\popup_handler.vbs"
echo         WScript.Sleep 1000 >> "%TEMP%\popup_handler.vbs"
echo     End If >> "%TEMP%\popup_handler.vbs"
echo Loop >> "%TEMP%\popup_handler.vbs"
echo. >> "%TEMP%\popup_handler.vbs"
echo ' Pulisce il file temporaneo >> "%TEMP%\popup_handler.vbs"
echo objFSO.DeleteFile WScript.ScriptFullName, True >> "%TEMP%\popup_handler.vbs"

REM Avvia lo script VBS in background
start /min "" cscript.exe //nologo "%TEMP%\popup_handler.vbs"
echo Script VBS per gestione popup avviato in background
echo.
echo NOTA: Sistema di gestione popup attivo:
echo       - Popup di errore: ENTER + riavvio automatico
echo       - Primo popup (aggiornamento): TAB-TAB-ENTER automatico
echo       - Secondo popup (avvio applicazione): ENTER diretto + controllo pre-chiusura
echo.

REM Attesa per permettere allo script di popup di avviarsi
echo Attesa 2 secondi per avvio automazione popup...
timeout /t 2 /nobreak >nul

echo.
REM === AVVIO JAVA8 ===
echo AVVIO APPLICAZIONE JAVA... > "%TEMP%\p4c_phase.txt"

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
    "%java_path%" "C:\P4C\tinyserver.jnlp"
)

REM === AVVIO MONITOR SYSTEM TRAY JAVA8 (SEPARATO) ===
echo Creazione monitor icona system tray per Java8...

REM Crea script PowerShell separato per monitoraggio Java8 system tray
echo # Monitor System Tray Java8 - Script separato e autonomo > "%TEMP%\java8_systray_monitor.ps1"
echo Add-Type -AssemblyName System.Windows.Forms >> "%TEMP%\java8_systray_monitor.ps1"
echo Add-Type -AssemblyName System.Drawing >> "%TEMP%\java8_systray_monitor.ps1"
echo. >> "%TEMP%\java8_systray_monitor.ps1"
echo # Crea icona system tray semplice >> "%TEMP%\java8_systray_monitor.ps1"
echo $notifyIcon = New-Object System.Windows.Forms.NotifyIcon >> "%TEMP%\java8_systray_monitor.ps1"
echo. >> "%TEMP%\java8_systray_monitor.ps1"
echo # Cerca file icona (prima PNG poi ICO come fallback) >> "%TEMP%\java8_systray_monitor.ps1"
echo $iconPath = $null >> "%TEMP%\java8_systray_monitor.ps1"
echo $pngPath = "C:\P4C\favicon.png" >> "%TEMP%\java8_systray_monitor.ps1"
echo $icoPath = "C:\P4C\Icona_Galileo.ico" >> "%TEMP%\java8_systray_monitor.ps1"
echo $localPngPath = "%~dp0favicon.png" >> "%TEMP%\java8_systray_monitor.ps1"
echo. >> "%TEMP%\java8_systray_monitor.ps1"
echo # Priorità: 1) favicon.png in C:\P4C, 2) favicon.png locale, 3) ICO Galileo, 4) Icona default >> "%TEMP%\java8_systray_monitor.ps1"
echo if (Test-Path $pngPath) { >> "%TEMP%\java8_systray_monitor.ps1"
echo     $iconPath = $pngPath >> "%TEMP%\java8_systray_monitor.ps1"
echo     Write-Host "Usando icona PNG: $pngPath" >> "%TEMP%\java8_systray_monitor.ps1"
echo } elseif (Test-Path $localPngPath) { >> "%TEMP%\java8_systray_monitor.ps1"
echo     $iconPath = $localPngPath >> "%TEMP%\java8_systray_monitor.ps1"
echo     Write-Host "Usando icona PNG locale: $localPngPath" >> "%TEMP%\java8_systray_monitor.ps1"
echo } elseif (Test-Path $icoPath) { >> "%TEMP%\java8_systray_monitor.ps1"
echo     $iconPath = $icoPath >> "%TEMP%\java8_systray_monitor.ps1"
echo     Write-Host "Usando icona ICO Galileo: $icoPath" >> "%TEMP%\java8_systray_monitor.ps1"
echo } >> "%TEMP%\java8_systray_monitor.ps1"
echo. >> "%TEMP%\java8_systray_monitor.ps1"
echo # Configura icona >> "%TEMP%\java8_systray_monitor.ps1"
echo if ($iconPath -and (Test-Path $iconPath)) { >> "%TEMP%\java8_systray_monitor.ps1"
echo     try { >> "%TEMP%\java8_systray_monitor.ps1"
echo         if ($iconPath.EndsWith(".png")) { >> "%TEMP%\java8_systray_monitor.ps1"
echo             # Carica PNG e converte in icona >> "%TEMP%\java8_systray_monitor.ps1"
echo             $bitmap = [System.Drawing.Bitmap]::FromFile($iconPath) >> "%TEMP%\java8_systray_monitor.ps1"
echo             $resizedBitmap = New-Object System.Drawing.Bitmap($bitmap, 16, 16) >> "%TEMP%\java8_systray_monitor.ps1"
echo             $notifyIcon.Icon = [System.Drawing.Icon]::FromHandle($resizedBitmap.GetHicon()) >> "%TEMP%\java8_systray_monitor.ps1"
echo             $bitmap.Dispose() >> "%TEMP%\java8_systray_monitor.ps1"
echo         } else { >> "%TEMP%\java8_systray_monitor.ps1"
echo             # Carica file ICO direttamente >> "%TEMP%\java8_systray_monitor.ps1"
echo             $notifyIcon.Icon = New-Object System.Drawing.Icon($iconPath) >> "%TEMP%\java8_systray_monitor.ps1"
echo         } >> "%TEMP%\java8_systray_monitor.ps1"
echo         Write-Host "Icona caricata con successo: $iconPath" >> "%TEMP%\java8_systray_monitor.ps1"
echo     } catch { >> "%TEMP%\java8_systray_monitor.ps1"
echo         Write-Host "Errore caricamento icona: $($_.Exception.Message)" >> "%TEMP%\java8_systray_monitor.ps1"
echo         # Fallback: crea icona semplice >> "%TEMP%\java8_systray_monitor.ps1"
echo         $bitmap = New-Object System.Drawing.Bitmap(16, 16) >> "%TEMP%\java8_systray_monitor.ps1"
echo         $graphics = [System.Drawing.Graphics]::FromImage($bitmap) >> "%TEMP%\java8_systray_monitor.ps1"
echo         $graphics.Clear([System.Drawing.Color]::Orange) >> "%TEMP%\java8_systray_monitor.ps1"
echo         $font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold) >> "%TEMP%\java8_systray_monitor.ps1"
echo         $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White) >> "%TEMP%\java8_systray_monitor.ps1"
echo         $graphics.DrawString("J", $font, $brush, 2, 1) >> "%TEMP%\java8_systray_monitor.ps1"
echo         $graphics.Dispose() >> "%TEMP%\java8_systray_monitor.ps1"
echo         $notifyIcon.Icon = [System.Drawing.Icon]::FromHandle($bitmap.GetHicon()) >> "%TEMP%\java8_systray_monitor.ps1"
echo         Write-Host "Usando icona fallback generata" >> "%TEMP%\java8_systray_monitor.ps1"
echo     } >> "%TEMP%\java8_systray_monitor.ps1"
echo } else { >> "%TEMP%\java8_systray_monitor.ps1"
echo     # Nessuna icona trovata - crea icona default >> "%TEMP%\java8_systray_monitor.ps1"
echo     $bitmap = New-Object System.Drawing.Bitmap(16, 16) >> "%TEMP%\java8_systray_monitor.ps1"
echo     $graphics = [System.Drawing.Graphics]::FromImage($bitmap) >> "%TEMP%\java8_systray_monitor.ps1"
echo     $graphics.Clear([System.Drawing.Color]::Orange) >> "%TEMP%\java8_systray_monitor.ps1"
echo     $font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold) >> "%TEMP%\java8_systray_monitor.ps1"
echo     $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White) >> "%TEMP%\java8_systray_monitor.ps1"
echo     $graphics.DrawString("J", $font, $brush, 2, 1) >> "%TEMP%\java8_systray_monitor.ps1"
echo     $graphics.Dispose() >> "%TEMP%\java8_systray_monitor.ps1"
echo     $notifyIcon.Icon = [System.Drawing.Icon]::FromHandle($bitmap.GetHicon()) >> "%TEMP%\java8_systray_monitor.ps1"
echo     Write-Host "Nessuna icona trovata - usando icona default generata" >> "%TEMP%\java8_systray_monitor.ps1"
echo } >> "%TEMP%\java8_systray_monitor.ps1"
echo $notifyIcon.Text = "Java8" >> "%TEMP%\java8_systray_monitor.ps1"
echo $notifyIcon.Visible = $false >> "%TEMP%\java8_systray_monitor.ps1"
echo. >> "%TEMP%\java8_systray_monitor.ps1"
echo # Variabili di stato >> "%TEMP%\java8_systray_monitor.ps1"
echo $iconVisible = $false >> "%TEMP%\java8_systray_monitor.ps1"
echo. >> "%TEMP%\java8_systray_monitor.ps1"
echo # Funzione per controllare processi Java >> "%TEMP%\java8_systray_monitor.ps1"
echo function Check-JavaProcess { >> "%TEMP%\java8_systray_monitor.ps1"
echo     try { >> "%TEMP%\java8_systray_monitor.ps1"
echo         $javaProcesses = Get-Process -Name "javaw" -ErrorAction SilentlyContinue >> "%TEMP%\java8_systray_monitor.ps1"
echo         return ($javaProcesses -ne $null -and $javaProcesses.Count -gt 0) >> "%TEMP%\java8_systray_monitor.ps1"
echo     } catch { >> "%TEMP%\java8_systray_monitor.ps1"
echo         return $false >> "%TEMP%\java8_systray_monitor.ps1"
echo     } >> "%TEMP%\java8_systray_monitor.ps1"
echo } >> "%TEMP%\java8_systray_monitor.ps1"
echo. >> "%TEMP%\java8_systray_monitor.ps1"
echo # Loop di monitoraggio principale >> "%TEMP%\java8_systray_monitor.ps1"
echo Write-Host "Monitor Java8 System Tray avviato..." >> "%TEMP%\java8_systray_monitor.ps1"
echo. >> "%TEMP%\java8_systray_monitor.ps1"
echo while ($true) { >> "%TEMP%\java8_systray_monitor.ps1"
echo     $javaRunning = Check-JavaProcess >> "%TEMP%\java8_systray_monitor.ps1"
echo     >> "%TEMP%\java8_systray_monitor.ps1"
echo     # Mostra icona se Java è attivo e non è già visibile >> "%TEMP%\java8_systray_monitor.ps1"
echo     if ($javaRunning -and -not $iconVisible) { >> "%TEMP%\java8_systray_monitor.ps1"
echo         $notifyIcon.Visible = $true >> "%TEMP%\java8_systray_monitor.ps1"
echo         $iconVisible = $true >> "%TEMP%\java8_systray_monitor.ps1"
echo         Write-Host "Icona Java8 mostrata in system tray" >> "%TEMP%\java8_systray_monitor.ps1"
echo     } >> "%TEMP%\java8_systray_monitor.ps1"
echo     # Nascondi icona se Java non è attivo e è visibile >> "%TEMP%\java8_systray_monitor.ps1"
echo     elseif (-not $javaRunning -and $iconVisible) { >> "%TEMP%\java8_systray_monitor.ps1"
echo         $notifyIcon.Visible = $false >> "%TEMP%\java8_systray_monitor.ps1"
echo         $iconVisible = $false >> "%TEMP%\java8_systray_monitor.ps1"
echo         Write-Host "Icona Java8 rimossa da system tray - Java non attivo" >> "%TEMP%\java8_systray_monitor.ps1"
echo         Write-Host "Monitor Java8 terminato - nessun processo Java rilevato" >> "%TEMP%\java8_systray_monitor.ps1"
echo         break >> "%TEMP%\java8_systray_monitor.ps1"
echo     } >> "%TEMP%\java8_systray_monitor.ps1"
echo     >> "%TEMP%\java8_systray_monitor.ps1"
echo     # Attesa 3 secondi prima del prossimo controllo >> "%TEMP%\java8_systray_monitor.ps1"
echo     Start-Sleep -Seconds 3 >> "%TEMP%\java8_systray_monitor.ps1"
echo } >> "%TEMP%\java8_systray_monitor.ps1"
echo. >> "%TEMP%\java8_systray_monitor.ps1"
echo # Pulizia finale >> "%TEMP%\java8_systray_monitor.ps1"
echo if ($notifyIcon) { >> "%TEMP%\java8_systray_monitor.ps1"
echo     $notifyIcon.Visible = $false >> "%TEMP%\java8_systray_monitor.ps1"
echo     $notifyIcon.Dispose() >> "%TEMP%\java8_systray_monitor.ps1"
echo } >> "%TEMP%\java8_systray_monitor.ps1"
echo Write-Host "Monitor Java8 System Tray terminato" >> "%TEMP%\java8_systray_monitor.ps1"

REM Avvia monitor system tray in background (completamente separato)
start /min "" powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "%TEMP%\java8_systray_monitor.ps1"
echo Monitor icona system tray Java8 avviato in background (separato)
echo NOTA: L'icona "Java8" apparirà quando javaw.exe è attivo
echo.

REM "C:\Program Files (x86)\Java\jre6\bin\javaws" -J-Djnlp.arg0=%1 http://srv-dnweb.asl-11.it:8090/tinyserver-jws-1.6.0/tinyserver.jnlp

REM === CONTROLLO IMMEDIATO RIAVVIO E ARRESTO EMERGENZA ===
echo.
echo Controllo errori in tempo reale...

REM Inizializza contatore per il controllo
set "check_count=0"

REM Aspetta un po' per permettere al VBScript di rilevare eventuali errori
:CheckLoop
timeout /t 2 /nobreak >nul

REM PRIORITA MASSIMA: Controlla flag di arresto di emergenza
if exist "%TEMP%\p4c_emergency_stop.flag" (
    echo.
    echo *** ARRESTO DI EMERGENZA ATTIVATO ***
    echo Terminazione immediata di tutti i processi...
    
    REM Termina tutti i processi correlati
    taskkill /f /im javaw.exe >nul 2>&1
    taskkill /f /im cscript.exe >nul 2>&1
    taskkill /f /im wscript.exe >nul 2>&1
    
    REM Rimuovi tutti i flag
    del "%TEMP%\p4c_emergency_stop.flag" >nul 2>&1
    del "%TEMP%\p4c_installation_running.flag" >nul 2>&1
    del "%TEMP%\p4c_finalizing.flag" >nul 2>&1
    del "%TEMP%\p4c_restart_needed.flag" >nul 2>&1
    del "%TEMP%\block_user_interface.ps1" >nul 2>&1
    
    echo ARRESTO COMPLETATO - SCRIPT TERMINATO
    exit /b 0
)

REM Controlla se esiste il flag di riavvio
if exist "%TEMP%\p4c_restart_needed.flag" (
    echo.
    echo *** RILEVATO ERRORE - RIAVVIO AUTOMATICO ***
    echo Rimozione flag di riavvio...
    del "%TEMP%\p4c_restart_needed.flag" >nul 2>&1
    
    echo Rimozione blocco utente per riavvio...
    del "%TEMP%\p4c_installation_running.flag" >nul 2>&1
    
    echo Pulizia processi Java in corso...
    taskkill /f /im javaw.exe >nul 2>&1
    
    echo Attesa 3 secondi prima del riavvio...
    timeout /t 3 /nobreak >nul
    
    echo.
    echo === RIAVVIO AUTOMATICO P4C_SETUP ===
    echo.
    call "%~f0"
    goto :eof
)

REM Continua a controllare per un massimo di 30 secondi
set /a check_count+=1
if %check_count% lss 15 goto CheckLoop

echo Nessun errore rilevato - continuazione processo normale...

@echo off > NUL
"C:\Program Files (x86)\Java\jre6\bin\javaws" -Xnosplash \\SRV-FS01\Link-ICT\Hitech\direct-connect.jnlp

echo Processo completato con successo.
echo FINALIZZAZIONE E PULIZIA... > "%TEMP%\p4c_phase.txt"
echo.
echo Attesa aggiuntiva per completamento automazione...

REM === CONTROLLO EMERGENZA DURANTE FINALIZZAZIONE ===
REM Controlla il flag di emergenza ogni secondo per 20 secondi
for /L %%i in (1,1,20) do (
    if exist "%TEMP%\p4c_emergency_stop.flag" (
        echo.
        echo *** ARRESTO DI EMERGENZA DURANTE FINALIZZAZIONE ***
        echo Terminazione immediata...
        
        REM Termina tutti i processi
        taskkill /f /im javaw.exe >nul 2>&1
        taskkill /f /im cscript.exe >nul 2>&1
        taskkill /f /im wscript.exe >nul 2>&1
        
        REM Rimuovi tutti i flag
        del "%TEMP%\p4c_emergency_stop.flag" >nul 2>&1
        del "%TEMP%\p4c_installation_running.flag" >nul 2>&1
        del "%TEMP%\p4c_finalizing.flag" >nul 2>&1
        del "%TEMP%\block_user_interface.ps1" >nul 2>&1
        
        echo ARRESTO COMPLETATO
        exit /b 0
    )
    timeout /t 1 /nobreak >nul
)

REM === RIMOZIONE BLOCCO UTENTE ===
echo.
echo Rimozione interfaccia di blocco...
REM Crea flag per permettere la chiusura del popup
echo. > "%TEMP%\p4c_installation_complete.flag"

REM Termina tutti i processi di gestione popup e automazione
echo Terminazione processi di gestione popup...
taskkill /f /im cscript.exe >nul 2>&1
taskkill /f /im wscript.exe >nul 2>&1
for /f "tokens=2" %%a in ('tasklist /fi "imagename eq powershell.exe" /fo csv /nh 2^>nul') do (
    taskkill /PID %%a /f >nul 2>&1
)

del "%TEMP%\p4c_finalizing.flag" >nul 2>&1
del "%TEMP%\p4c_installation_running.flag" >nul 2>&1
del "%TEMP%\block_user_interface.ps1" >nul 2>&1
del "%TEMP%\p4c_phase.txt" >nul 2>&1
echo Blocco utente rimosso




echo Installazione completata.

echo.
echo === INSTALLAZIONE P4C COMPLETATA CON SUCCESSO ===
echo Tutti i componenti sono stati installati correttamente.
echo Le applicazioni sono pronte per l'uso.


powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')" >nul 2>&1



endlocal
----