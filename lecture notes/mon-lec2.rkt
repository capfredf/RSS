#lang racket


(require (for-syntax syntax/parse)
         rackunit)

;; Mon-Lec2

;; An AlgExpr is one of := (function-application AlgExpr AlgExpr)
;; -- (if AlgExpr AlgExpr AlgExpr)
;; -- (+ AlgExpr AlgExpr)
;; -- Variable
;; -- Number
;; -- String


(define-syntax (define-function stx)
  (syntax-parse stx
    [(_ (name:id param:id ...) body:expr)
     (define arity (length (syntax->list #'(param ...))))
     #`(define-syntax name
         (cons #,arity (λ (param ...) body)))]))


(define-syntax (function-app stx)
  (syntax-parse stx
    ((_ proc-name:id arg:expr ...)
     #:do ((define-values (arity function) (lookup #'proc-name stx)))
     #:fail-unless (= arity (length (syntax->list #'(arg ...)))) "wrong number of arguments"
     #`(#,function arg ...))))

(define-for-syntax (lookup proc-name stx)
  (define (when-it-fails)
    (raise-syntax-error #f "not defined" stx))
  (define x (syntax-local-value proc-name when-it-fails))
  (values (car x) (cdr x)))



(define-function (f x y) (+ x y))
(check-equal? (function-app f 1 2) 3)

(define-function (g x) (if (zero? x) 1 2))
(check-equal? (function-app g 1) 2)





; (function-app h 0) <-- gets highlighted because h is undefined

