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
