;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exercise46) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; 4.2 How it Works

;; Exercise 46 - step the following to see the reductions when cond is processed
;; (to step I deleted the above I wasn't sure if there was an easier way)

; PositiveNumber is a Number greater or equal to 0. 
 
; PositiveNumber -> String
; computes the reward level from the given score s

(define (reward s)
  (cond
    [(<= 0 s 10) "bronze"]
    [(and (< 10 s) (<= s 20)) "silver"]
    [else "gold"]))

(reward 18)

;; you can win if you get less than zero!!
;; (maybe later they're going to show how to actually 
;; define e.g. "PositiveNumber" to prevent this?)
(reward -1)

