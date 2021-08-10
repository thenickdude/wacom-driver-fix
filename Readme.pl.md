# Aktualizacja sterowników MacOS dla tabletów Wacom Bamboo, Graphire, Intuos 1, 2 i 3 oraz Cintiqa 1-szej generacji

Sterowniki Wacoma na systemie MacOS mają w sobie wiele bugów, co uniemożliwia używanie ich na systemie Catalina. Nie 
dzieje się tak jednak na systemach Windowsa, czy też dla nowszych tabletów.

Używając tabletu Bamboo, po otwarciu okna preferencji Wacom wyskakuje błąd z wiadomością "Oczekiwanie na synchronizację"<sup>[1]</sup>, 
a ostatecznie "Wystąpił błąd ze sterownikami tabletu. Proszę zrestartować system. Jeżeli problem dalej będzie występował, 
przeinstaluj lub zaktualizuj sterowniki"<sup>[2]</sup>. W przypadku tabletów Intuos 3 oraz Cintiq 1-szej generacji, okno 
preferencji otworzy się normalnie, lecz kliknięcie gdziekolwiek będzie skutkować zamknięciem aplikacji z wiadomością 
"Wystąpił błąd w preferencjach tabletu Wacom"<sup>[3]</sup>. Dla tabletów Graphire oraz Intuos 1 i 2, na MacOS Catalina 
instalator sterowników nawet się nie uruchamia.

<sup>[1] - "Waiting for synchronization"</sup>
<sup>[2] - "There is a problem with your tablet driver. Please reboot your system. If the problem persists reinstall or update the driver"</sup>
<sup>[3] - "There was an error in Wacom Tablet preferences"</sup>

Zaktualizowane sterowniki tabletów serii Bamboo (v5.3.7-6) wspierają następujące tablety:

- CTE-450, CTE-650 - Bamboo Fun / Bamboo Art Master (2007)
- CTE-460, CTE-660 - Bamboo One Pen
- CTF-430 - Bamboo One
- CTH-300, CTH300, CTH301K - Bamboo Pad
- CTH-460, CTH-660 - Bamboo Pen and Touch
- CTH-461 - Bamboo Fun Pen and Touch / Bamboo Craft / Bamboo Fun Special Edition
- CTH-470 - Bamboo Capture / Bamboo Pen & Touch / Bamboo Create
- CTH-661 - Bamboo Fun / Bamboo Art Master (2009) / Bamboo Fun Pen and Touch
- CTH-670 - Bamboo Create
- CTL-460, CTL-660 - Bamboo Pen 
- CTL-470 - Bamboo Connect / Bamboo Pen
- CTT-460 - Bamboo Touch
- MTE-450 - Bamboo

Zaktualizowane sterowniki tabletów Graphire 1 & 2 oraz Intuos 1 & 2 (v6.1.6-4) wspierają następujące tablety:

- ET-0405-U - Graphire / Graphire 1 (USB)
- ET-0405-R - Graphire / Graphire 1 (Serial) - Nietestowane!
- ET-0405A - Graphire 2
- GD-0405-U, GD-0608-U, GD-0912-U, GD-1212-U, GD-1218-U - Intuos (USB) (1998)
- GD-0405-R, GD-0608-R, GD-0912-R, GD-1212-R, GD-1218-R - Intuos (Serial) (1998) - Nietestowane!
- XD-0405-U, XD-0608-U, XD-0912-U, XD-1212-U, XD-1218-U - Intuos 2 (USB)
- XD-0405-R, XD-0608-R, XD-0912-R, XD-1212-R, XD-1218-R - Intuos 2 (Serial) - Nietestowane!

Zaktualizowane sterowniki tabletów Graphire 3 (v5.2.6-5) wspierają następujące tablety:

- CTE-430, CTE-630 - Graphire 3
- CTE-630BT - Graphire 3 Wireless

Zaktualizowane sterowniki tabletów Graphire 4 (v5.3.0-3) wspierają następujące tablety:

- CTE-440, CTE-640 - Graphire 4

Zaktualizowane sterowniki tabletów Inutos 3 oraz Cintiq (v6.3.15-3) wspierają następujące tablety:

- PTZ-430, PTZ-630, PTZ-630SE, PTZ-631W, PTZ-930, PTZ-1230, PTZ-1231W - Intuos 3
- DTZ-2100 - Cintiq 21UX 1st Gen.
- DTZ-2000 - Cintiq 20WSX

[🇳🇿 English instructions](Readme.md)   
[🇧🇷 / 🇵🇹 Instruções em português](Readme.pt-BR.md)  
[🇯🇵 日本語で表示](Readme.ja-JP.md)   
[🇷🇺 Инструкция на русском языке](Readme.ru-RU.md)  
[🇪🇸 Instrucciones en español](Readme.es.md)   
[🇫🇷 Instructions en français](Readme.fr-FR.md)   

## Instalacja

Pobierz odpowiednią instalkę poniżej dla posiadanego tabletu i odpal klikając podwójnie:

- [Instalka sterownika v6.1.6-4 dla Graphire 1 & 2 oraz Intuos 1 & 2](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-9/Install-Wacom-Tablet-6.1.6-4-patched.pkg)
- [Instalka sterownika v5.2.6-5 dla Graphire 3](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-9/Install-Wacom-Tablet-5.2.6-5-patched.pkg)
- [Instalka sterownika v5.3.0-3 dla Graphire 4](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-9/Install-Wacom-Tablet-5.3.0-3-patched.pkg)
- [Instalka sterownika v5.3.7-6 dla Bamboo](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-9/Install-Wacom-Tablet-5.3.7-6-patched.pkg)
- [Instalka sterownika v6.3.15-3 dla Intuos 3 oraz Cintiq](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-9/Install-Wacom-Tablet-6.3.15-3-patched.pkg)

Jeżeli wyskoczy błąd z wiadomością, że Mac akceptuje tylko aplikacje pobrane z App Store, kliknij prawym przyciskiem 
myszy na ikonę i wybierz opcję "Otwórz".

Po instalacji, wykonaj kroki podane poniżej w celu ustawienia uprawnień tabletu.

## Ustawienia uprawnień tabletu

Po naciśnięciu piórem na tablet, powinno wyskoczyć okno z pytaniem o uprawnienia tabletu (*Preferencje systemowe* -> 
*Ochrona i prywatność* -> zakładka *Prywatność*).

Na stronie *Dostępność*, naciśnij kłódkę, aby odblokować możliwość edycji. Następnie znajdź i zaznacz pola 
`PenTabletDriver`, `WacomTabletDriver`, `TabletDriver` lub `WacomTabletSpringboard` na liście. Zrób tak samo na stronie 
*Monitorowanie wprowadzania*.

Jeśli twój tablet obsługuje dotyk, naciśnij na tablet i ponownie powinno wyskoczyć okno z uprawnieniami. Na stronie 
*Dostępność* zaznacz pole `ConsumerTouchDriver` lub `WacomTouchDriver`.

W przypadku niektórych tabletów, sterowniki mogą się pojawić tylko na stronie *Monitorowanie wprowadzania*. Wówczas 
należy ponownie zrestartować komputer, aby pola pojawiły się również na stronie *Dostępność*.

### Gdy okno preferencji Wacom, pióro lub dotyk dalej nie działa
Prawdopodobnie dalej korzystasz z uprawnień starych sterowników, które trzeba usunąć w następujący sposób:

Na stronie *Dostępność* okna *Ochrona i prywatność* znajdź wszystko związane z Wacomem na liście (np. `PenTabletDriver`,
`WacomTabletDriver`, `TabletDriver`,  `ConsumerTouchDriver`, `WacomTabletSpringboard`, `WacomTouchDriver`). Zaznacz je 
oraz kliknij przycisk minus, aby się ich pozbyć. Zrób to samo na stronie *Ustawienia wprowadzania*.

Następnie albo zrestartuj komputer, albo wprowadź komendy podane poniżej w *Terminalu*, aby załadować ponownie sterowniki.

Dla tabletów Bamboo i Graphire 3 & 4:

    launchctl unload /Library/LaunchAgents/com.wacom.pentablet.plist

    launchctl load -w /Library/LaunchAgents/com.wacom.pentablet.plist
    
Dla tabletów Graphire 1 & 2, Intuos oraz Cintiq:

    launchctl unload /Library/LaunchAgents/com.wacom.wacomtablet.plist

    launchctl load -w /Library/LaunchAgents/com.wacom.wacomtablet.plist

To powinno przywrócić odpowiednie pola w *Preferencjach systemowych*, więc wróć z powrotem do sekcji wyżej.

### Gdy nic się nie pojawia na stronie *Ustawienia wprowadzania*

Może się tak zdarzyć, że sterownik Wacom nawet się nie pojawia na liście na stronie *Ustawienia wprowadzania*. Aby to 
naprawić, otwórz *Terminal* i wklej komendę podaną poniżej, aby upewnić się, że usługi Wacom są włączone:

Dla tabletów Bamboo i Graphire 3 & 4:

    launchctl load -w /Library/LaunchAgents/com.wacom.pentablet.plist
    
Dla tabletów Graphire 1 & 2, Intuos oraz Cintiq:

    launchctl load -w /Library/LaunchAgents/com.wacom.wacomtablet.plist

Jeżeli te komendy nie wywołają okna z prośbą o zaktualizowanie uprawnień na stronie *Ustawienia wprowadzania* podczas 
używania tabletu, możesz je dodać samemu.

W *Finderze*, kliknij *idź* -> *Idź do folderu...* i skopiuj ścieżkę podaną poniżej, kliknij OK: 

    /Library/Application Support/Tablet/

Powinieneś tam zobaczyć plik "PenTabletDriver" (dla Bamboo), "PenTabletSpringboard" (dla Graphire 3 & 4) lub 
"WacomTabletSpringboard" (dla Graphire 1 & 2, Intuos i Cintiq)

Odblokuj stronę *Ustawienia wprowadzania* za pomocą kłódki. Następnie przeciągnij plik PenTabletDriver / 
PenTabletSpringboard / WacomTabletSpringboard na listę oraz upewnij się, że pole jest zaznaczone. Następnie zresetuj 
komputer. W momencie użycia tabletu, powinno pojawić się okno z ustawieniami *Dostępność*. Teraz powinno już wszystko 
działać.

## Wsparcie autora

Jeżeli dzięki tej aktualizacji sterowników, możesz powrócić do regularnego korzystania ze swojego tabletu, rozważ 
wsparcie autora! 

[![Donate button](https://www.paypalobjects.com/pl_PL/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CDPRHRDZUDZW4&source=url) 

Pieniądze te przeznaczy na dalszy rozwój oraz kolejne aktualizacje tych sterowników.
