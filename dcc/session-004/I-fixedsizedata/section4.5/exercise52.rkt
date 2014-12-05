;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exercise52) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; Exercsise 52

(define HEIGHT 300)

(define (show x)
  (cond
    [(string? x) (if (string=? "resting" x) ... (error "unrecognized string passed to show:" x))]
    [(<= -3 x -1) ...]
    [(<= 0 x HEIGHT) ...]
    [else (error "unrecognized value passed to show:" x)]))
