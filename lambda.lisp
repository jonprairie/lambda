;;;; lambda.lisp

(in-package #:lambda)

(eval-when (:compile-toplevel :load-toplevel :execute)
  ;; i don't know if this is strictly necessary. i should probably look into when
  ;; read-lambda is _actually_ required.
  (defun read-lambda (stream char)
    (declare (ignore char))
    (let* ((lambda-parms (string (read stream t nil nil)))
           (bound-vars (mapcar #'intern (split "" lambda-parms :regex t :omit-nulls t)))
           (body (read-delimited-list #\) stream)))
      ;; push the end-paren that we consumed in read-delimited-list back onto the stream
      ;; so the open-paren from just before the λ can terminate.
      (unread-char #\) stream)
      ;; we have to return a wrapped lambda since we're building and returning a new
      ;; list while the enclosing parentheses are still there. this structure results
      ;; in an empty call which will return the actual lambda we care about.
      ;; it'd be really nice if we could return multiple values here and populate the
      ;; enclosing parentheses directly but according to HS[0] it's against the law
      ;; to do directly. there may be a way to get around all this with some
      ;; macro/symbol-macro/reader-macro wizardry but i have yet to figure it out. in
      ;; the meantime the main downside of doing it this way is that the λ expression
      ;; can't be used at the head of a list in the same way a (lambda () ...)
      ;; expression can.
      ;; [0] https://www.cliki.net/Issue%20READER-MACRO-VALUES
      `(lambda ()
         (lambda ,bound-vars ,body)))))

(defreadtable lambda::syntax
  (:merge :common-lisp)
  (:macro-char #\λ 'read-lambda)
  (:case :upcase))

(defun use-syntax ()
  (in-readtable syntax))
