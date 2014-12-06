;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname section4.6) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; Exercise 56

(define STD-TAX-LIMIT 1000)
(define STD-TAX-RATE 0.05)
(define LUXURY-TAX-LIMIT 10000)
(define LUXURY-TAX-RATE 0.08)

; Price -> Number
; computes the amount of tax charged for price p
(define (sales-tax p)
  (cond
    [(and (<= 0 p) (< p STD-TAX-LIMIT)) 0]
    [(and (<= STD-TAX-LIMIT p) (< p LUXURY-TAX-LIMIT)) (* STD-TAX-RATE p)]
    [(>= p LUXURY-TAX-LIMIT) (* LUXURY-TAX-RATE p)]))

(check-expect (sales-tax 0) 0)
(check-expect (sales-tax 537) 0)
(check-expect (sales-tax STD-TAX-LIMIT) (* STD-TAX-RATE STD-TAX-LIMIT))
(check-expect (sales-tax 4037) (* STD-TAX-RATE 4037))
(check-expect (sales-tax LUXURY-TAX-LIMIT) (* LUXURY-TAX-RATE LUXURY-TAX-LIMIT))
(check-expect (sales-tax 12017) (* LUXURY-TAX-RATE 12017))
