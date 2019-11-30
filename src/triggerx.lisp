(in-package :cl-state-machine)


(defparameter *trigger-schedules* '())

(defparameter *trigger-history* '())


(defun make-trigger-schedule-entry (event args)
  (cons event args))

(defun trigger-schedule-entry-event (a-trigger-schedule-entry)
  (car a-trigger-schedule-entry))

(defun trigger-schedule-entry-args (a-trigger-schedule-entry)
  (cdr a-trigger-schedule-entry))

(defun schedule-next-trigger (event &rest args)
  (append-f *trigger-schedules*
            `(,(make-trigger-schedule-entry event args))))

(defun pop-next-scheduled-trigger ()
  "`nil' if there's no entry in `*trigger-schedules*'."
  (pop *trigger-schedules*))

(defun empty-next-trigger-schedules ()
  (setf *trigger-schedules* '()))

(defun append-trigger-history (trigger!-values-list)
  (append-f *trigger-history* (list trigger!-values-list)))

(defun empty-trigger-history ()
  (setf *trigger-history* '()))


(defmacro with-own-trigger-schedules-and-history
    ((&key (schedules '())
        (history '()))
     &rest body)
  `(let ((*trigger-schedules* ,schedules)
         (*trigger-history* ,history))
     ,@body
     (list :schedules *trigger-schedules*
           :history *trigger-history*)))

