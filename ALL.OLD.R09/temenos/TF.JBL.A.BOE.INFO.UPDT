SUBROUTINE TF.JBL.A.BOE.INFO.UPDT
*-----------------------------------------------------------------------------
*Subroutine Description: Write BILL ENTRY info in JBL.BILL.ENTRY template
*Attached To    : DRAWINGS VERSION (DRAWINGS,IMPSP, DRAWINGS,IMPAC, DRAWINGS,IMPMAT)
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 17/12/2019 -                            CREATE   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.JBL.BILL.ENTRY
     
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING LC.Contract
    $USING EB.Foundation
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.BILL.ENTRY = "F.JBL.BILL.ENTRY"
    F.BILL.ENTRY = ""
    FN.LC = "F.LETTER.OF.CREDIT"
    F.LC = ""
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.BILL.ENTRY,F.BILL.ENTRY)
    EB.DataAccess.Opf(FN.LC,F.LC)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.DRAW.ID = EB.SystemTables.getIdNew()
    EB.DataAccess.FRead(FN.BILL.ENTRY, Y.DRAW.ID, R.BILL.ENTRY.REC, F.BILL.ENTRY, Y.BILL.ENTRY.ERR)
    
    IF R.BILL.ENTRY.REC EQ "" THEN
        EB.DataAccess.FRead(FN.LC, SUBSTRINGS(Y.DRAW.ID, 1, 12), R.LC.REC, F.LC, Y.LC.ERR)
        Y.LC.NO = R.LC.REC<LC.Contract.LetterOfCredit.TfLcOldLcNumber>
        Y.LC.ISS.DATE = R.LC.REC<LC.Contract.LetterOfCredit.TfLcIssueDate>
        Y.APP.CUS.NO = R.LC.REC<LC.Contract.LetterOfCredit.TfLcApplicantCustno>
        Y.APP.NAME = R.LC.REC<LC.Contract.LetterOfCredit.TfLcApplicant>
*        Y.DOC.CCY = R.LC.REC<LC.Contract.LetterOfCredit.TfLcLcCurrency>
*        Y.DOC.AMT = R.LC.REC<LC.Contract.LetterOfCredit.TfLcLcAmount>
        EB.Foundation.MapLocalFields("LETTER.OF.CREDIT", "LT.TF.HS.CODE", LT.TF.HS.CODE.POS)
        Y.HS.CODE = R.LC.REC<LC.Contract.LetterOfCredit.TfLcLocalRef><1, LT.TF.HS.CODE.POS>
        
        Y.DOC.CCY = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDrawCurrency)
        Y.DOC.AMT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDocumentAmount)
        
        R.BIL.ENT.REC<BILL.ENTRY.TF.DRAWING.ID> = Y.DRAW.ID
        R.BIL.ENT.REC<BILL.ENTRY.LC.NUMBER> = Y.LC.NO
        R.BIL.ENT.REC<BILL.ENTRY.LC.ISSUE.DATE> = Y.LC.ISS.DATE
        R.BIL.ENT.REC<BILL.ENTRY.DATE.OF.PAYMENT> = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrValueDate)
        R.BIL.ENT.REC<BILL.ENTRY.APPLICANT.CUST.NO> = Y.APP.CUS.NO
        R.BIL.ENT.REC<BILL.ENTRY.APPLICANT.NAME> = Y.APP.NAME
        R.BIL.ENT.REC<BILL.ENTRY.DOC.CCY> =Y.DOC.CCY
        R.BIL.ENT.REC<BILL.ENTRY.DOC.AMT> = Y.DOC.AMT
        R.BIL.ENT.REC<BILL.ENTRY.HS.CODE> = Y.HS.CODE
        EB.DataAccess.FWrite(FN.BILL.ENTRY, Y.DRAW.ID, R.BIL.ENT.REC)
    END

RETURN
*** </region>
END
