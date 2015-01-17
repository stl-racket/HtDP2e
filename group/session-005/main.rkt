;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname main) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/image)
(require 2htdp/universe)

; Velocity
; - dx
; - dy
(define-struct velocity [dx dy])

; Actor (paddle, ball)
; - position
; - velocity
(define-struct actor [posn vel])

; World
; -paddle1 (Actor)
; -ball (Actor)
; -paddle2 (Actor)
(define-struct world [paddle1 paddle2 ball])

(define PADDLE (rectangle 10 40 "solid" "gray"))
(define BALL (square 10 "solid" "gray"))
(define CANVAS (rectangle 400 300 "solid" "black"))
(define NET (scene+line CANVAS (/ 400 2) 0 (/ 400 2) 300 (make-pen "gray" 10 "dot" "butt" "bevel")))
(define SCENE (overlay NET CANVAS))

(define INITIAL_WORLD (make-world
                       (make-actor
                        (make-posn 2 100)
                        (make-velocity 0 0))
                       (make-actor
                        (make-posn 398 100)
                        (make-velocity 0 0))
                       (make-actor
                        (make-posn 200 150)
                        (make-velocity 5 0))))

(define (update-world w)
  w
  )

(define (handle-key w k)
  w
  )

(define (render w)
  (place-image PADDLE (posn-x (actor-posn (world-paddle1 w))) (posn-y (actor-posn (world-paddle1 w))) SCENE))

(define (main w)
  (big-bang w
            [on-tick update-world]
            [on-key handle-key]
            [to-draw render]))

(main INITIAL_WORLD)
