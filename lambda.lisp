;;;; lambda.lisp

(in-package #:lambda)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun make-lambda (lambda-str body &optional (splice-body-p t))
    (let* ((split-lambda-str (split "Λ" lambda-str))
           (lambda-str-head  (first split-lambda-str))
           (bound-vars-str   (split "" lambda-str-head :regex t :omit-nulls t))
           (bound-vars       (if bound-vars-str (mapcar #'intern bound-vars-str) nil)))
      (if (rest split-lambda-str)
          `(lambda ,bound-vars
             ,(make-lambda (join "Λ" (rest split-lambda-str))
                           body splice-body-p))
          (if splice-body-p
              `(lambda ,bound-vars ,@body)
              `(lambda ,bound-vars ,body)))))
  (defun read-lambda (stream char)
    (let ((next-char (peek-char t stream)))
      (if (eq next-char #\λ)
          (progn
            (read-char stream)
            (let* ((ws-p            (find (peek-char nil stream) *whitespaces*))
                   (dot-p           (when (eq #\. (peek-char nil stream)) (read-char stream)))
                   (input-str       (if (or ws-p dot-p) "" (upcase (string (read stream)))))
                   (splice-body-p   (not (or (string= (s-last input-str) ".") dot-p)))
                   (lambda-parm-grp (remove-punctuation input-str :replacement ""))
                   (body            (read-delimited-list #\) stream)))
              (make-lambda lambda-parm-grp body splice-body-p)))
          (funcall (get-macro-character
                    #\(
                    (find-readtable :common-lisp))
                   stream char)))))

(defreadtable lambda::syntax
  (:merge :common-lisp)
  (:macro-char #\( 'read-lambda)
  (:case :upcase))

(defun use-syntax ()
  (in-readtable syntax))
