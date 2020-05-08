# WACOM Bamboo, Intuos 3, Cintiq第１世代タブレットmacOS 10.15修正ドライバー

WACOM Bamboo, Intuos 3及びCintiq第１世代タブレットがmacOS 10.15 Catalinaでは[バグがある](https://github.com/thenickdude/wacom-driver-fix/blob/master/Readme.md#technical-details-of-the-bugs)為、
近日起動しなくなりました。もしお困りの方は、下記修正ドライバーの作成により再度起動できる様になりましたので是非ご使用ください。

Bamboo修正ドライバー (v5.3.7-6) 対応デバイス：

- CTE-450, CTE-650 - Bamboo Fun / Bamboo Art Master (2007)
- CTE-460 - Bamboo One Pen
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

Intuos/Cintiq修正ドライバー (v6.3.15-3) 対応デバイス：

- PTZ-430, PTZ-630, PTZ-630SE, PTZ-631W, PTZ-930, PTZ-1230, PTZ-1231W - Intuos 3
- DTZ-2100 - Cintiq 21UX 1st Gen.
- DTZ-2000 - Cintiq 20WSX

[🇳🇿 English installation instructions](Readme.md)

## 修正ドライバーインストール方法

1) お持ちのタブレットに適用する修正ドライバーを下記からダウンロードし、インストールしてください。

- [Bamboo修正ドライバー (v5.3.7-6)](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-5/Install-Wacom-Tablet-5.3.7-6-patched.pkg)
- [Intuos/Cintiq修正ドライバー (v6.3.15-13)](https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-5/Install-Wacom-Tablet-6.3.15-3-patched.pkg)

2) 古いドライバーの制限を消去してください。

- アップルメニュー から「システム環境設定」→「セキュリティとプライバシー」を選択。
- 「プライバシー」のタブから「アクセシビリティ」を選択し、変更スタート。(左下にある鍵アイコンをクリックする必要、及び、パスワードをご使用の方はユーザー名とパスワードを入力する必要あり)
- リストから現在許可されているWACOMのアイテム (PenTabletDriver, ConsumerTouchDriverなど)を\[-]ボタンをクリックし、諸々消去。
- 同じく「入力監視」でも上記をリピート。
- 設定を保存し、パソコンを再起動。

![古い権限を削除](screenshots/ja-JP/security-and-privacy-delete.jpg)

これで、新しい修正ドライバーのアクセス許可を追加できます。

3) タッチペンでタブレットを1回タッチし、新しいアクセス許可を作動させてください。

4) 新しいアクセス許可を確認してください。

- 同じくアップルメニューから「システム環境設定」→「セキュリティとプライバシー」を選択。
- 「プライバシー」のタブから「アクセシビリティ」を選択し、変更スタート。(左下にある鍵アイコンをクリックする必要、及び、パスワードをご使用の方はユーザー名とパスワードを入力する必要あり)
- 新しく再起動後追加されたWACOMのアイテム (PenTabletDriver, ConsumerTouchDriverなど) がチェックされているか確認。
- 同じく「入力監視」でも上記を確認。
- 設定を保存。

![新しい権限を追加](screenshots/ja-JP/security-and-privacy-tick.jpg)

これでタブレットが以前通り起動するはずです。もし起動しない場合はもう１度パソコンを再起動すれば、起動するはずです。

## サポートお願い

再びタブレットを使用する事ができましたら、是非寄付金を送って頂ければ幸いです。

[![寄付ボタン](https://www.paypalobjects.com/ja_JP/JP/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CDPRHRDZUDZW4&source=url) 

あなたの寄付が今後のドライバーのさらなる発展に役立ちます。
