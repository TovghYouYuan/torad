(defun ukword(bit kwd msg def / inp)
	(if (and def (/= def " "))
		(setq msg(strcat "\n" msg "<" def ">:")
			bit(- bit (boole 1 bit 1))
		)
		(if (= " "　(substr msg (strlen msg) 1))
			(setq msg(strcat "\n" (substr msg 1 (1- (strlen msg))) ":"))
			(setq msg(strcat "\n" msg ":"))
		);消除string末尾空格，典型的脱裤子放屁
	)
	(initget bit kwd)
	(setq inp(getkword msg))
	(if inp inp def)
)
(defun tnlist(tbname / xyy-tdata tblist)
	(while(setq xyy-tdata(tblnext tbname (not xyy-tdata)))
		(setq tblist(append tblist (list (cdr(assoc 2 xyy-tdata)))))
	)
)
(defun tdlist(tbname / xyy-tdata tblist)
	(while (setq xyy-tdata(tblnext tbname (not xyy-tdata)))
		(setq tblist(append tblist (list xyy-tdata)))
	)
)
(defun ptxy(basePt xdist ydist)
	(list (+ (car basePt) xdist) (+ (cadr basePt) ydist) (caddr basePt))
)
(defun mlayer(name color lstyle)
	;(command "LAYER" "m" name "c" color  name "l" lstyle name "")
	(if(tblsearch "layer" name) 
		(command "layer" "s" name "")
		(progn
			(command "LAYER" "m" name)
			(if color (command "c" color name))
			(if lstyle (command "lt" lstyle name))
			(command "")
		)
	)
	(princ)
)
(defun dxf(code edata)
	(cdr(assoc code edata))
)
(defun txtdis(txtelist)
	(caddr(textbox(txtelist)))
)
(defun dtor(angle)
	(/ (* angle pi) 180)
)
(defun rtod(angle)
	(/ (* angle 180) pi)
)
(defun AddLine(pt1 pt2)
	(entmakex(list (cons 0 "LINE") (cons 10 pt1) (cons 11 pt2)))
)
(defun AddPL2pt(pt1 pt2 pwidth)
	(entmakex(list(cons 0 "LWPOLYLINE")(cons 100 "AcDbEntity")(cons 100 "AcDbPolyline")
					(cons 90 2)(cons 40 pwidth)(cons 41 pwidth)(cons 43 pwidth) (cons 10 pt1)(cons 10 pt2)))
)
(defun AddRectang(pt1 pt2 pwidth)
	(entmakex(list(cons 0 "LWPOLYLINE")(cons 100 "AcDbEntity")(cons 100 "AcDbPolyline")
					(cons 90 4)(cons 210 (getvar "VIEWDIR"))(cons 40 pwidth)(cons 41 pwidth)(cons 43 pwidth) (cons 10 pt1)(cons 10 (list (car pt1) (cadr pt2)(caddr pt1)))
						 (cons 10 pt2)(cons 10 (list (car pt2)(cadr pt1)(caddr pt2)))))
)
(defun AddPLpts(ptlst pwidth)
	(entmakex (append (list (cons 0 "LWPOLYLINE") (cons 100 "AcDbEntity")
									 (cons 40 pwidth)(cons 41 pwidth)(cons 43 pwidth)
											(cons 100 "AcDbPolyline") (cons 90 (length ptlst)))
									 (mapcar '(lambda (pt) (cons 10 pt)) ptlst)))
)
(defun AddCircle(pt r)
	(entmakex(list (cons 0 "CIRCLE") (cons 10 pt) (cons 40 r)))
)
(defun AddArc(pt r ang1 ang2)
	(entmakex(list (cons 0 "ARC") (cons 10 pt) (cons 40 r)
					(cons 50 ang1) (cons 51 ang2)))
)
(defun AddText(pt str txtstyle  height pwidth)
	(entmakex(list (cons 0 "TEXT") (cons 1 str)(cons 10 pt)(cons 40 height)(cons 7 txtstyle)
					(cons 41 pwidth)(cons 11 pt) (cons 72 1)(cons 73 2)))
);创建文字72水平居中 73垂直居中
(defun AddMText(pt str)
	(entmakex(list (cons 0 "MTEXT") (cons 100 "AcDbEntity") (cons 100 "AcDbMText")
					(cons 10 pt) (cons 1 str)))
)
(defun AddRadial(cen pt)
	(entmakex(list(cons 0 "DIMENSION") (cons 100 "AcDbEntity") (cons 100 "AcDbDimension")
					 (cons 100 cen) (cons 70 36) (cons 100 "AcDbRadialDimension") (cons 15 pt)))
)
(defun AddDiametric(p1 p2 txtpt)
	(entmakex(list (cons 0 "DIMENSION") (cons 100 "AcDbEntity")(cons 100 "AcDbDimension")
					 (cons 10 p1)(cons 11 txtpt)(cons 70 163)(cons 100 "AcDbDiametricDimension")
					 (cons 15 p2)))
)
(defun AddDimensionH(p1 p2 txtpt)
	(entmakex(list (cons 0 "DIMENSION")(cons 100 "AcDbEntity")(cons 100 "AcDbDimension")
					 (cons 10 txtpt) (cons 70 32) (cons 1 "") (cons 100 "AcDbAlignedDimension")
					 (cons 13 p1)(cons 14 p2)(cons 100 "AcDbRotateDimension")))
)
(defun AddDimensionV(p1 p2 txtpt)
	(entmakex(list (cons 0 "DIMENSION")(cons 100 "AcDbEntity")(cons 100 "AcDbDimension")
					 (cons 10 txtpt) (cons 70 32) (cons 1 "") (cons 100 "AcDbAlignedDimension")
					 (cons 13 p1)(cons 14 p2)(cons 50 1.5708)(cons 100 "AcDbRotatedDimension")))
);1.5708=pi/2
(defun AddAlignedDim(p1 p2 txtpt)
	(entmakex (list(cons 0 "DIMENSION")(cons 100 "AcDbEntity")(cons 100 "AcDbDimension")
						(cons 10 txtpt)(cons 70 33)(cons 1 "")(cons 100 "AcDbAlignedDimension")
						(cons 13 p1)(cons 14 p2)))
)
(defun AddBlkRef(name pt)
	(entmakex(list (cons 0 "INSERT")(cons 2 name)(cons 10 pt)))
)