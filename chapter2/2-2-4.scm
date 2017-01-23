(define painter 1)
(define wave 2)
(define rogers 3)

(define (beside p1 p2)
  ())

(define (below p1 p2)())

(define (flip-vert p)
  ())

(define (flip-honz p)
  ())

(define wave2 (beside wave (flip-vert wave)))

(define wave4 (below wave2 wave2))

(define (flipped-pairs painter)
  (let ((painter2 (beside wave (flipped-vert wave))))
    (below painter2 painter2)
  )
)

(define wave4
  (let ((painter2 (beside wave (flipped-vert wave))))
    (below painter2 painter2)
  )
)

(define (right-split painter n)
  (if (= n 0)
    painter
    (let ((smaller (right-split painter (- n 1))))
      (beside painter (below smaller smaller))
    )
  )
)

(define (up-split painter n)
  (if (= n 0)
    painter
    (let ((smaller (up-split painter (- n 1))))
      (below (beside smaller smaller) painter)
    )
  )
)

(define (corner-split painter n)
  (if (= n 0)
    painter
    (let ((up (up-split painter (- n 1)))
          (right (right-split painter (- n 1))))
      (let ((top-left (beside up up))
            (corner (corner-split painter (- n 1)))
            (bottom-right (below right right)))
        (beside (below painter top-left) (below bottom-right corner))
      )
    )
  )
)

(define (square-limit painter n)
  (if (= n 0)
    painter
    (let (quarter (corner-split painter n))
      (let ((half (beside (filp-honz quarter) quarter)))
        (below (filp-vert half) half)
      )
    )
  )
)

(define (square-of-four tl tr bl br)
  (lambda (painter)
    (let ((top (beside (tl painter) (tr painter)))
          (bottom (beside (bl painter) (br painter))))
      (below bottom top)
    )
  )
)

(define (flipped-pairs-2 painter)
  (square-of-four identity flip-vert identity flip-vert) painter)

(define (square-limit painter n)
  ((square-of-four flip-honz identity rotate180 flip-vert) (corner-split painter n))
)

(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
      (origin-frame frame)
      (add-vect
        (scale-vect (xcor-vect v) (edge1-frame frame))
        (scale-vect (ycor-vect v) (edge2-frame frame))
      )
    )
  )
)

(define (s-q segment-list)
  (lambda (frame)
    (for-each (lambda (segment) ())
      (draw-line ())
    )
  )
)
