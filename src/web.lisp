(in-package :cl-user)
(defpackage hello-world.web
  (:use :cl
        :caveman2
        :hello-world.config
        :hello-world.view
        :hello-world.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :hello-world.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

;;
;; Routing rules

(defroute "/" ()
  (render #P"index.html"))

(defroute "/greet" (&key _parsed)
  (let ((name (cdadr (assoc "person" _parsed :test #'string=))))
    (render #P"greet.html"
            `(:name ,name))))

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
