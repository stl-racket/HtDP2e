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
;; WorldState is a Number
;; interpretation the number of pixels between the left border of the BACKGROUND
;; image and the CAR image

;; WorldState -> WorldState
;; adds 3 to x to move the CAR image to the right
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
;; places the CAR image x pixels from the left margin of the BACKGROUND image
(check-expect (render 10) (overlay/xy CAR -10 (neg Y-CAR) BACKGROUND))
(define (render x)
  ;; implemented with "overlay" instead of "place-image" because it works better
  ;; with the outline-mode background image
  (overlay/xy CAR
              (neg x)
              (neg Y-CAR)
              BACKGROUND))

;; WorldState -> Boolean
;; returns true if the value is greater than or equal to the width of the
;; BACKGROUND image, otherwise return false
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


;; Exercise 38
;; -----------
;; WorldState -> Image
;; places the CAR image over the BACKGROUND images such that x denotes the x
;; coordinate of the right-most edge of the CAR image
(check-expect (render.re 0) (overlay/xy CAR 0 (neg Y-CAR) BACKGROUND))
(check-expect (render.re (image-width CAR))
              (overlay/xy CAR 0 (neg Y-CAR) BACKGROUND))
(check-expect (render.re (+ 5 (image-width CAR)))
              (overlay/xy CAR -5 (neg Y-CAR) BACKGROUND))
(define (render.re x)
  (overlay/xy CAR
              ;; if the width of the CAR image is greater than x, then it stays
              ;; "parked" at the left-most edge of the BACKGROUND; a more
              ;; advanced solution could cull the CAR image so that it appears
              ;; to gradually enter the BACKGROUND image from the left
              (if (< (- x (image-width CAR)) 0)
                  0
                  (neg (- x (image-width CAR))))
              (neg Y-CAR)
              BACKGROUND))


;; WorldState -> WorldState
;; launches the program from some initial state, where a state denotes the x
;; coordinate of the right-most edge of the CAR image
(define (main.re ws)
  (big-bang ws
            [on-tick tock]
            [to-draw render.re]
            [stop-when end?]))

;; When the WorldState value is >= 200, the program ends and the right-most edge
;; of the CAR image is flush with the right-edge of the BACKGROUND image.


;; Exercise 39
;; -----------
;; AnimationState is a Number
;; interpretation the number of clock ticks since the animation started

;; AnimationState -> AnimationState
;; increments the value every clock tick
(check-expect (tock.anim 0) 1)
(check-expect (tock.anim 10) 11)
(define (tock.anim as)
  (+ as 1))

(define RATE-PIX.anim 3)
(define RATE-TIX.anim 1)

;; AnimationState -> Image
;; moves the left-edge of the CAR image RATE-PIX.anim pixels from the left
;; margin of the BACKGROUND image for every RATE-TIX.anim ticks of the clock

;; tests below assume that constants RATE-PIX.anim,RATE-TIX.anim have values of
;; 1,3 respectively
(check-expect (render.anim 0) (overlay/xy CAR 0 (neg Y-CAR) BACKGROUND))
(check-expect (render.anim 1) (overlay/xy CAR -3 (neg Y-CAR) BACKGROUND))
(check-expect (render.anim 2) (overlay/xy CAR -6 (neg Y-CAR) BACKGROUND))
(check-expect (render.anim 3) (overlay/xy CAR -9 (neg Y-CAR) BACKGROUND))

(define (render.anim as)
  (overlay/xy CAR
              (neg (quotient (* RATE-PIX.anim as) RATE-TIX.anim))
              (neg Y-CAR)
              BACKGROUND))

;; AnimationState -> Boolean
;; returns true if the clock ticks result in a pixel position of the right-hand
;; side of the CAR image that is greater than or equal to the width of the
;; BACKGROUND image, otherwise return false

;; tests below assume that constants RATE-PIX.anim,RATE-TIX.anim have values of
;; 1,3 respectively
(check-expect (end.anim? 1) false)
(check-expect (end.anim? 53) false)
(check-expect (end.anim? 54) true)

(define (end.anim? as)
  (if (>= (+ (quotient (* RATE-PIX.anim as) RATE-TIX.anim) (image-width CAR))
          (image-width BACKGROUND))
      true
      false))

;; AnimationState -> AnimationState
;; launches the program from some initial state, where a state denotes the
;; number of clock ticks since the animation started
(define (main.anim as)
  (big-bang as
            [on-tick tock.anim]
            [to-draw render.anim]
            [stop-when end.anim?]))

;; main.anim works similarly to the animate function from the HtDP2e Prologue,
;; except the clock of the latter "ticks" 28 times per second and accumulates
;; the number of ticks automatically, while the former calls on-tick once per
;; second and the state of the program tracks / accumulates the ticks of the
;; clock only by convention of the programmer.


;; design a program that moves the car according to a sine wave
;; ------------------------------------------------------------

;; Number Number Number -> Number
;; for a value of "n * freq" radians returns an integer value that is at most
;; "width" greater or lesser than "n", offset by "start"
(check-expect (sine-wave (* pi 0/2) 50 1 100) 100)
(check-expect (sine-wave (* pi 1/2) 50 1 100) 150)
(check-expect (sine-wave (* pi 2/2) 50 1 100) 100)
(check-expect (sine-wave (* pi 3/2) 50 1 100) 50)
(check-expect (sine-wave (* pi 4/2) 50 1 100) 100)
(check-expect (sine-wave (* pi 0/2 4) 50 1/4 100) 100)
(check-expect (sine-wave (* pi 1/2 4) 50 1/4 100) 150)
(check-expect (sine-wave (* pi 2/2 4) 50 1/4 100) 100)
(check-expect (sine-wave (* pi 3/2 4) 50 1/4 100) 50)
(check-expect (sine-wave (* pi 4/2 4) 50 1/4 100) 100)
(define (sine-wave n width freq start)
  (if (< (inexact->exact (sin (* n freq))) 0)
      (ceiling (+ (* (inexact->exact (sin (* n freq))) width)
                  start))
      (floor (+ (* (inexact->exact (sin (* n freq))) width)
                start))))

(define FIX-START.sine 80)
(define MAX-MOVE.sine 70)
(define RATE-ADJUST.sine 1/4)

;; AnimationState -> Image
;; moves the left-edge of the CAR image a calculated number pixels from the left
;; margin of the BACKGROUND with respect to the value of sine-wave called on the
;; number of accumulated clock ticks and the contants MAX-MOVE.sine,
;; RATE-ADJUST.sine, FIX-START.sine

;; tests below assume that constants FIX-START.sine,MAX-MOVE.sine,
;; RATE-ADJUST.sine have values of 80,70,1/4 respectively
(check-expect (render.sine (* pi 0/2 4))
              (overlay/xy CAR -80 (neg Y-CAR) BACKGROUND))
(check-expect (render.sine (* pi 1/2 4))
              (overlay/xy CAR -150 (neg Y-CAR) BACKGROUND))
(check-expect (render.sine (* pi 2/2 4))
              (overlay/xy CAR -80 (neg Y-CAR) BACKGROUND))
(check-expect (render.sine (* pi 3/2 4))
              (overlay/xy CAR -10 (neg Y-CAR) BACKGROUND))
(check-expect (render.sine (* pi 4/2 4))
              (overlay/xy CAR -80 (neg Y-CAR) BACKGROUND))

(define (render.sine as)
  (overlay/xy CAR
              (neg (sine-wave as MAX-MOVE.sine RATE-ADJUST.sine FIX-START.sine))
              (neg Y-CAR)
              BACKGROUND))

(define MAX-CYCLES.sine 5)

;; AnimationState -> Boolean
;; returns true if the number of accumulated clock ticks is enough to have
;; resulted in MAX-CYCLES.sine number of cylces between the min and max return
;; values for sine-wave called with a freq argument of RATE-ADJUST.sine,
;; otherwise return false

;; tests below assume that constants RATE-ADJUST.sine,MAX-CYCLES.sine have
;; values of 1/4,5 respectively
(check-expect (end.sine? 0) false)
(check-expect (end.sine? 1) false)
(check-expect (end.sine? (* 2 pi 4 5)) true)

(define (end.sine? as)
  (if (>= (* (/ as (* 2 pi)) RATE-ADJUST.sine) MAX-CYCLES.sine)
      true
      false))

;; AnimationState -> AnimationState
;; launches the program from some initial state, where a state denotes the
;; number of clock ticks since the animation started
(define (main.sine as)
  (big-bang as
            [on-tick tock.anim]
            [to-draw render.sine]
            [stop-when end.sine?]))


;; Completed section 3.6 through Exercise 39, as of 24 Nov 2014. Don't
;; forget to start leaving open the Edit -> Keybindings -> Show Active
;; Keybindings panel.
