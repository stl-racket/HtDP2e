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
(define BALL (square 10 "solid" "red"))
(define CANVAS (rectangle 400 300 "solid" "black"))
(define NET (scene+line CANVAS (/ 400 2) 0 (/ 400 2) 300 (make-pen "gray" 10 "dot" "butt" "bevel")))
(define SCENE (overlay NET CANVAS))

(define INITIAL_WORLD (make-world
                       (make-actor
                        (make-posn 2 150)
                        (make-velocity 0 0))
                       (make-actor
                        (make-posn 398 159)
                        (make-velocity 0 0))
                       (make-actor
                        (make-posn 200 200)
                        (make-velocity 5 0))))

(define (update-posn actor)
  (make-actor (make-posn
               (modulo (+ (posn-x (actor-posn actor)) (velocity-dx (actor-vel actor))) (image-width SCENE)) 
               (modulo (+ (posn-y (actor-posn actor)) (velocity-dy (actor-vel actor))) (image-height SCENE)))
              (actor-vel actor)))
  
  (define (update-world w)
    (make-world
     (update-posn (world-paddle1 w))
     (update-posn (world-paddle2 w))
     (update-posn (world-ball w))))

  (define (update-velocity actor velocity)
    (make-actor (actor-posn actor)
                velocity))
  
(define (handle-key w k)
  (cond
    [(key=? k "w")
     (make-world
        (update-velocity (world-paddle1 w) (make-velocity 0 -10)) 
        (world-paddle2 w)
        (world-ball w))]
    [(key=? k "s")
     (make-world
        (update-velocity (world-paddle1 w) (make-velocity 0 10)) 
        (world-paddle2 w)
        (world-ball w))]
    [(key=? k "up")
     (make-world
        (world-paddle1 w)
        (update-velocity (world-paddle2 w) (make-velocity 0 -10)) 
        (world-ball w))]
    [(key=? k "down")
     (make-world
        (world-paddle1 w)
        (update-velocity (world-paddle2 w) (make-velocity 0 10)) 
        (world-ball w))]
     [else
       w])
  )

(define (handle-release w k)
  (cond
    [(or (key=? k "w") (key=? k "s"))
     (make-world
        (update-velocity (world-paddle1 w) (make-velocity 0 0)) 
        (world-paddle2 w)
        (world-ball w))]
    [(or (key=? k "up")(key=? k "down"))
     (make-world
        (world-paddle1 w)
        (update-velocity (world-paddle2 w) (make-velocity 0 0)) 
        (world-ball w))]
     [else
       w])
  )

(define (render w)
  (place-image PADDLE
               (posn-x (actor-posn (world-paddle1 w)))
               (posn-y (actor-posn (world-paddle1 w)))
               (place-image PADDLE
                            (posn-x (actor-posn (world-paddle2 w)))
                            (posn-y (actor-posn (world-paddle2 w)))
                            (place-image BALL
                                         (posn-x (actor-posn (world-ball w)))
                                         (posn-y (actor-posn (world-ball w)))
                                         SCENE))))



(define (main w)
  (big-bang w
            [on-tick update-world]
            [on-key handle-key]
            [on-release handle-release]
            [to-draw render]))

(main INITIAL_WORLD)

; TODO
; Velocities
; Collisions
; 
