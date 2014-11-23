;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname main) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; Session #3 – HtDP2e: Part 1, Sections 3 thru 3.8
;; http://www.ccs.neu.edu/home/matthias/HtDP2e/

(require 2htdp/batch-io)
(require 2htdp/image)
(require 2htdp/universe)

;; Exercise 29
;; -----------

;; There is an article in the Wikipedia that provides a short but informative
;; introduction to the "Year 2000 problem".


;; Good programmers write two purpose statements: one for the reader who may
;; have to modify the code and another one for the person who wishes to use the
;; program but not read it.


;; Exercise 30
;; -----------

;; String -> String
;; extracts the first character from a non-empty string
;; given: "abc", expect: "a"
;; given: "x", expect: "x"
(define (string-first s)
  (substring s 0 1))

(string=? (string-first "abc") "a")
(string=? (string-first "x") "x")


;; Exercise 31
;; -----------

;; String -> String
;; extracts the last character from a non-empty string
;; given: "abc", expect: "c"
;; given: "x", expect: "x"
(define (string-last s)
  (substring s (- (string-length s) 1)))

(string=? (string-last "abc") "c")
(string=? (string-last "x") "x")


;; Exercise 32
;; -----------

;; Image -> Number
;; counts the number of pixels in a given image
;; given: (square 10 "solid" "red"), expect: 100
;; given: (rectangle 10 5 "solid" "blue"), expect: 50
(define (image-area img)
  (* (image-width img) (image-height img)))

(= (image-area (square 10 "solid" "red")) 100)
(= (image-area (rectangle 10 5 "solid" "blue")) 50)


;; Exercise 33
;; -----------

;; String -> String
;; produces a string like the given one with the first character removed
;; given: "abc", expect: "bc"
;; given: "x", expect: ""
(define (string-rest s)
  (substring s 1))

(string=? (string-rest "abc") "bc")
(string=? (string-rest "x") "")


;; Exercise 34
;; -----------

;; String -> String
;; produces a string like the given one with the last character removed
;; given: "abc", expect: "ab"
;; given: "x", expect: ""
(define (string-remove-last s)
  (substring s 0 (- (string-length s) 1)))

(string=? (string-remove-last "abc") "ab")
(string=? (string-remove-last "x") "")


; Number -> Number
; converts Fahrenheit temperatures to Celsius temperatures
; given 32, expected 0
; given 212, expected 100
; given -40, expected -40
(define (f2c f)
  (* 5/9 (- f 32)))

(check-expect (f2c -40) -40)
(check-expect (f2c 32) 0)
(check-expect (f2c 212) 100)
;; (check-expect (f2c -40) "wrong")

;; passes
(check-expect (circle 100 "solid" "red")
              (circle 100 "solid" "red"))

 #|
;; fails
(check-expect (circle 100 "solid" "red")
              (circle 100 "solid" "blue"))
|#


;; Exercise 35
;; -----------
;; WorldState is a Number
;; interpretation height of UFO (from top)

(define WIDTH-OF-WORLD 200)
(define WHEEL-RADIUS 5)
(define WHEEL-DISTANCE (* WHEEL-RADIUS 5))
(define WHEEL (circle WHEEL-RADIUS "solid" "black"))
(define SPACE (rectangle (* 2 WHEEL-RADIUS) WHEEL-RADIUS "solid" "white"))
(define BOTH-WHEELS (beside WHEEL SPACE WHEEL))
(define CAR-BOTTOM (underlay/offset
                    (rectangle (* 8 WHEEL-RADIUS)
                               (* 2 WHEEL-RADIUS)
                               "solid"
                               "red")
                    0
                    WHEEL-RADIUS
                    BOTH-WHEELS))
(define CAR-TOP (rectangle (* 4 WHEEL-RADIUS)
                           WHEEL-RADIUS
                           "solid"
                           "red"))
(define CAR (above CAR-TOP CAR-BOTTOM))

;; Per the above definitions, the CAR image can be resized easily, with
;; appropriate scaling, with a change of only the value assigned to WHEEL-RADIUS


;; Exercise 36
;; -----------

;; WorldState -> WorldState
;; adds 3 to x to move the car right
(check-expect (tock 20) 23)
(check-expect (tock 78) 81)
(define (tock x)
  (+ 3 x))


;; Exercise 37
;; -----------

;; Number -> Number
;; changes the sign of the value
(check-expect (neg 1) -1)
(define (neg v) (- 0 v))

(define TREE
  (underlay/xy (circle 10 'solid 'green)
               9 15
               (rectangle 2 20 'solid 'brown)))

(define BACKGROUND-WITHOUT-TREE
  (rectangle WIDTH-OF-WORLD
             (* (image-height TREE) 4/3)
             "outline"
             "black"))

(define BACKGROUND
  (overlay/xy
   TREE
   (neg (* WIDTH-OF-WORLD 2/3))
   (neg (- (* (image-height TREE) 4/3) (image-height TREE)))
   BACKGROUND-WITHOUT-TREE))

(define Y-CAR
  (- (image-height BACKGROUND)
     (image-height CAR)))

;; WorldState -> Image
;; places the image of the car x pixels from the left margin of
;; the BACKGROUND image
(check-expect (render 10) (overlay/xy CAR -10 (neg Y-CAR) BACKGROUND))
(define (render x)
  ;; implemented with "overlay" instead of "place-image" because it works better
  ;; with the outline-mode background image
  (overlay/xy CAR
              (neg x)
              (neg Y-CAR)
              BACKGROUND))

;; WorldState -> Boolean
;; returns false if the value is greater than the width of the BACKGROUND image
(check-expect (end? 1) false)
(check-expect (end? (image-width BACKGROUND)) true)
(check-expect (end? (+ 3 (image-width BACKGROUND))) true)
(define (end? x)
  (if (>= x (image-width BACKGROUND))
      true
      false))

;; WorldState -> WorldState
;; launches the program from some initial state
(define (main ws)
  (big-bang ws
            [on-tick tock]
            [to-draw render]
            [stop-when end?]))


;; Completed section 3.6 up to Exercise 38, as of 20 Nov 2014. Don't
;; Exercise 38
;; -----------
;; WorldState -> Image
;; places the image of the car over the BACKGROUND images such that x denotes
;; the x coordinate of the right-most edge of the car
(check-expect (render.re 0) (overlay/xy CAR 0 (neg Y-CAR) BACKGROUND))
(check-expect (render.re (image-width CAR))
              (overlay/xy CAR 0 (neg Y-CAR) BACKGROUND))
(check-expect (render.re (+ 5 (image-width CAR)))
              (overlay/xy CAR -5 (neg Y-CAR) BACKGROUND))
(define (render.re x)
  ;; implemented with "overlay" instead of "place-image" because it works better
  ;; with the outline-mode background image
  (overlay/xy CAR
              ;; if the width of the car image is greater than x, then the car
              ;; stays "parked" at the left-most edge of the BACKGROUND; a more
              ;; advanced solution could cull the image of the car so that it
              ;; appears to gradually enter the BACKGROUND image from the left
              (if (< (- x (image-width CAR)) 0)
                  0
                  (neg (- x (image-width CAR))))
              (neg Y-CAR)
              BACKGROUND))


;; WorldState -> WorldState
;; launches the program from some initial state, where a state denotes the x
;; coordinate of the right-most edge of the car
(define (main.re ws)
  (big-bang ws
            [on-tick tock]
            [to-draw render.re]
            [stop-when end?]))

;; When the WorldState value is >= 200, the program ends and the right-most edge
;; of the car is flush with the right-edge of the BACKGROUND image.


;; AnimationState is a Number
;; interpretation the number of clock ticks since the animation started

;; forget to start leaving open the Edit -> Keybindings -> Show Active
;; Keybindings panel.
