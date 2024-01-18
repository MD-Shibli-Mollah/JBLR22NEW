SUBROUTINE TF.JBL.I.JOB.TRANSFER.VAL
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
* VERSION : LETTER.OF.CREDIT,JBL.BTB.AMD.JOB
* create by: Mahmudur Rahman Udoy
* Description : CHECK THE BTB LC IS TRANSFER AVALE OR NOT.
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------
    $USING LC.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING ST.CompanyCreation
    $USING EB.Foundation
    
     
    
    GOSUB INIT
    GOSUB PROCESS
    

RETURN

*****
INIT:
*****
    APP.NAME = 'LETTER.OF.CREDIT'
    LOCAL.FIELDS = 'LT.TF.JOB.NUMBR'
    EB.Foundation.MapLocalFields(APP.NAME, LOCAL.FIELDS, FLD.POS)
    Y.TF.JOB.NUMBER.POS = FLD.POS<1,1>

RETURN
 
********
PROCESS:
********
    Y.LC.NUM = EB.SystemTables.getIdNew()
    Y.LC.NEXT.DR = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcNextDrawing)
    Y.LC.LOC.REF= EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.TF.JOB.NEW.NUMBER =  Y.LC.LOC.REF<1,Y.TF.JOB.NUMBER.POS>
    Y.OLD.LC.LOC.REF= EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.TF.EXIST.JOB.NUMBER =  Y.OLD.LC.LOC.REF<1,Y.TF.JOB.NUMBER.POS>
    IF Y.TF.JOB.NEW.NUMBER EQ Y.TF.EXIST.JOB.NUMBER THEN
        EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
        EB.SystemTables.setAv(Y.TF.JOB.NUMBER.POS)
        EB.SystemTables.setEtext("Old and New Job number must not be same!")
        EB.ErrorProcessing.StoreEndError()
    END
    IF Y.LC.NEXT.DR NE 01 THEN
        EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
        EB.SystemTables.setAv(Y.TF.JOB.NUMBER.POS)
        EB.SystemTables.setEtext("Transfer not possible as Drawings exist!")
        EB.ErrorProcessing.StoreEndError()
    END
RETURN

END
