;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname interactiveMouse) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/universe)
(require 2htdp/image)

(define (number->square s)
  (square s "solid" "red"))

(define dotx 50)

(define initial-pos (make-posn 50 100))

(define (main pos)
  (big-bang pos
            [on-tick move-up]
            [stop-when at-top?]
            [to-draw place-dot-at]
            [on-key stop]
            [on-mouse mmove]))
 
(define (move-up pos) (make-posn (posn-x pos) (sub1 (posn-y pos))))

(define (at-top? pos) (zero? (posn-y pos)))

(define (place-dot-at pos)
  (place-image (circle 12 "solid" "red") (posn-x pos) (posn-y pos) (empty-scene 400 400)))
 
(define (stop pos ke)
  (make-posn (posn-x pos) 0))

(define (mmove pos x y mouseevent)
  (if (or (string=? mouseevent "drag") (string=? mouseevent "button-down")) (make-posn x y) pos))

(main initial-pos)