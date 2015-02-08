;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname main) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))

;; Floobits workspace: https://floobits.com/stl-racket-laptop/HtDP2e/
;; L-99: Ninety-Nine Lisp Problems: http://bit.ly/1j0BQP8

;; P01

(define (my-last lst)
  (if (empty? (rest lst)) (first lst)
    (my-last (rest lst))))

(check-expect (my-last (list 1 2 3)) 3)

;; group decided that empty list argument doesn't make sense
;; for this function

;; P02

(define (my-last-2 lst)
  (cond ((or (empty? lst)
             (empty? (rest lst))
             (empty? (rest (rest lst))))
         lst)
        (else (my-last-2 (rest lst)))))

(check-expect (my-last-2 empty) empty)
(check-expect (my-last-2 (cons 1 empty)) (cons 1 empty))
(check-expect (my-last-2 (list 1 2)) (list 1 2))
(check-expect (my-last-2 (list 1 2 3)) (list 2 3))

;; P03

(define (element-at x lst)
  (cond ((<= x 0) (error "Must be greater than 0"))
    ((empty? lst) (error "Index must be less than the lists length"))
    ((eq? x 1) (first lst))
    (else (element-at (- x 1) (rest lst)))))

(check-expect (element-at 3 (list 1 2 3 4)) 3)
(check-error (element-at -1 (list 1 2 3 4))
             "Must be greater than 0")
(check-error (element-at 4 (list 1 2))
             "Index must be less than the lists length")

;; P04
(define (my-length lst)
  (my-length* lst 0))

(define (my-length* lst n)
   (cond
     [(empty? lst) n]
     [else (my-length* (rest lst) (+ n 1))]))

(check-expect (my-length empty) 0)
(check-expect (my-length (list 1 2 3 4)) 4)

;; P05

(define (reverse-list lst)
  (if (empty? lst)
      empty
      (reverse-list* lst empty)))

(define (reverse-list* lst r-lst)
  (if (empty? (rest lst))
      (cons (first lst) r-lst)
      (reverse-list* (rest lst)
                     (cons (first lst) r-lst))))

(check-expect (reverse-list (list 1 2 3 4 5)) (list 5 4 3 2 1))


(define (reverse-list2 lst)
  (reverse-list2* lst empty))

(define (reverse-list2* lst r-lst)
  (if (empty? lst)
      r-lst
      (reverse-list2* (rest lst)
                     (cons (first lst) r-lst))))

;; P06

(define (is-palindrome lst)
  (is-list-same lst (reverse-list lst)))

(define (is-list-same lst1 lst2)
  (cond
    ((and (empty? lst1) (empty? lst2)) true)
    ((or (empty? lst1) (empty? lst2)) false)
    ((eq? (first lst1) (first lst2)) (is-list-same (rest lst1) (rest lst2)))
    (else false)))

(check-expect (is-list-same empty empty) true)
(check-expect (is-list-same empty (list 1)) false)
(check-expect (is-list-same (list 1) empty) false)
(check-expect (is-list-same (list 1) (list 1)) true)
(check-expect (is-list-same (list 1 2) (list 1 2)) true)
(check-expect (is-list-same (list 1 2) (list 1 3)) false)

(check-expect (is-palindrome empty) true)
(check-expect (is-palindrome (list 1)) true)
(check-expect (is-palindrome (list 1 1)) true)
(check-expect (is-palindrome (list 1 2)) false)
