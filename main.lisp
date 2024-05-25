;;(uiop:define-package #:lil
(defpackage :lil
  (:nicknames :lil/main)
  (:use :cl)
  (:export :main))

(in-package #:lil/main)

(defun main (&rest args)
  (format T "Hello, Lisp-In-Lisp"))
