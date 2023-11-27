# Wacom Bamboo, Graphire, Intuos 1+2+3 and Cintiq 1st gen macOS driver fix

Wacom драйверы под macOS для планшетов Bamboo, Graphire, Intuos 1+2+3 и Cintiq 1st gen содержат в себе баги которые не 
дают им запускаться в macOS 10.15 Catalina (а так же возможно в последующих версиях macOS). Эта проблема не относится в 
драйверам для Windows, или к драйверам более свежих планшетов.

Если вы попытаетесь открыть панель настроек Wacom для планшета Bamboo, вы увидите сообщение об ошибке 
"Ожидание синхронизации"/"Waiting for synchronization", а затем - "Возникла проблема с вашим драйвером поланшета. 
Пожалуйста перезапустите систему. Если проблема повторится - переустановите или обновите драйвер."/"There is a problem 
with your tablet driver. Please reboot your system. If the problem persists reinstall or update the driver".
Для планшетов серии Intuos 3 или Cintiq 1st gen, панель настроек открывается, но клик по любому элементу заканчивается 
ошибкой и сообщением "В панели настроек планшета Wacom произошла ошибка"/"There was an error in Wacom Tablet preferences."

Поврежденный драйвер Bamboo (v5.3.7-6) подходит для следующих планшетов:

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

Поврежденный драйвер Graphire 1+2 / Intuos 1+2 driver (v6.1.6-4) подходит для планшетов:

- ET-0405-U - Graphire / Graphire 1 (USB)
- ET-0405-R - Graphire / Graphire 1 (Serial)
- ET-0405A - Graphire 2
- GD-0405-U, GD-0608-U, GD-0912-U, GD-1212-U, GD-1218-U - Intuos (USB) (1998)
- GD-0405-R, GD-0608-R, GD-0912-R, GD-1212-R, GD-1218-R - Intuos (Serial) (1998)
- XD-0405-U, XD-0608-U, XD-0912-U, XD-1212-U, XD-1218-U - Intuos 2 (USB)
- XD-0405-R, XD-0608-R, XD-0912-R, XD-1212-R, XD-1218-R - Intuos 2 (Serial)

Поврежденный драйвер Graphire 3 driver (v5.2.6-5) подходит для планшетов:

- CTE-430, CTE-630 - Graphire 3
- CTE-630BT - Graphire 3 Wireless

Поврежденный драйвер Graphire 4 driver (v5.3.0-3) подходит для планшетов:

- CTE-440, CTE-640 - Graphire 4

Поврежденный драйвер Intuos and Cintiq driver (v6.3.15-3) подходит для планшетов:

- PTZ-430, PTZ-630, PTZ-630SE, PTZ-631W, PTZ-930, PTZ-1230, PTZ-1231W - Intuos 3
- DTZ-2100, DTK-2100 - Cintiq 21UX 1st Gen.
- DTZ-2000 - Cintiq 20WSX

К счастью, я смог отследить ошибки и пропатчил драйверы таким образом чтобы они заработали корректно!

[🇳🇿 English instructions](Readme.md)   
[🇦🇺 Simplified English instructions](Readme.en-simple.md)   
[🇧🇷 / 🇵🇹 Instruções em português](Readme.pt-BR.md)  
[🇯🇵 日本語で表示](Readme.ja-JP.md)   
[🇷🇺 Инструкция на русском языке](Readme.ru-RU.md)   
[🇪🇸 Instrucciones en español](Readme.es.md)   
[🇵🇱 Instrukcja po polsku](Readme.pl.md)   
[🇫🇷 Instructions en français](Readme.fr-FR.md)   

## Установка исправления

Скачайте подходящую версию установщика для вашего планшета и дважды кликните скачаный файл чтобы запустить его- это запустит установку пропатченой мною версии драйвера Wacom:

- [Fixed driver v6.1.6-4 for Graphire 1 & 2 and Intuos 1 & 2 tablets](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-10/Install-Wacom-Tablet-6.1.6-4-patched.pkg)
- [Fixed driver v5.2.6-5 for Graphire 3](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-10/Install-Wacom-Tablet-5.2.6-5-patched.pkg)
- [Fixed driver v5.3.0-3 for Graphire 4](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-10/Install-Wacom-Tablet-5.3.0-3-patched.pkg)
- [Fixed driver v5.3.7-6 for Bamboo](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-10/Install-Wacom-Tablet-5.3.7-6-patched.pkg)
- [Fixed driver v6.3.15-3 for Intuos 3 and Cintiq](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-10/Install-Wacom-Tablet-6.3.15-3-patched.pkg)

Если появится сообщение, что ваш Mac поддерживает только установку приложений из App Store, тогда кликните по скачаному файлу правой(!) кнопкой и выберите в контекстном меню строчку "Открыть".

После установки - следуйте инструкциям в следующем параграфе, чтобы настроить правильные разрешения для драйвера планшета.

## Настройка разрешений(безопасности)

Прикоснитесь кончиком пера к планшету, система должна выдать предупреждение о настройке разрешений и перенаправить вас в Системные настрйоки > Защита и Безопасность > вкладка Конфеденциальность где необхожимо предоставить разрешения доступа для драйверов планшета. 

В разделе "Универсальный доступ" - кликните по значку "Замок" чтобы перейти в режим редактирования, найдите и поставьте галочки возле элементов `PenTabletDriver`, `WacomTabletDriver`, `TabletDriver` или `WacomTabletSpringboard` что вы найдете в списке. Сделайте так же разделе "Мониторинг ввода".

Если ваш планшет поддерживает управление жестами- прикоснитель к нему пальцем. Система вновь попросит вас предоставить необхожимые разрешения.
В разделе "Универсальный доступ" поставьте галочки возле элемента `ConsumerTouchDriver` или `WacomTouchDriver`. 

Для планшетов Intuos 3 и Cintiq, драйвер может появиться только в разделе "Мониторинг ввода" (Input Monitoring), и вам возможно придется сначала перезагрузить компьютер, прежде чем элемент появится в разделе "Универсальный доступ".

**Если ваша панель настроек Wacom, настройки пера или прикосновений не работают, или элементы не отображаются в списке разрешений** скорее всего у вас просто остались старые разрешения от установленного ранее драйвера планшета. Эти неактуальные более записи необходимо удалить следующим образом:

На странице "Универсальный доступ" раздела настроек "Защита и Безопасность" найдите все что относится к драйверу Wacom (например `PenTabletDriver`, 
`WacomTabletDriver`, `TabletDriver`,  `ConsumerTouchDriver`, `WacomTabletSpringboard`, `WacomTouchDriver`), Выберите эти элементы и кликните по кнопке минус, чтобы удалить их из списка. Сделайте то же самое в разделе "Мониторинг ввода\""Input Monitoring".

Теперь либо перезагрузите компьютер, либо выполните следующие команды в терминале, чтобы перезапустить драйвер планшета.
Для планшетов Bamboo и Graphire 3+4:

    launchctl unload /Library/LaunchAgents/com.wacom.pentablet.plist

    launchctl load -w /Library/LaunchAgents/com.wacom.pentablet.plist
    
Для планшетов Graphire 1+2 и Intuos и Cintiq:

    launchctl unload /Library/LaunchAgents/com.wacom.wacomtablet.plist

    launchctl load -w /Library/LaunchAgents/com.wacom.wacomtablet.plist

Эти команды должны вновь открыть диалоговый запрос на предоставление разрешения драйверам планшета. Таким образом вам необходимо предоставить разрешения снова так, как это описано в данном параграфе.

## Поддержите меня

Если вам понравилось, что ваш планшето снова в деле, вы можете прислать мне чаевых!

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/H2H5BAT7Z) 
