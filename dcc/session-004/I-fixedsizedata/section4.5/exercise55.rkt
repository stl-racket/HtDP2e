;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname section4.5height) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))

;; Exercise 55

(require 2htdp/universe)
(require 2htdp/image)

; physical constants 
(define SCENE-HEIGHT 300)
(define SCENE-WIDTH  100)
(define YDELTA 3)
 
;; convert height from ground to y coordinate
(define (height->y h) (- SCENE-HEIGHT h))

(define GROUND 0)

; graphical constants 
(define BACKG  (empty-scene SCENE-WIDTH SCENE-HEIGHT))
(define ROCKET (rectangle 5 30 "solid" "red"))

(define ROCKET-CENTER (/ (image-height ROCKET) 2))

(define (draw-rocket h)
  (place-image ROCKET 10 (- (height->y h) ROCKET-CENTER) BACKG))

(define (show h)
  (cond
    [(string? h) (draw-rocket GROUND)]
    [(<= -3 h -1)
     (place-image (text (number->string h) 20 "red")
                  10 (* 3/4 SCENE-WIDTH)
                   (draw-rocket GROUND))]
    [(>= h 0)  (draw-rocket h)]))

(define (launch h ke)
  (cond
    [(string? h) (if (string=? " " ke) -3 h)]
    [(<= -3 h -1) h]
    [(>= h 0) h]))

(check-expect (launch "resting" " ") -3)
(check-expect (launch "resting" "a") "resting")
(check-expect (launch -3 " ") -3)
(check-expect (launch -1 " ") -1)
(check-expect (launch 33 " ") 33)
(check-expect (launch 33 "a") 33)

; LRCD -> LRCD
; raises the rocket by YDELTA if it is moving already 
 
(check-expect (fly "resting") "resting")
(check-expect (fly -3) -2)
(check-expect (fly -2) -1)
(check-expect (fly -1) GROUND)
(check-expect (fly 10) (+ 10 YDELTA))
(check-expect (fly 22) (+ 22 YDELTA))
 
(define (fly h)
  (cond
    [(string? h) h]
    [(<= -3 h -1) (if (= h -1) GROUND (+ h 1))]
    [(>= h GROUND) (+ h YDELTA)]))

;; Exercise 54

(define (off-top h) (and (not (string? h)) (> h SCENE-HEIGHT)))

(define (main2 s)
  (big-bang s
            (on-tick fly 0.05)
            (stop-when off-top) 
            (to-draw show)
            (on-key launch)))

(main2 "resting")




