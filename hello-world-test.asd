(defsystem "hello-world-test"
  :defsystem-depends-on ("prove-asdf")
  :author "Cameron V Chaparro"
  :license "GPLv3+"
  :depends-on ("hello-world"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "hello-world"))))
  :description "Test system for hello-world"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
