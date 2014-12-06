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


;; Exercise 40
;; -----------

;; WorldState Number Number String -> WorldState
;; places the car at mouse position (x,y) if the mouse event is "button-down"
(check-expect (hyper 21 10 20 "enter") 21)
(check-expect (hyper 42 10 20 "button-down") 10)
(check-expect (hyper 42 10 20 "move") 42)

;; (define (hyper x-position-of-car x-mouse y-mouse me)
;;   x-position-of-car)

(define (hyper x-position-of-car x-mouse y-mouse me)
  (cond
    [(string=? "button-down" me) x-mouse]
    [else x-position-of-car]))


;; WorldState -> WorldState
;; launches the program from some initial state
(define (main.mouse ws)
  (big-bang ws
            [on-tick tock]
            [on-mouse hyper]
            [to-draw render]
            [stop-when end?]))


;; AllMouseEvts is an element of Image
;; interpretation an image with markers for all mouse events

;; graphical constants
(define MT.clack (empty-scene 100 100))

;; PositiveNumber -> Image
;; records all mouse events for the specified time interval
(define (main.clack duration)
  (big-bang MT.clack
            [to-draw show.clack]
            [on-tick do-nothing.clack 1 duration]
            [on-mouse clack]))

;; AllMouseEvts Number Number String -> AllMouseEvts
;; adds a dot at (x,y) to ws
(check-expect
 (clack MT.clack 10 20 "something mousy")
 (place-image (circle 1 "solid" "red") 10 20 MT.clack))

(check-expect
 (clack (place-image (circle 1 "solid" "red") 1 2 MT.clack) 3 3 "")
 (place-image (circle 1 "solid" "red") 3 3
              (place-image (circle 1 "solid" "red") 1 2 MT.clack)))

(define (clack ws x y action)
  (place-image (circle 1 "solid" "red") x y ws))

;; AllMouseEvts -> AllMouseEvts
;; reveals the current world state (because it is am image)

(check-expect (show.clack MT.clack) MT.clack)

(define (show.clack ws)
  ws)

;; AllMouseEvts -> AllMouseEvts
(define (do-nothing.clack ws) ws)


;; physical constants:
(define WIDTH.keys 100)
(define HEIGHT.keys 30)

;; graphical constant:
(define MT.keys (empty-scene WIDTH.keys HEIGHT.keys))

;; AllKeys is a String.
;; interpretation the keys pressed since big-bang created the canvas

;; AllKeys -> AllKeys
(define (main.keys s)
  (big-bang s
            [on-key remember.keys]
            [to-draw show.keys]))

;; AllKeys String -> AllKeys
;; adds ke to ak, the state of the world
(check-expect (remember.keys "hello" " ") "hello ")
(check-expect (remember.keys "hello " "w") "hello w")

(define (remember.keys ak ke)
  (string-append ak ke))

;; AllKeys -> Image
;; renders the string as a text and place it into MT
(check-expect (show.keys "hel") (overlay (text "hel" 11 "red") MT.keys))
(check-expect (show.keys "mark") (overlay (text "mark" 11 "red") MT.keys))

(define (show.keys ak)
  (overlay (text ak 11 "red") MT.keys))


;; Exercise 41
;; -----------

(define MT.keys.align-left
  (rectangle WIDTH.keys HEIGHT.keys "outline" "black"))

;; AllKeys -> Image
;; renders the string as framed left-aligned text
(check-expect (show.keys.align-left "hel")
              (overlay/align "left" "middle"
                             (text "hel" 11 "red")
                             MT.keys.align-left))
(check-expect (show.keys.align-left "mark")
              (overlay/align "left" "middle"
                             (text "mark" 11 "red")
                             MT.keys.align-left))

(define (show.keys.align-left ak)
  (overlay/align "left" "middle"
                 (text ak 11 "red")
                 MT.keys.align-left))

;; AllKeys -> AllKeys
(define (main.keys.align-left s)
  (big-bang s
            [on-key remember.keys]
            [to-draw show.keys.align-left]))


;; Exercise 42
;; -----------

;; AllKeys String -> AllKeys
;; adds ke to ak, the state of the world, ignoring all key strokes represented
;; by one-character strings
(check-expect (remember.keys.ignore "hello " "w") "hello ")
(check-expect (remember.keys.ignore "hello " "\t") "hello ")
(check-expect (remember.keys.ignore "hello " "\r") "hello ")
(check-expect (remember.keys.ignore "hello " "up") "hello up")
(check-expect (remember.keys.ignore "hello " "down") "hello down")

(define (remember.keys.ignore ak ke)
  (cond
    [(= (string-length ke) 1) ak]
    [else (string-append ak ke)]))

;; AllKeys -> AllKeys
(define (main.keys.ignore s)
  (big-bang s
            [on-key remember.keys.ignore]
            [to-draw show.keys.align-left]))


;; Exercise 43
;; -----------
(define CAT (bitmap/file "cat.png"))
(define WIDTH.vpet (* 5 (image-width CAT)))
(define HEIGHT.vpet (ceiling (* 3/2 (image-height CAT))))
(define BACKGROUND.vpet (rectangle WIDTH.vpet HEIGHT.vpet "outline" "black"))
(define Y-CAT (neg (- (image-height BACKGROUND.vpet) (image-height CAT))))
(define RATE.vpet 3)
(define CYCLES.vpet 2)
(define DURATION.vpet
  (ceiling (* (/ (image-width BACKGROUND.vpet) RATE.vpet)
              CYCLES.vpet)))

;; WorldState is a Number
;; interpretation the number of clock ticks since the program was started

;; WorldState -> WorldState
;; adds 1 to x to track the number of clock ticks
(check-expect (tock.vpet 20) 21)
(check-expect (tock.vpet 78) 79)
(define (tock.vpet x)
  (+ 1 x))

;; WorldState -> Number
;; returns an x coordinate that is 3 times the number of clock ticks since the
;; the program started, modulo the width fo the BACKGROUND.vpet image
(check-expect (xpos.vpet 0) 0)
(check-expect (xpos.vpet 10) (* 10 3))
(check-expect (xpos.vpet (+ 10 (* 1 (image-width BACKGROUND.vpet)))) (* 10 3))
(check-expect (xpos.vpet (+ 10 (* 5 (image-width BACKGROUND.vpet)))) (* 10 3))
(define (xpos.vpet ws)
  (modulo (* RATE.vpet ws)
          (image-width BACKGROUND.vpet)))

;; Image -> Image
;; Crops the CAT image to the rectangle with the upper left at the point (x,0)
;; and with width equal to the width argument and height equal to the height of
;; the CAT image
(check-expect (crop-cat 0 (image-width CAT)) CAT)
(define (crop-cat x width)
  (crop x 0
        width
        (image-height CAT)
        CAT))

;; WorldState -> Image
;; advances the left edge of the CAT image 3 pixels per clock tick to the right
;; of the left edge of the BACKGROUND.vpet image, modulo the width of the
;; BACKGROUND.vpet image; if the right edge of the CAT image extends beyond the
;; width of the BACKGROUND.vpet image, then the CAT image is cropped such that
;; its right edge edge is flush with the right edge of the background and the
;; cropped portion appears with its left edge flush with the left edge of the
;; background
(check-expect (render.vpet 0)
              (overlay/xy
               CAT
               0
               Y-CAT
               BACKGROUND.vpet))
(check-expect (render.vpet 104)
              ;; 104 * 3 = 312
              ;; 312 + (image-width CAT) = 387
              ;; (image-width BACKGROUND.vpet) = 375
              ;; so the rightmost 12 pixels (in the x direction) of the CAT
              ;; image should be cropped
              (overlay/xy
               (crop-cat
                (- (image-width CAT) 12)
                (image-width CAT))
               0
               Y-CAT
               (overlay/xy
                (crop-cat
                 0
                 (- (image-width CAT) 12))
                -312
                Y-CAT
                BACKGROUND.vpet)))
(define (render.vpet ws)
  (cond
    [(> (+ (image-width CAT)
           (xpos.vpet ws))
        (image-width BACKGROUND.vpet))
     (overlay/xy
      (crop-cat
       (- (image-width BACKGROUND.vpet)
          (xpos.vpet ws))
       (image-width CAT))
      0
      Y-CAT
      (overlay/xy
       (crop-cat
        0
        (- (image-width BACKGROUND.vpet)
           (xpos.vpet ws)))
       (neg (xpos.vpet ws))
       Y-CAT
       BACKGROUND.vpet))]
    [else (overlay/xy
           CAT
           (neg (xpos.vpet ws))
           Y-CAT
           BACKGROUND.vpet)]))

;; WorldState -> WorldState
(define (main.vpet ws)
  (big-bang ws
            [to-draw render.vpet]
            [on-tick tock.vpet 1/28 DURATION.vpet]))


;; Exercise 44
;; -----------
(define CAT-EVEN CAT)
(define CAT-ODD (bitmap/file "cat2.png"))

;; the two images are the same height, so Y-CAT does not need to be refactored
(check-expect (image-height CAT-EVEN) (image-height CAT-ODD))

;; Number -> Image
;; returns one or the other cat image depending on whether x is odd
(check-expect (tog-cat 0) CAT-EVEN)
(check-expect (tog-cat 1) CAT-ODD)
(check-expect (tog-cat 2) CAT-EVEN)
(check-expect (tog-cat 9) CAT-ODD)
(check-expect (tog-cat 10) CAT-EVEN)
(define (tog-cat x)
  (cond [(odd? x) CAT-ODD]
        [else CAT-EVEN]))

;; Image -> Image
;; Crops the CAT-EVEN or CAT-ODD image to the rectangle with the upper left at
;; the point (x,0) and with width equal to the width argument and height equal
;; to the height of one or the other cat image
(check-expect (crop-cat.tog 0 (image-width CAT) 1) CAT-ODD)
(check-expect (crop-cat.tog 0 (image-width CAT) 2) CAT-EVEN)
(define (crop-cat.tog x width xpos)
  (crop x 0
        width
        (image-height (tog-cat xpos))
        (tog-cat xpos)))

;; WorldState -> Image
;; advances the left edge of the CAT-EVEN or CAT-ODD image 3 pixels per clock
;; tick to the right of the left edge of the BACKGROUND.vpet image, modulo the
;; width of the BACKGROUND.vpet image; if the right edge of one or the other CAT
;; image extends beyond the width of the BACKGROUND.vpet image, then the cat
;; image is cropped such that its right edge edge is flush with the right edge
;; of the background and the cropped portion appears with its left edge flush
;; with the left edge of the background
(check-expect (render.vpet.tog 0)
              (overlay/xy
               CAT-EVEN
               0
               Y-CAT
               BACKGROUND.vpet))
(check-expect (render.vpet.tog 105)
              ;; 105 * 3 = 315, an odd number
              ;; 315 + (image-width CAT) = 390
              ;; (image-width BACKGROUND.vpet) = 375
              ;; so the rightmost 15 pixels (in the x direction) of the CAT-ODD
              ;; image should be cropped
              (overlay/xy
               (crop-cat.tog
                (- (image-width CAT-ODD) 15)
                (image-width CAT-ODD)
                315)
               0
               Y-CAT
               (overlay/xy
                (crop-cat.tog
                 0
                 (- (image-width CAT-ODD) 15)
                 315)
                -315
                Y-CAT
                BACKGROUND.vpet)))
(define (render.vpet.tog ws)
  (cond
    [(> (+ (image-width (tog-cat ws))
           (xpos.vpet ws))
        (image-width BACKGROUND.vpet))
     (overlay/xy
      (crop-cat.tog
       (- (image-width BACKGROUND.vpet)
          (xpos.vpet ws))
       (image-width (tog-cat ws))
       (xpos.vpet ws))
      0
      Y-CAT
      (overlay/xy
       (crop-cat.tog
        0
        (- (image-width BACKGROUND.vpet)
           (xpos.vpet ws))
        (xpos.vpet ws))
       (neg (xpos.vpet ws))
       Y-CAT
       BACKGROUND.vpet))]
    [else (overlay/xy
           (tog-cat ws)
           (neg (xpos.vpet ws))
           Y-CAT
           BACKGROUND.vpet)]))

;; WorldState -> WorldState
(define (main.vpet.tog ws)
  (big-bang ws
            [to-draw render.vpet.tog]
            [on-tick tock.vpet 1/28 DURATION.vpet]))


;; Exercise 45
;; -----------

;; Happiness is a Number.
;; interpretation the current value of the happiness gauge.

;; the initial Happiness value when the main.happy program is started
(define INIT-HAPPY 100)
(define MAX-HAPPY 100)

;; Happiness -> Happiness
;; with each clock tick, happiness decreases by -0.1, or the difference between
;; the happiness value and 0, but never returns less than 0
(check-expect (tock.happy 0) 0)
(check-expect (tock.happy (- 1/3 3/10)) 0)
(check-expect (tock.happy 1/10) 0)
(check-expect (tock.happy 10) 99/10)
(define (tock.happy h)
  (cond
    [(< h 1/10) 0]
    [else (- h 1/10)]))

;; Happiness String -> Happiness
;; every time the down arrow key is pressed, happiness increases by 1/5; every
;; time the up arrow is pressed, happiness jumps by 1/3; other keys are ignored;
;; if the increased happiness is greater than MAX-HAPPY, MAX-HAPPY is returned
(check-expect (adjust.happy 1/5 "up") 2/5)
(check-expect (adjust.happy MAX-HAPPY "up") MAX-HAPPY)
(check-expect (adjust.happy 2/3 "down") 3/3)
(check-expect (adjust.happy MAX-HAPPY "down") MAX-HAPPY)
(check-expect (adjust.happy 10 "left") 10)
(define (adjust.happy h k)
  (cond
    [(key=? k "up") (if (> (+ h 1/5) MAX-HAPPY) MAX-HAPPY (+ h 1/5))]
  [(key=? k "down") (if (> (+ h 1/3) MAX-HAPPY) MAX-HAPPY (+ h 1/3))]
  [else h]))

;; background image for the gauge
(define BACKGROUND.happy
  (rectangle (+ 6 MAX-HAPPY) (* 1/5 MAX-HAPPY) "outline" "black"))

;; Happiness -> Image
;; desc...
(check-expect (image-width (gauge.happy 10)) 10)
(check-expect (image-width (gauge.happy 20)) 20)
(check-expect (image-height (gauge.happy 10))
              (- (image-height BACKGROUND.happy) 6))
(check-expect (image-height (gauge.happy 20))
              (- (image-height BACKGROUND.happy) 6))
(define (gauge.happy h)
  (rectangle h (- (image-height BACKGROUND.happy) 6) "solid" "red"))

;; Happiness -> Image
;; overlays a gauge image generated with h on the BACKGROUND.happy image, offset
;; by 4 pixels from the left and top of the background
(define (render.happy h)
  (overlay/xy
   (gauge.happy h)
   -4
   -4
   BACKGROUND.happy))

;; Happiness -> Happiness
(define (main.happy _)
  ;; BSL requires that function definitions have at least one parameter; in this
  ;; case, it will be ignored (whatever it is) when the function is called
  (big-bang INIT-HAPPY
            [on-tick tock.happy]
            [on-key adjust.happy]
            [to-draw render.happy]))
