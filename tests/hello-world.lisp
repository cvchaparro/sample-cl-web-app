(in-package :cl-user)
(defpackage hello-world-test
  (:use :cl
        :hello-world
        :prove))
(in-package :hello-world-test)

(plan nil)

;; blah blah blah.

(finalize)
