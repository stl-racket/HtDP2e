;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname intervals) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; 4.1: An example condition
(define (next traffic-light-state)
  (cond
    [(string=? "red" traffic-light-state) "green"]
    [(string=? "green" traffic-light-state) "yellow"]
    [(string=? "yellow" traffic-light-state) "red"]))

(define (next-light current-light)
  (string-append "a " current-light " light changes to " (next current-light)))

(next-light "green")
(next-light "yellow")
;; just to see what happens when no conditions match:
;;   commented because the program aborts due to know exception handler
;;   racket has a "with-handler" for exceptions but looks like BSL doesn't...
;;(next-light "blue")


;; 4.1: An example condition with else
(define (next-with-else traffic-light-state)
  (cond
    [(string=? "red" traffic-light-state) "green"]
    [(string=? "green" traffic-light-state) "yellow"]
    [(string=? "yellow" traffic-light-state) "red"]
    [else (string-append "ERROR!! unknown traffic light color " traffic-light-state)]))

(define (next-light-with-else current-light)
  (string-append "a " current-light " light changes to " (next-with-else current-light)))

(next-light-with-else "green")
(next-light-with-else "yellow")
(next-light-with-else "blue")

;; It's an error if else is in the middle
;; looks like # in front of a list works to "comment" it by making it a vector
;; (I wonder if there's another way I just guessed and got lucky using #)
#(cond
    [(> x 0) 10]
    [else 20]
    [(< x 10) 30])

