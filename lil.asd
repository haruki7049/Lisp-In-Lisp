(asdf:defsystem :lil
  :class :package-inferred-system
  :version "0.1.0"
  :author "haruki7049"
  :license "MIT"
  :build-operation "program-op"
  :build-pathname "bin/lil"
  :entry-point "lil:main"
  :components ((:file "main")))
