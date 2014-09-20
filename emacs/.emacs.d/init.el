;;;; 見た目の設定
;; メニューバーを非表示に
(menu-bar-mode 0)
;; ツールバーを非表示に
(tool-bar-mode 0)
;; スクロールバーを非表示に
(scroll-bar-mode 0)
;; モードラインにカーソル位置の行番号を表示
(line-number-mode 1)
;; モードラインにカーソル位置の列番号を表示
(column-number-mode 1)
;; カーソル位置の行を強調表示する
(global-hl-line-mode t)
;; 起動時のメッセージを非表示にする
(setq inhibit-startup-message t)
;; yesかnoではなく、yかnで答えられるようにする
(defalias 'yes-or-no-p 'y-or-n-p)
;; ダイヤログボックスを使わないようにする
(setq use-dialog-box nil)
;; 対応する括弧を強調表示する
(show-paren-mode t)
;; 背景色設定
(custom-set-faces
 '(default ((t (:background "#111111" :foreground "#EEEEEE"))))
;;カーソル
 '(cursor (
           (((class color) (background dark )) (:background "#2e8b57"))
           (((class color) (background light)) (:background "#999999"))
	   (t ())
           )))
;; フレーム透過設定
(add-to-list 'default-frame-alist '(alpha . (0.90 0.90)))
;; 常にバッファ左に行番号を表示する
(global-linum-mode 1)
;; 行番号の表示領域(モードラインの)として、4桁分をあらかじめ確保する
(setq linum-format "%4d")
;; カーソルがどの関数の中にあるかをモードラインに表示する
(which-function-mode 1)


;;;;;; 見た目以外の設定
;;;; パッケージシステムを有効化(Marmalade、MELPA)する(Emacs24~から有効)
;;;; @note init.elのできるだけ前の方で設定しておく
;; ELPAの設定
(when (require 'package nil t)
  ;; パッケージリポジトリにMELPAと開発者運営のELPA、marmaladeを追加
  (add-to-list 'package-archives
	       '("melpa" . "http://melpa.milkbox.net/packages/"))
  (add-to-list 'package-archives
	       '("ELPA" . "http://tromey.com/elpa/"))
  (add-to-list 'package-archives
	       '("marmalade" . "http://marmalade-repo.org/packages/"))
  ;; インストールしたパッケージにロードパスを通してロードする
  (package-initialize))

;; shell使用時の日本語文字化け回避
(setq locale-coding-system 'utf-8)
;; ガベッジコレクションを実行するまでの割当てメモリ閾値を増やす
(setq gc-cons-threshold (* 50 gc-cons-threshold))
;; kill-lineで行末文字も削除する
(setq kill-whole-line t)
;; ログの記録量を増やす
(setq message-log-max 10000)
;; 履歴在数を増やす
(setq history-length 1000)
;; 重複する履歴は保存しない
(setq history-delete-duplicates t)


;;;; キーバインドの設定
;; カーソル前の文字を1文字消す
;; \はwindowsで¥なので、エラるからos分岐した方がいいかも
(global-set-key "\C-h" 'delete-backward-char)
;; カーソル前の1語を削除する
(global-set-key (kbd "M-h") 'backward-kill-word)
;; 入力した行にジャンプする
(global-set-key (kbd "M-g") 'goto-line)
;; 改行して、インデントの調整を行う
(global-set-key (kbd "C-m") 'newline-and-indent)
;; エラー行へのジャンプ(コンパイルやgrep,ag.el時に)
(global-set-key [f8] 'next-error)
(global-set-key [f7] 'previous-error)


;;;; 履歴の設定
(require 'recentf)
(setq recentf-save-file "~/.recentf")
(setq rexentf-exclude '("~.recentf"))
(setq recentf-max-saved-items 5000)
(setq resentf-auto-cleanup '10)
(run-with-idle-timer 30 t 'recentf-save-list)
(recentf-mode 1)


;;;; Emacsの起動と終了周りの設定
;; emacs server(emacsをデーモン起動するための設定)
(require 'server)
(unless (server-running-p)
(server-start))


;;デバッグモードでの起動
;; おまじない
(require 'cl)
(setq inhibit-startup-screen t)


;;;; load-path周りの設定
;; Emacs 23より前のバージョンを利用している方は
;; user-emacs-directory変数が未定義のため次の設定を追加
(when (< emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d/"))

;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")


;; 分割したファイルを自動的に読み込む拡張機能
;; http://coderepos.org/share/browser/lang/elisp/init-loader/init-loader.el


;;;; 拡張の設定
;;;; auto-completeの設定
(when (require 'auto-complete-config nil t)
   (add-to-list 'ac-dictionary-directories
		"-/.emacs.d/elisp/ac-dict")
(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
(ac-config-default))


;; (require 'web-mode)
;;    ;; 自動的にWeb-modeを起動したい拡張子を追加する
;;    (add-to-list 'auto-mode-alist '("\\.phtml\\'" . Web-mode))
;;    (add-to-list 'auto-mode-alist '("\\.tpl\\.php'" . Web-mode))
;;    (add-to-list 'auto-mode-alist '("\\.ctp\\'" . Web-mode))
;;    (add-to-list 'auto-mode-alist '("\\.jsp\\'" . Web-mode))
;;    (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . Web-mode))
;;    (add-to-list 'auto-mode-alist '("\\.erb\\'" . Web-mode))
;;    (add-to-list 'auto-mode-alist '("\\.mustache\\'" . Web-mode))
;;    (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . Web-mode))
;; (add-to-list 'auto-mode-alist '("\\.js\\'" . Web-mode))
;;   ;;; Web-modeのインデント設定用フック
;;    (defun Web-mode-hook ( )
;;      "Hooks for Web mode."
;;      (setq Web-mode-markup-indent-offset 2) ; HTMLのインデント
;;      (setq Web-mode-css-indent-offset 2) ; CSSのインデント
;;      (setq Web-mode-code-indent-offset 2) ; PHP, Rubyなどのインデント
;;     (setq web-mode-script-indent-offset 2) ; JSのインデント
;;      (setq web-mode-php-indent-offset    2) ; PHPのインデント
;;      (setq web-mode-java-indent-offset  2) ; javaのインデント
;;      (setq web-mode-asp-indent-offset    2) ; aspのインデント
;;      (setq Web-mode-code-indent-offset 2) ; Ruby, perlなどのインデント
;;      (setq Web-mode-comment-style 2) ; Web-mode内のコメントのインデント
;;      (setq Web-mode-style-padding 1) ; <style>内のインデント開始レベル
;;      (setq Web-mode-script-padding 1)) ; <script>内の印伝と開始レベル
;;    (add-hook 'Web-mode-hook 'Web-mode-hook)

;; ;; web mode
;; ;; http://web-mode.org/
;; ;; http://yanmoo.blogspot.jp/2013/06/html5web-mode.html
;; (require 'web-mode)

;; ;; markup
;; (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.xhtml\\'" . Web-mode))
;; ;;(add-to-list 'auto-mode-alist '("\\.css\\'" . Web-mode))
;; ;; css プリプロセッサ
;; (add-to-list 'auto-mode-alist '("\\.scss\\'" . Web-mode))
;; ;; serialize
;; (add-to-list 'auto-mode-alist '("\\.xml\\'" . Web-mode))
;; (add-to-list 'auto-mode-alist '("\\.json\\'" . Web-mode))
;; ;; script
;; (add-to-list 'auto-mode-alist '("\\.js\\'" . Web-mode))
;; (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . Web-mode))
;; (add-to-list 'auto-mode-alist '("\\.sh\\'" . Web-mode))
;; ;; python
;; (add-to-list 'auto-mode-alist '("\\.py\\'" . Web-mode))
;; ;; perl
;; (add-to-list 'auto-mode-alist '("\\.pl\\'" . Web-mode))
;; ;; java 
;; (add-to-list 'auto-mode-alist '("\\.jsp\\'" . Web-mode))
;; ;; php
;; (add-to-list 'auto-mode-alist '("\\.ctp\\'"   . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.tpl\\.php'" . Web-mode))
;; (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . Web-mode))
;; ;; ruby
;; (add-to-list 'auto-mode-alist '("\\.erb\\'" . Web-mode))
;; (add-to-list 'auto-mode-alist '("\\.rb\\'" . Web-mode))
;; ;; other
;; (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . Web-mode))
;; (add-to-list 'auto-mode-alist '("\\.mustache\\'" . Web-mode))
;; (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . Web-mode))
;; ;; web-modeの設定
;; (defun web-mode-hook ()
;;   (setq web-mode-markup-indent-offset 2)
;;   (setq web-mode-css-indent-offset 2)
;;   (setq web-mode-code-indent-offset 2)
;;   (setq Web-mode-markup-indent-offset 2) ; HTMLのインデント
;;   (setq Web-mode-css-indent-offset 2) ; CSSのインデント
;;   (setq web-mode-script-indent-offset 2) ; JSのインデント
;;   (setq web-mode-javascript-indent-offset 2) ; JSのインデント
;;   (setq web-mode-php-indent-offset    2) ; PHPのインデント
;;   (setq web-mode-java-indent-offset   4) ; javaのインデント
;;   (setq web-mode-asp-indent-offset    2) ; aspのインデント
;;   (setq Web-mode-code-indent-offset 2) ; Ruby, perlなどのインデント
;;   (setq Web-mode-comment-style 2) ; Web-mode内のコメントのインデント
;;   (setq Web-mode-style-padding 1) ; <style>内のインデント開始レベル
;;   (setq Web-mode-script-padding 1) ; <script>内の印伝と開始レベル

;;   (setq web-mode-engines-alist
;;         '(("php"    . "\\.ctp\\'"))
;;         )
;;   )

;; (add-hook 'web-mode-hook  'web-mode-hook)

;; ;; 色の設定
;; (custom-set-faces
;;  '(web-mode-doctype-face
;;    ((t (:foreground "#82AE46"))))
;;  '(web-mode-html-tag-face
;;    ((t (:foreground "#E6B422" :weight bold))))
;;  '(web-mode-html-attr-name-face
;;    ((t (:foreground "#C97586"))))
;;  '(web-mode-html-attr-value-face
;;    ((t (:foreground "#82AE46"))))
;;  '(web-mode-comment-face
;;    ((t (:foreground "#D9333F"))))
;;  '(web-mode-server-comment-face
;;    ((t (:foreground "#D9333F"))))
;;  '(web-mode-css-rule-face
;;    ((t (:foreground "#A0D8EF"))))
;;  '(web-mode-css-pseudo-class-face
;;    ((t (:foreground "#FF7F00"))))
;;  '(web-mode-css-at-rule-face
;;    ((t (:foreground "#FF7F00"))))
;; )


;;;; emmet-modeの設定
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; マークアップ言語全部で使う
(add-hook 'css-mode-hook  'emmet-mode) ;; CSSにも使う
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 2))) ;; indent はスペース2個
(eval-after-load "emmet-mode"
  '(define-key emmet-mode-keymap (kbd "C-j") nil)) ;; C-j は newline のままにしておく
(keyboard-translate ?\C-i ?\H-i) ;;C-i と Tabの被りを回避
(define-key emmet-mode-keymap (kbd "H-i") 'emmet-expand-line) ;; C-i で展開


;;;; Flymake(文法チェック)周りの設定
;; Makefileがあれば利用し、なければ直接コマンドを実行する
(require 'flymake)
;; Makefileの種類を定義
(defvar flymake-makefile-filenames
  '("Makefile" "makefile" "GNUmakefile")
  "File names for make.")
;; Makefileがなければコマンドを直接利用するコマンドラインを生成
(defun flymake-get-make-gcc-cmdline (source base-dir)
  (let (found)
    (dolist (makefile flymake-makefile-filenames)
      (if (file-readable-p (concat base-dir "/" makefile))
          (setq found t)))
    (if found
        (list "make"
              (list "-s"
                    "-C"
                    base-dir
                    (concat "CHK_SOURCES=" source)
                    "SYNTAX_CHECK_MODE=1"
                    "check-syntax"))
      (list (if (string= (file-name-extension source) "c") "gcc" "g++")
            (list "-o"
                  "/dev/null"
                  "-fsyntax-only"
                  "-Wall"
                  source)))))

;; Flymake初期化関数の生成
(defun flymake-simple-make-gcc-init-impl
  (create-temp-f use-relative-base-dir
                 use-relative-source build-file-name get-cmdline-f)
  "Create syntax check command line for a directly checked source file.
Use CREATE-TEMP-F for creating temp copy."
  (let* ((args nil)
         (source-file-name buffer-file-name)
         (buildfile-dir (file-name-directory source-file-name)))
    (if buildfile-dir
        (let* ((temp-source-file-name
                (flymake-init-create-temp-buffer-copy create-temp-f)))
          (setq args
                (flymake-get-syntax-check-program-args
                 temp-source-file-name
                 buildfile-dir
                 use-relative-base-dir
                 use-relative-source
                 get-cmdline-f))))
    args))

;; 初期化関数を定義
(defun flymake-simple-make-gcc-init ()
  (message "%s" (flymake-simple-make-gcc-init-impl
                 'flymake-create-temp-inplace t t "Makefile"
                 'flymake-get-make-gcc-cmdline))
  (flymake-simple-make-gcc-init-impl
   'flymake-create-temp-inplace t t "Makefile"
   'flymake-get-make-gcc-cmdline))

;; 拡張子 .c, .cpp, c++などのときに上記の関数を利用する
(add-to-list 'flymake-allowed-file-name-masks
             '("\\.\\(?:c\\(?:pp\\|xx\\|\\+\\+\\)?\\|CC\\)\\'"
               flymake-simple-make-gcc-init))


;; XML用Flymakeの設定
(defun flymake-xml-init ()
  (list "xmllint" (list "--valid"
                        (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))))


;; HTML用Flymakeの設定
(defun flymake-html-init ()
  (list "tidy" (list (flymake-init-create-temp-buffer-copy
                      'flymake-create-temp-inplace))))

(add-to-list 'flymake-allowed-file-name-masks
             '("\\.html\\'" flymake-html-init))

;; tidy error pattern
(add-to-list 'flymake-err-line-patterns
'("line \\([0-9]+\\) column \\([0-9]+\\) - \\(Warning\\|Error\\): \\(.*\\)"
  nil 1 2 4))


;; JavaScript
;; JS用Flymakeの初期化関数の定義
;;(defun flymake-jsl-init ()
;;  (list "jsl" (list "-process" (flymake-init-create-temp-buffer-copy
;;                                'flymake-create-temp-inplace))))
;; JavaScript編集でFlymakeを起動する
;;(add-to-list 'flymake-allowed-file-name-masks
;;             '("\\.js\\'" flymake-jsl-init))

;;(add-to-list 'flymake-err-line-patterns
;; '("^\\(.+\\)(\\([0-9]+\\)): \\(.*warning\\|SyntaxError\\): \\(.*\\)"
;;   1 2 nil 4))


;; JavaScript
;; Flaymake-Jshintを使ったリアルタイム文法チェック(http://safx-dev.blogspot.jp/2013/05/emacsflymake-jshintjavascript.html)
;; install
;;  * js2-mode (https://code.google.com/p/js2-mode/)
;;  * npm
;;  * flymake-jshint(MELPA)
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))


(add-hook 'js2-mode-hook '(lambda ()
          (require 'flymake-jshint)
          (flymake-jshint-load)))

;; 設定が反映されない場合、以下のパスの指定をする
;; (setq exec-path (append exec-path '("/usr/local/share/npm/bin")))
;; (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))


;; Ruby
;; Ruby用Flymakeの設定
(defun flymake-ruby-init ()
  (list "ruby" (list "-c" (flymake-init-create-temp-buffer-copy
                           'flymake-create-temp-inplace))))

(add-to-list 'flymake-allowed-file-name-masks
             '("\\.rb\\'" flymake-ruby-init))

(add-to-list 'flymake-err-line-patterns
             '("\\(.*\\):(\\([0-9]+\\)): \\(.*\\)" 1 2 nil 3))


;; Python
;; Python用Flymakeの設定(拡張機能が必要)
;; install to elisp "https://raw.github.com/seanfisk/emacs/sean/src/flymake-python.el"
(when (require 'flymake-python nil t)
  ;; flake8を利用する
  (when (executable-find "flake8")
    (setq flymake-python-syntax-checker "flake8"))
  ;; pep8を利用する
  ;; (setq flymake-python-syntax-checker "pep8")
  )

;;;; This snippet enables lua-mode

    ;; This line is not necessary, if lua-mode.el is already on your load-path
    (add-to-list 'load-path "/path/to/directory/where/lua-mode-el/resides")

    (autoload 'lua-mode "lua-mode" "Lua editing mode." t)
    (add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
    (add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

;;;; multi-termの設定
(require 'multi-term nil t)
;; 使用するシェルを指定
(setq multi-term-program "/bin/zsh")


;;;; popup-select-windowの設定
;; install to http://www.emacswiki.org/emacs/popup-select-window.el
;; auto-completeも必要 http://cx4a.org/pub/auto-complete/auto-complete-1.2.tar.bz2
(require 'popup)
(require 'popup-select-window)
(global-set-key "\C-xo" 'popup-select-window) ;; C-x oにpopup-select-windowをバインド
(setq popup-select-window-popup-windows 2) ;; ウィンドウが2つ以上存在する際にポップアップ表示する
(setq popup-select-window-window-highlight-face '(:foreground "white" :background "orange")) ;; 選択中のウィンドウは、背景をオレンジにして目立たせる


;;;; ディレクトリツリー表示
;; http://d.hatena.ne.jp/CortYuming/20120830/p1
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)

(require 'direx)
(setq direx:leaf-icon "  "
      direx:open-icon "-; "
      direx:closed-icon "+ ")
(push '(direx:direx-mode :position left :width 25 :dedicated t)
      popwin:special-display-config)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory-other-window)
;; direx-el
;; (use popwin-el devloper ver.)
;; https://github.com/m2ym/direx-el
;; (require 'direx)
(require 'direx-project)
(setq direx:leaf-icon "  "
      direx:open-icon "- "
      direx:closed-icon "+ ")
(push '(direx:direx-mode :position left :width 50 :dedicated t)
      popwin:special-display-config)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory-other-window)


;;;; helmの設定
;;;; @note 他のelispと依存性が高いので最後に記述しておく
(require 'helm-config)
(define-key global-map (kbd "C-x C-f") 'helm-for-files)
(define-key global-map (kbd "C-x b")   'helm-buffers-list)
(define-key global-map (kbd "C-c s")     'helm-occur)


;;;; migemoの設定
;;(require 'helm-migemo) ;; migeoが設定されているなら有効になる
;; helmコマンドで migemo を有効にする
;;(setq helm-migemize-command-idle-delay helm-idle-delay)
;;(helm-migemize-command helm-for-files)
;;(helm-migemize-command helm-firefox-bookmarks)


;;;; helmの他の設定
;;(require 'helm-descbinds)
;;(require 'helm-gtags)
