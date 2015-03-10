;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname main) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))


; TRON game
; ---------
; background canvas on which two or more (?) "light cycles" (sprites) move and
; leave "trails"; if a cycle runs into a wall or any trail (including its own), it
; is out of the game; the game is over when there is only cycle left; the
; remaining cycle is declared as the winner

; each cycle responds to a unique set of keystrokes for changing direction of movement and speed
; canvas needs to be a grid
; cycles have a max, min, and initial speed
; cycles have an initial location and direction of movement
; each cycle has a unique color, and its trail is the same color

; Data structures
; ---------------

; (define LOGICAL-WIDTH 100)
; (define LOGICAL-HEIGHT 100)

(define-struct game-state [cycles grid])

; game-state-cycles is a List-of-cycles
; game-state-grid is a List-of-cell-rows

; A List-of-cycles is one of:
; - (cons Cycle (cons Cycle empty))
; - (cons Cycle List-of-cycles)

; A Cycle is (make-cycle [color posn velocity keymap is-dead])
; where color is a String
; posn is (make-posn [x y]) from BSL
; velocity is (make-velocity [dx dy])
; is-dead is Boolean

; A Velocity is (make-velocity [dx dy])
; where dx,dy is a Number

; A Keymap is (make-keymap [left right speed-up slow-down])
; where left,right,sleep-up,slow-down is a Key

; A List-of-cell-rows is one of:
; - empty
; - (cons CellRow empty)

; A CellRow is a List-of-cells

; A List-of-cells is one of:
; - empty
; - (cons Cell empty)

; A cell is (make-cell [is-marked color])
; where is-marked is Boolean
; where color is a String
