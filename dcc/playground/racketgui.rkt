#lang racket/gui

; Make a frame by instantiating the frame% class
(define frame (new frame% [label "Example"] [width 400] [height 600]))
 
(define menu-bar (new menu-bar%
                      (parent frame)))
(new menu%
     (label "&File")
     (parent menu-bar))
(new menu%
     (label "&Edit")
     (parent menu-bar))
(new menu%
     (label "&Darren")
     (parent menu-bar))
(new menu%
     (label "&Help")
     (parent menu-bar))

    (define tab-panel (new tab-panel%
                           (parent frame)
                           (choices (list "Tab 0"
                                          "Tab 1"
                                          "Tab 2"))))

; Make a static text message in the frame
(define msg (new message% [parent tab-panel]
                          [label "No events so far..."]))
 
(define panel (new horizontal-panel% [parent tab-panel]))
(new button% [parent panel]
             [label "Left"]
             [callback (lambda (button event)
                         (send msg set-label "Left click"))])
(new button% [parent panel]
             [label "Right"]
             [callback (lambda (button event)
                         (send msg set-label "Right click"))])

(define group-box-panel (new group-box-panel%
                             (parent frame)
                             (label "Group Box Panel")))
(define panel-v (new vertical-panel% [parent group-box-panel]))
(define check-box1 (new check-box%
                       (parent panel-v)
                       (label "Check Box 1")
                       (value #t)))
(define check-box2 (new check-box%
                       (parent panel-v)
                       (label "Check Box 2")
                       (value #t)))
(define choice (new choice%
                    (label "Choice")
                    (parent panel-v)
                    (choices (list "Item 0" "Item 1"))))

(define radio-box (new radio-box%
                       (label "Radio Box")
                       (parent panel-v)
                       (choices (list "Button 0"
                                      "Button 1"
                                      "Button 2"))))

(define list-box (new list-box%
                          (label "List Box")
                          (parent (new horizontal-panel%
                                       (parent panel-v)
                                       (style (list 'border))))
                          (choices (list "Item 0"
                                         "Item 1"
                                         "Item 2"))
                          (style (list 'single
                                       'column-headers))
                          (columns (list "First Column"))))

; Show the frame by calling its show method
(send frame show #t)