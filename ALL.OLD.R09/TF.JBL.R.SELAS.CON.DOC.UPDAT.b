SUBROUTINE TF.JBL.R.SELAS.CON.DOC.UPDAT
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Modification History :
* 08/16/2020 -                            Creator   - MAHMUDUR RAHMAN (UDOY),
*                                                 FDS Bangladesh Limited
* Attached: DRAWINGS,BD.OUTCOLL
* Description: auto-populate dreawing fields with LC Application.
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING EB.TransactionControl
 
*-----------------------------------------------------------------------------


    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC

    
RETURN
*-----------------------------------------------------------------------------
*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LC='F.LETTER.OF.CREDIT'
    F.LC=''
    
    EB.LocalReferences.GetLocRef('LETTER.OF.CREDIT','LT.TF.JOB.NUMBR',LC.JOB.POS)
    EB.LocalReferences.GetLocRef('LETTER.OF.CREDIT','LT.TF.BTB.CNTNO',CONT.NO.POS)
    EB.LocalReferences.GetLocRef('DRAWINGS','LT.TF.JOB.NUMBR',DR.JOB.POS)
    EB.LocalReferences.GetLocRef('DRAWINGS','LT.TF.BTB.CNTNO',DR.CONT.NO.POS)

RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LC,F.LC)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.DR.ID = EB.SystemTables.getIdNew()
    Y.LC.ID = Y.DR.ID[1,LEN(Y.DR.ID)-2]
    IF Y.LC.ID NE '' THEN
        EB.DataAccess.FRead(FN.LC, Y.LC.ID, REC.DATA, F.LC, ERR.LC)
        IF REC.DATA THEN
            Y.LC.CUS = REC.DATA<LC.Contract.LetterOfCredit.TfLcBeneficiaryCustno>
            Y.LC.JOB.TEMP = REC.DATA<LC.Contract.LetterOfCredit.TfLcLocalRef>
            Y.LC.JOB = Y.LC.JOB.TEMP<1,LC.JOB.POS>
            Y.CONT.NO = Y.LC.JOB.TEMP<1,CONT.NO.POS>
            Y.LC.AMT = REC.DATA<LC.Contract.LetterOfCredit.TfLcLcAmount>
            EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrPresentorCust,Y.LC.CUS)
            EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrDocumentAmount,Y.LC.AMT)
            Y.TEMP = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
            Y.TEMP<1,DR.JOB.POS> = Y.LC.JOB
            Y.TEMP<1,DR.CONT.NO.POS> = Y.CONT.NO
            EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef,Y.TEMP)
            EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrAppDrawAmt,Y.LC.AMT)
            EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrBenDrawAmt,Y.LC.AMT)
        END
    END
RETURN
*-----------------------------------------------------------------------------

END
