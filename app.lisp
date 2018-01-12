(defpackage :retro-games
  (:use :cl :cl-who :hunchentoot :parenscript))

(in-package :retro-games)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; define the structure of a game

(defclass game ()
  ((name :reader name
         :initarg :name)
   (votes :accessor votes
          :initform 0)))

(defmethod vote-for (user-selected-game)
  (incf (votes user-selected-game)))

(defvar *games* nil)

(defun game-from-name (name)
  (find name *games* :test #'string-equal
                     :key #'name))

(defun game-stored-p (name)
  (game-from-name name))

(defun games ()
  (sort (copy-list *games*) #'> :key #'votes))

(defun add-game (name)
  (unless (game-stored-p name)
    (push (make-instance 'game :name name) *games*)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; define the web app

(defmacro standard-page ((&key title) &body body)
  `(with-html-output-to-string (*standard-output* nil :prologue t :indent t)
     (:html :xmlns "http://www.w3.org/1999/xhtml"
            :xml\:lang "en"
            :lang "en"
            (:head
             (:meta :http-equiv "Content-Type"
                    :content "text/html;charset=utf-8")
             (:title ,title)
             (:link :type "text/css"
                    :rel "stylesheet"
                    :href "/retro.css"))
            (:body
             (:div :id "header"
                   (:img :src "/logo.jpg"
                         :alt "Commodore 64"
                         :class "logo")
                   (:span :class "strapline"
                          "Vote on your favourite Retro Game!"))
             ,@body))))

(defmacro define-url-fn ((name) &body body)
  `(progn
     (defun ,name ()
       ,@body)
     (push (create-prefix-dispatcher ,(format nil "/~(~a~).htm" name) ',name) *dispatch-table*)))

(define-url-fn (retro-games)
  (standard-page
      (:title "Top Retro Games")
    (:h1 "Vote on all your favourite retro games!")
    (:p "Missing a game? Make it available for votes "
        (:a :href "new-game.htm" "here"))
    (:h2 "Current Stand")
    (:div :id "chart"
          (:ol
           (dolist (game (games))
             (htm
              (:li
               (:a :href (format nil "vote.htm?name=~a" (name game)) "Vote!")
               (fmt "~A with ~d votes" (name game) (votes game)))))))))
