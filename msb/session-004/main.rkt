;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname main) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; Session #4 – HtDP2e: Part 1, Sections 4 thru 4.7
;; http://www.ccs.neu.edu/home/matthias/HtDP2e/

(require 2htdp/image)
(require 2htdp/universe)

;; ------------------
;; Sections 4.0 - 4.1
;; ------------------

;; no code


;; -----------
;; Section 4.2
;; -----------

;; Exercise 46
;; -----------

(define (reward s)
  (cond
    [(<= 0 s 10) "bronze"]
    [(and (< 10 s) (<= s 20)) "silver"]
    [else "gold"]))

;; (reward 18)

;; the first condition evaluates to false, so the computation for (reward 18)
;; proceeds to the second condition, which evalutes to true, so it returns the
;; string "silver"


;; Exercise 47
;; -----------

(define (cond.y y)
  (- 200 (cond
         [(> y 200) 0]
         [else y])))

(cond.y 100)
(cond.y 210)

;; in the first case, the first conditional clause evaluates to false so the
;; cond expression evaulates to 100, and the whole expression evaluates to 100

;; in the second case, the first conditional clause evaluates to true so the
;; cond expression evaluates to 0, and the whole expression evaluates to 200

#|
(define (create-rocket-scene.v5 h)
  (place-image
   ROCKET
   50
   (cond
     [(<= h ROCKET-CENTER-TO-BOTTOM) h]
     [(> h ROCKET-CENTER-TO-BOTTOM) ROCKET-CENTER-TO-BOTTOM])
   MTSCN))
|#


;; Exercise 48
;; -----------

;; TrafficLight -> TrafficLight
;; Determines the next state of the traffic light from the given s

(check-expect (traffic-light-next "red") "green")
(check-expect (traffic-light-next "green") "yellow")
(check-expect (traffic-light-next "yellow") "red")

(define (traffic-light-next s)
  (cond
    [(string=? "red" s) "green"]
    [(string=? "green" s) "yellow"]
    [(string=? "yellow" s) "red"]))


;; Exercise 49
;; -----------

;; TrafficLight -> TrafficLight
;; returns the next TrafficLight value on every clock tick
(check-expect (tock.tlight "red") "green")
(define (tock.tlight lt)
  (traffic-light-next lt))

;; TrafficLight -> Image
;; returns a solid circle with radius 100 of the color indicated by the
;; TrafficLight value
(check-expect (render.tlight "green") (circle 100 "solid" "green"))
(define (render.tlight lt)
  (circle 100 "solid" lt))

(define (main.tlight lt)
  (big-bang lt
            [on-tick tock.tlight 1]
            [to-draw render.tlight]))


;; -----------
;; Section 4.4
;; -----------

;; Exercise 50
;; -----------

#| INCOMPLETE |#

;; constants:
(define WIDTH.ufo 100)
(define HEIGHT.ufo 300)
(define CLOSE.ufo (* HEIGHT.ufo 2/3))

;; visual constants:
(define MT.ufo (empty-scene WIDTH.ufo HEIGHT.ufo))
(define UFO
  (overlay (circle 10 "solid" "green")
           (rectangle 40 2 "solid" "green")))

;; A WorldState falls into one of three intervals:
;; – between 0 and CLOSE
;; – between CLOSE and HEIGHT
;; – below HEIGHT

;; WorldState -> WorldState
(define (main.ufo y0)
  (big-bang y0
            [on-tick nxt.ufo]
            [to-draw render.ufo]))

;; WorldState -> WorldState
;; computes next location of UFO

(check-expect (nxt.ufo 11) 14)

(define (nxt.ufo y)
  (+ y 3))

;; WorldState -> Image
;; place UFO at given height into the center of MT
(check-expect
  (render.ufo 11) (place-image UFO (/ WIDTH.ufo 2) 11 MT.ufo))
(define (render.ufo y)
  (place-image UFO (/ WIDTH.ufo 2) y MT.ufo))

;; WorldState -> Image
;; adds a status line to the scene created by render
(check-expect (render.ufo/status 10)
              (place-image (text "descending" 11 "green")
                           10 10
                           (render.ufo 10)))
(define (render.ufo/status y)
  (cond
    [(<= 0 y CLOSE.ufo)
     (place-image (text "descending" 11 "green")
                  10 10
                  (render.ufo y))]
    [(and (< CLOSE.ufo y) (<= y HEIGHT.ufo))
     (place-image (text "closing in" 11 "orange")
                  10 10
                  (render.ufo y))]
    [(> y HEIGHT.ufo)
     (place-image (text "landed" 11 "red")
                  10 10
                  (render.ufo y))]))

;; WorldState -> WorldState
(define (main.ufo/status y0)
  (big-bang y0
            [on-tick nxt.ufo]
            [to-draw render.ufo/status]))

;; WorldState -> Image
;; adds a status line to the scene create by render
(check-expect (render.ufo/status.v2 42)
              (place-image (text "descending" 11 "green")
                           40 20
                           (render.ufo 42)))
(define (render.ufo/status.v2 y)
  (place-image
    (cond
      [(<= 0 y CLOSE.ufo)
       (text "descending" 11 "green")]
      [(and (< CLOSE.ufo y) (<= y HEIGHT.ufo))
       (text "closing in" 11 "orange")]
      [(> y HEIGHT.ufo)
       (text "landed" 11 "red")])
    40 20
    (render.ufo y)))

;; WorldState -> WorldState
(define (main.ufo/status.v2 y0)
  (big-bang y0
            [on-tick nxt.ufo]
            [to-draw render.ufo/status.v2]))


;; -----------
;; Section 4.5
;; -----------

;; With intervals, enumerations and itemizations, together with the guidance on
;; how to used cond to structure functions which take thoe data types as
;; arguments, it starts to become more clore how this book is about the
;; "systematic design" of programs.

;; Exercise 51
;; -----------

#| INCOMPLETE |#


;; Exercise 52
;; -----------

#| INCOMPLETE |#

;; ???
;; What is a completely accurate condition for the third clause?


;; Exercise 53
;; -----------

#| INCOMPLETE |#

;; An auxiliary function is a good idea because it reduces the number of
;; "points of control", making the program easier to refactor.


;; I would supply "resting" as the argument to main1 as defined by the book


;; Exercise 54
;; -----------

#| INCOMPLETE |#


;; Exercise 55
;; -----------

#| INCOMPLETE |#


;; -----------
;; Section 4.6
;; -----------

;; KEY POINT re: Design
;; --------------------
;; If a data definition singles out certain pieces of data or specifies ranges
;; of data, then the creation of examples and the organization of the function
;; reflects these cases and ranges.

#| INCOMPLETE :: Write down the remaining test cases. |#

#| INCOMPLETE :: What do you do when one of your test cases fails? |#


;; QUESTION comes to mind
;; ----------------------
;; The cond-technique as explained so far doesn't suggest how to deal with
;; functions of more than one parameter; with 2 or more parameters for
;; itemizations of any significant complexity, the number of cond clauses would
;; quickly "explode". So what is a better way to deal with those situations,
;; from the perspective of design?


;; Exercise 56
;; -----------

#| INCOMPLETE |#


;; -----------
;; Section 4.7
;; -----------

;; finite state machines == f.s. automata

#| INCOMPLETE :: Spec the TrafficLight itemization, etc. |#


;; Exercise 57
;; -----------

#| INCOMPLETE |#


#| INCOMPLETE :: Consider why [the given] table suffices. |#


;; Exercise 58
;; -----------

; A DoorState is one of:
; – "locked"
; – "closed"
; – "open"

; DoorState -> DoorState
; simulates a door with an automatic door closer
(define (door-simulation initial-state)
  (big-bang initial-state
            (on-tick door-closer 3)
            (on-key door-actions)
            (to-draw door-render)))

; DoorState -> DoorState
; closes an open door over the period of one tick

(check-expect (door-closer "locked") "locked")
(check-expect (door-closer "closed") "closed")
(check-expect (door-closer "open") "closed")

(define (door-closer state-of-door)
  (cond
    [(string=? "locked" state-of-door) "locked"]
    [(string=? "closed" state-of-door) "closed"]
    [(string=? "open" state-of-door) "closed"]))


; DoorState KeyEvent -> DoorState
; simulates actions on the door via three key events

(check-expect (door-actions "locked" "u") "closed")
(check-expect (door-actions "closed" "l") "locked")
(check-expect (door-actions "closed" " ") "open")
(check-expect (door-actions "open" "a") "open")
(check-expect (door-actions "closed" "a") "closed")

(define (door-actions s k)
  (cond
    [(and (string=? "locked" s) (string=? "u" k)) "closed"]
    [(and (string=? "closed" s) (string=? "l" k)) "locked"]
    [(and (string=? "closed" s) (string=? " " k)) "open"]
    [else s]))

; DoorState -> Image
; renders the current state of the door as a large red text

(check-expect (door-render "closed")
              (text "closed" 40 "red"))

(define (door-render s)
  (text s 40 "red"))

;; In order for the door simulation's "open" state to remain visible longer, one
;; should provide a second argument to the on-tick handler; a 2nd-argument-value
;; of 3 will result in the "open" state being visible for 3 seconds, since the
;; clock will tick once ever 3 seconds.








;; Completed section 4.x through Exercise xx, as of xx Dec 2014. Don't
;; forget to start leaving open the Edit -> Keybindings -> Show Active
;; Keybindings panel.
