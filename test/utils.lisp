(in-package :cl-state-machine-test)

(in-suite test-suite)


(test gethash-list-append-item
  (let ((ht (make-hash-table)))
    (cl-state-machine::gethash-list-append-item :a ht 'a)
    (cl-state-machine::gethash-list-append-item :a ht 'b)
    (cl-state-machine::gethash-list-append-item :b ht 'x)
    ;;
    (is (= 2 (hash-table-count ht)))
    (is (and (equal '(a b) (gethash :a ht))
             (equal '(x) (gethash :b ht))))))

(test append-f
  (let ((l '()))
    (cl-state-machine::append-f l)
    (is (equal l '())))
  (let ((l '(:a)))
    (cl-state-machine::append-f l '(:b))
    (is (equal l '(:a :b)))
    (cl-state-machine::append-f l '(:c) '(:d))
    (is (equal l '(:a :b :c :d)))))


(test plist-append-f-only-oks
  (let ((l '(:banana :yellow)))
    (cl-state-machine::plist-append-f l :apple :red)
    (cl-state-machine::plist-append-f l :pineapple nil)
    (cl-state-machine::plist-append-f l :anana :green)
    (is (equal l '(:banana :yellow :apple :red :anana :green)))))

(test plist-append-f-always
  (let ((l '(:banana :yellow)))
    (cl-state-machine::plist-append-f l :apple :red)
    (cl-state-machine::plist-append-f l :pineapple nil :when-val-ok? nil)
    (cl-state-machine::plist-append-f l :anana :green)
    (is (equal l '(:banana :yellow :apple :red :pineapple nil :anana :green)))))

(test plist-append-f-nil-1st
  (let ((l '()))
    (cl-state-machine::plist-append-f l :apple :red)
    (is (equal l '(:apple :red)))))


(test loop-over-plist
  (let ((l '(:a 1 :b 2 :c))
        (collected '(:a 42)))
    (cl-state-machine::loop-over-plist l (k v)
                                       (when (and k v)
                                         (setf (getf collected k) v)))
    (is (equal (alexandria:plist-hash-table '(:a 1 :b 2))
               (alexandria:plist-hash-table collected)))
    (is (equal '(:a 1 :b 2 :c) l))))


(test plist-merge
  (let ((plist-a '(:apple :red :banana :yellow))
        (plist-nil nil)
        (plist-b '(:pokemon :yellow))
        (plist-c '(:투명드래곤 nil
                   ;; TODO :apple :green
                   )))
    (is (equal '(:apple :red :banana :yellow
                 :pokemon :yellow)
               (cl-state-machine::plist-merge t plist-a plist-nil plist-b plist-c)))
    (is (equal '(:apple :red :banana :yellow) plist-a))
    (is (equal '(:apple :red :banana :yellow
                 :pokemon :yellow
                 :투명드래곤 nil)
               (cl-state-machine::plist-merge nil plist-a plist-nil plist-b plist-c)))
    (is (equal '(:pokemon :yellow)
               ;; NOTE: forget to specify `when-val?' positional arg.
               (cl-state-machine::plist-merge plist-a plist-nil plist-b plist-c)))))
