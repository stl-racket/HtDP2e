;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname interactive) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(require 2htdp/universe)
(require 2htdp/image)
(require 2htdp/batch-io)

(define (number->square s)
  (square s "solid" "red"))

(define dotx 50)

(define (main y)
  (big-bang y
            [on-tick sub1]
            [stop-when zero?]
            [to-draw place-dot-at]
            [on-key stop]))
 
(define (place-dot-at y)
  (place-image (circle 3 "solid" "red") dotx y (empty-scene 100 100)))
 
(define (stop y ke)
  0)

(define (reset s ke)
  100)