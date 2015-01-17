;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname main) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; Session #4 – HtDP2e: Part 1, Sections 4 thru 4.7
;; http://www.ccs.neu.edu/home/matthias/HtDP2e/

;; 06 Dec 2014, LockerDome conference room
;; vnc server:  192.168.88.126, password:  racket

(define (foo x) (+ 1 x))

(foo 1)
{foo 2}
[foo 1]

(define (reward s)
  (cond
    [(<= 0 s 10) "bronze"]
    [(and (< 10 s) (<= s 20)) "silver"]
    [else "gold"]))

#|
function cond() {
  var conds = Array.prototype.slice.call(arguments);
  for (var i = 0; i < conds.length; ++i) {
    var branch = conds[i];
    if (branch[0]()) return branch[1]();
  }
}

function reward(s) {
  return cond(
    [function () { return 0 <= s }, function () { return "bronze" }],
    [function () { return 10 < s && s <= 20 }, function () { return "silver" }],
    [function () { return true; }, function () { return "gold" }]
  );
}

|#