(defpackage #:lambda.test
  (:use #:cl #:fiveam #:named-readtables #:lambda))
(in-package #:lambda.test)

(in-readtable syntax)

(test readme-test
  (is (= ((λ 5)) 5))
  (is (equal (mapcar (λx. + x 1) (list 1 2 3 4 5))
             (list 2 3 4 5 6)))
  (is (= (reduce (λxy. + x y) (loop for x from 1 to 100 collect x))
         5050))
  (is (string= ((λx. format nil "are we scheme? ~a" x) "...close, but not quite")
               "are we scheme? ...close, but not quite"))
  (is (= (funcall ((λxλy. + x y) 1) 2)
         3))
  (is (string= (when (= ((λx (+ x 1)) 1)
                        (1+ 1))
                 "1+ again")
               "1+ again"))
  (is (string= (funcall
                (funcall
                 (funcall
                  (funcall
                   (funcall
                    (funcall
                     (funcall
                      (funcall
                       ((λa.λb.λc.λd.λe.λf.λg.λh.λi "for readability")
                        nil)
                       nil)
                      nil)
                     nil)
                    nil)
                   nil)
                  nil)
                 nil)
                nil)
               "for readability")))
