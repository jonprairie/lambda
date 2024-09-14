(defpackage #:lambda.test
  (:use #:cl #:fiveam #:named-readtables #:lambda))
(in-package #:lambda.test)

(in-readtable syntax)

(def-suite anon)
(in-suite anon)

(test anon-test
  (is (= 5 (funcall (λx - x 7) 12)))
  (is (= 6 (reduce (λxy + x y) (list 1 2 3))))
  (is (equal (list 3 6 9)
             (mapcar (λxyz + x y z) (list 1 2 3) (list 1 2 3) (list 1 2 3)))))
