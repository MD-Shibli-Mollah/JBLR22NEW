SUBROUTINE TF.JBL.A.SCT.CUS.SEQ.NO.GEN
* Modification History :
* Written By: Zubaed Hassan Shimanto
* Date: 03 December, 2020
*---------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.BD.L.SCT.CUS.SEQ.NO
    
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.TransactionControl
    
    IF EB.SystemTables.getVFunction() NE 'A'  THEN
        RETURN
    END

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
    
    
INIT:
    FN.BD.L.SCT.CUS.SEQ.NO = 'F.BD.L.SCT.CUS.SEQ.NO'
    F.BD.L.SCT.CUS.SEQ.NO = ''
    
RETURN
   
OPENFILES:
    EB.DataAccess.Opf(FN.BD.L.SCT.CUS.SEQ.NO,F.BD.L.SCT.CUS.SEQ.NO)

RETURN

PROCESS:
    Y.SCT.ID = EB.SystemTables.getIdNew()
    Y.SCT.CUS.SEQ.NO.ID = FIELD(Y.SCT.ID, '.', 1)
    Y.CHECK = FIELD(Y.SCT.ID, '.', 3)
    EB.DataAccess.FRead(FN.BD.L.SCT.CUS.SEQ.NO, Y.SCT.CUS.SEQ.NO.ID, REC.SCT.SEQ, F.BD.L.SCT.CUS.SEQ.NO, ERR.SCT.SEQ)
    Y.SEQNO = REC.SCT.SEQ<SCT.CUS.SEQ.NO> + 1
    REC.SCT.SEQ<SCT.CUS.SEQ.NO>  = Y.SEQNO
    
    IF Y.CHECK EQ Y.SEQNO THEN
        EB.DataAccess.FWrite(FN.BD.L.SCT.CUS.SEQ.NO, Y.SCT.CUS.SEQ.NO.ID, REC.SCT.SEQ)
        EB.TransactionControl.JournalUpdate('')
        RETURN
    END
RETURN
        
    
END


