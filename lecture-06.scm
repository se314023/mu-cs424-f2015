;;; Meta-Circular Interpreter in Scheme

;;; eval is built-in interpreter, avoid namespace collision
;; > (eval (list '+ 1 2))
;; 3

(define my-eval
  (λ (e)
    (cond ((or (number? e) (boolean? e)) e)
	  ((symbol? e) (lookup e global-env))
	  ((pair? e)
	   (let ((f (car e)))
	     (cond ((equal? f 'λ)
		    (let ((vars (cadr e))
			  (body (caddr e)))
		      (list 'closure
			    vars
			    body)))
		   ((equal? f 'let) xxx)
		   (else
		    ;; regular function call
		    (my-apply (my-eval f)
			      (map my-eval (cdr e)))))))
	  (else (error "bad expression" e)))))

(define my-apply
  (λ (p args)
    (cond ((procedure? p) (apply p args))
	  ((and (pair? p) (equal? (car p) 'closure))
	   (my-eval (caddr p)))
	  (else (error "xxx")))))

(define lookup (λ (k alist) (cadr (assoc k alist))))

(define global-env (list (list '+ (λ (x y) (+ x y)))
			 (list '* (λ (x y) (* x y)))
			 (list 'sin sin)))