;;;; lambda.asd

(asdf:defsystem #:lambda
  :description "simple lambda shorthand: λxyz..."
  :author "jonnyp augustus.seizure.1@gmail.com"
  :license  "MIT"
  :version "0.0.1"
  :serial t
  :depends-on (#:named-readtables #:str #:alexandria)
  :components ((:file "package")
               (:file "lambda"))
  :in-order-to ((test-op (test-op "lambda/test"))))

(asdf:defsystem #:lambda/test
  :description "tests for lambda"
  :author "jonnyp augustus.seizure.1@gmail.com"
  :license  "MIT"
  :version "0.0.1"
  :pathname "t/"
  :serial t
  :depends-on (#:lambda #:fiveam #:named-readtables)
  :components ((:file "lambda"))
  :perform (test-op (o s)
                    (uiop:symbol-call :fiveam '#:run-all-tests)))
