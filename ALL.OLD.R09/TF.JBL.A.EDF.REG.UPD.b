SUBROUTINE TF.JBL.A.EDF.REG.UPD
*-----------------------------------------------------------------------------
* THIS ROUTINE FIELDS ARE MOVED IN DRAWING
*
*Subroutine Description:This Routine Triggers while authorizing the transaction.It will write the Record in the
*                        applicaion's EDF.REGISTER keeps the record in IHLD State.
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.EDFOPEN)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 07/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $INSERT I_F.JBL.EDF.REGISTER
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Updates
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.EDF.NAU = 'F.JBL.EDF.REGISTER$NAU'
    F.EDF.NAU  = ''
    
    Y.REC = ''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.EDF.NAU,F.EDF.NAU)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.APPL.NAME = 'LETTER.OF.CREDIT'
    Y.FLD.LIST = 'BB.FUNDING.DATE':VM:'BB.FUND.AMT':VM:'BB.REFUND.DATE'
    Y.FLD.LIST:= VM:'BB.REFUND.AMT':VM:'BB.CREDIT.DATE'
    Y.FLD.POS = ''

    !Find the position of local ref fields

    EB.Updates.MultiGetLocRef(Y.APPL.NAME,Y.FLD.LIST,Y.FLD.POS)
    Y.BB.FUND.DATE = Y.FLD.POS<1,1>
    Y.BB.FUND.AMT = Y.FLD.POS<1,2>
    Y.BB.REFUND.DATE = Y.FLD.POS<1,3>
    Y.BB.REFUND.AMT = Y.FLD.POS<1,4>
    Y.BB.CREDIT.DATE = Y.FLD.POS<1,5>


    Y.REC<EDF.APPLICANT.NAME> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcApplicant)<1,1>
    Y.REC<EDF.LC.NUMBER> = EB.SystemTables.getIdNew()
    Y.REC<EDF.DATE.OF.LC> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcIssueDate)
    Y.REC<EDF.LC.AMOUNT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
    Y.REC<EDF.LC.EXPIRY.DATE> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcExpiryDate)
    Y.CNT.BEN = DCOUNT(EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcBeneficiary),@VM)
    FOR I = 1 TO Y.CNT.BEN
        Y.REC<EDF.BENEFICIARY,I> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcBeneficiary)<1,I>
    NEXT I
    Y.REC<EDF.BB.FUNDING.DATE> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BB.FUND.DATE>
    Y.REC<EDF.BB.FUND.AMT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BB.FUND.AMT>
    Y.REC<EDF.BB.REFUND.DATE> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BB.REFUND.DATE>
    Y.REC<EDF.BB.REFUND.AMT> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BB.REFUND.AMT>
    Y.REC<EDF.BB.CREDIT.DATE> = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.BB.CREDIT.DATE>

    EB.DataAccess.FWrite(FN.EDF.NAU,EB.SystemTables.getIdNew(),Y.REC)
RETURN
*** </region>
END
