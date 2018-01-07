;;; matcha.el --- Integration with Hydra. -*- lexical-binding: t -*-

;; Copyright (C) 2017 James Nguyen

;; Author: James Nguyen <james@jojojames.com>
;; Maintainer: James Nguyen <james@jojojames.com>
;; URL: https://github.com/jojojames/matcha
;; Version: 0.0.1
;; Package-Requires: ((emacs "25.1"))
;; Keywords: hydra, emacs
;; HomePage: https://github.com/jojojames/matcha

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;; Integration with Hydra.

;;; Code:

;; Compatibility
(eval-and-compile
  (when (version< emacs-version "26")
    (with-no-warnings
      (defalias 'if-let* #'if-let)
      (defalias 'when-let* #'when-let)
      (function-put #'if-let* 'lisp-indent-function 2)
      (function-put #'when-let* 'lisp-indent-function 1))))

(require 'matcha-base)
(require 'matcha-elisp)

(defgroup matcha nil
  "Collection of hydras and a common way to launch them."
  :group 'tools
  :group 'convenience)

(defcustom matcha-mode-list
  '(alchemist
    android-mode
    dired
    erlang
    geiser
    gud-lldb
    json-mode
    lua-mode
    motion-mode
    notmuch
    python
    restclient
    ruby-mode
    smerge-mode
    swift-mode
    web-mode
    xcode-mode)
  "The list of modes for which a hydra will be defined."
  :type '(repeat (choice symbol sexp))
  :group 'matcha)

(defcustom matcha-use-launcher-p t
  "Whether or not to use hydra launcher."
  :type 'bool
  :group 'matcha)

;;;###autoload
(defun matcha-setup ()
  "Set up hydras."
  (interactive)
  (dolist (mode matcha-mode-list)
    (let ((m mode)
          (reqs (list mode)))
      (when (listp mode)
        (setq m (car mode)
              reqs (cdr mode)))
      (dolist (req reqs)
        (with-eval-after-load req
          (require
           (intern (concat "matcha-" (symbol-name m))))
          (when matcha-use-launcher-p
            (let ((setup-function
                   (intern
                    (concat "matcha-" (symbol-name m) "-set-launcher"))))
              (when (fboundp setup-function)
                (funcall setup-function)))))))))

(with-eval-after-load 'cider
  (require 'matcha-clojure))

(with-eval-after-load 'lisp-mode
  (require 'matcha-commonlisp))

;; FIXME: This needs to go into a `cc-mode'.
(with-eval-after-load 'java-mode
  (require 'matcha-java))

(with-eval-after-load 'js-mode
  (require 'matcha-javascript))

(with-eval-after-load 'js2-mode
  (require 'matcha-javascript))

(autoload 'matcha-magit/body "matcha-magit" nil t)
(with-eval-after-load 'magit
  (require 'matcha-magit))

(with-eval-after-load 'meghanada
  (require 'matcha-meghanada))

(with-eval-after-load 'omnisharp
  (require 'matcha-csharp))

(with-eval-after-load 'org
  (require 'matcha-org))

(autoload 'matcha-p4/body "matcha-p4" nil t)
(with-eval-after-load 'p4
  (require 'matcha-p4))

(with-eval-after-load 'pass
  (require 'matcha-pass))

(autoload 'matcha-projectile/body "matcha-projectile" nil t)
(with-eval-after-load 'projectile
  (require 'matcha-projectile))

(with-eval-after-load 'rjsx-mode
  (require 'matcha-javascript))

(with-eval-after-load 'rtags
  (require 'matcha-rtags))

(with-eval-after-load 'term
  (require 'matcha-term))

(with-eval-after-load 'typescript-mode
  (require 'matcha-typescript))

(provide 'matcha)
;;; matcha.el ends here
;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved noruntime cl-functions obsolete)
;; End:
