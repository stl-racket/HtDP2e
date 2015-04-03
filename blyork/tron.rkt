;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname tron) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;;;;; Globals ;;;;;

(define MIN-SPEED 1)
(define MAX-SPEED 3)

;;;;; Structures ;;;;;

(define-struct cell [is-marked? color])
(define-struct keymap [left right accelerate decelerate])
(define-struct velocity [dx dy])
(define-struct cycle [color location velocity keymap is-dead])
(define-struct game-state [cycles grid scene])

;;;;; Utilities ;;;;;

(define (force-within min max x)
  (cond [(> x max) max]
        [(< x min) min]
        [else x]))

;;;;; Cycle Counts ;;;;;

(define (one-cycle-left? cycles)
  (= (count-live-cycles cycles) 1))

(define (count-live-cycles* cycles count)
  (cond 
    [(empty? cycles) count]
    [else (count-live-cycles*
           (rest cycles)
           (+ count (if
                     (cycle-is-dead (first cycles))
                     0
                     1)))]))

(define (count-live-cycles cycle)
  (count-live-cycles* cycle 0))

;;;;; Velocity Updates ;;;;;

(define (turn-left velocity)
   (make-velocity ...))

(define (turn-right velocity)
   (make-velocity ...))

(define (accelerate cycle)
   (make-velocity ...))

(define (decelerate velocity)
  (make-velocity ...))

;;;;; Key Checking ;;;;;

(define (is-left-binding? keymap key)
  (= (keymap-left keymap) key))

(define (is-right-binding? keymap key)
  (= (keymap-right keymap) key))

(define (is-accelerate-binding? keymap key)
  (= (keymap-accelerate keymap) key))

(define (is-decelerate-binding? keymap key)
  (= (keymap-decelerate keymap) key))

;;;;; Conditional Velocity Updates ;;;;;

(define (turn-left-if-key keymap key velocity)
  (if (is-left-binding? keymap key)
      (turn-left velocity)
      velocity))

(define (turn-right-if-key keymap key velocity)
  (if (is-right-binding? keymap key)
      (turn-right velocity)
      velocity))

(define (accelerate-if-key keymap key velocity)
  (if (is-accelerate-binding? keymap key)
      (accelerate velocity)
      velocity))

(define (decelerate-if-key keymap key velocity)
  (if (is-decelerate-binding? keymap key)
      (decelerate velocity)
      velocity))

(define (update-velocity-if-key keymap key velocity)
  (decelerate-if-key keymap key
                     (accelerate-if-key keymap key
                                        (turn-right-if-key keymap key
                                                           (turn-left-if-key keymap key
                                                                             velocity)))))

;;;;; Conditional Cycle/Velocity Updates ;;;;;

(define (update-cycle-if-key key cycle)
  (if (cycle-is-dead cycle)
      cycle
      (make-cycle
       (cycle-color cycle)
       (cycle-location cycle)
       (update-velocity-if-key (cycle-keymap cycle) key (cycle-velocity cycle)
       (cycle-keymap cycle)
       (cycle-is-dead cycle)))))

(define (update-cycles-if-key* key unprocessed processed)
    (if (empty? unprocessed)
        processed
        (update-cycles-if-key* key
                               (rest unprocessed)
                               (cons (update-cycle-if-key key (first unprocessed)) processed))))
      
(define (update-cycles-if-key key cycles)
  (update-cycles-if-key* key cycles empty))

;;;;; Big Bang Handles ;;;;;
  
(define (handle-key gs ke)
  (make-game-state
   (update-cycles-if-key key (game-state-cycles gs))
   (game-state-grid gs)
   (game-state-scene gs)))
  
(define (handle-tick gs)
  gs)

(define (render gs)
  (empty-scene 100 100 "black"))

(define (game-over? gs)
  (one-cycle-left? (game-state-cycles gs)))

;;;;; BANG!!! ;;;;;

(define (play gs)
  (big-bang gs
            [on-key handle-key]
            [on-tick handle-tick]
            [to-draw render]
            [stop-when game-over?]))

(play INITIAL_GAME_STATE)
