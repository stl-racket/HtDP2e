;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname main) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; Session #3 – HtDP2e: Part 1, Sections 3 thru 3.8
;; http://www.ccs.neu.edu/home/matthias/HtDP2e/

;; 15 Nov 2014, LockerDome conference room
;; vnc server:  192.168.88.126, password:  racket

(require 2htdp/universe)
(require 2htdp/image)

(define WIDTH-OF-WORLD 200)
 
;(define WHEEL-RADIUS 5)
;(define WHEEL-DISTANCE (* WHEEL-RADIUS 5))

;(define WHEEL (circle WHEEL-RADIUS "solid" "black"))
;(define SPACE (rectangle ... WHEEL-RADIUS ... "white"))
;(define BOTH-WHEELS (beside WHEEL SPACE WHEEL))

; (define RED-LIGHT (circle 6 "solid" "red"))
; (define BLUE-LIGHT (circle 6 "solid" "blue"))
(define BODY (rectangle 150 30 "solid" "silver"))
(define TOP (ellipse 130 50 "solid" "green"))
(define WHEEL (overlay
               (circle 6 "solid" "white")
               (circle 20 "solid" "black")))

(define (make-light color size)
  (circle size "solid" color))

(define (make-car color light-size)
  (overlay/xy (make-light color light-size) -80 13 
   (overlay/xy 
    (overlay/xy WHEEL -104 -15
                (overlay/xy WHEEL -4 -15 BODY))
    16 -25 TOP)))

;; My fantastic car.
(define RED-CAR (make-car "red" 10))
(define BLUE-CAR (make-car "blue" 20))

(define (extract-position state)
  (first state))

(define (extract-direction state)
  (first (rest state)))

(define (change-direction state key)
  (list (extract-position state) (+ 1 (extract-direction state))))

(define (main state)
  (big-bang state
      [to-draw draw-car]
      [on-tick move]
      [on-mouse teleport-car]
      [on-key change-direction]
  ))

(define (move state)
  (if (even? (extract-direction state))
      (list (+ (extract-position state) 3) (extract-direction state))
      (list (- (extract-position state) 3) (extract-direction state))))

(define (draw-car state)
  (place-image (if (even? (extract-position state)) RED-CAR BLUE-CAR) (extract-position state) 200 (empty-scene 400 400)))

(define (teleport-car state x y mousevent)
  (if (string=? mousevent "button-down")
      (list x (extract-direction state))
      state))
