SUBROUTINE TF.JBL.I.MT700.NOINPUT
*-----------------------------------------------------------------------------
*Subroutine Description: field date change not allowed routine
*Subroutine Type: INPUT ROUTINE
*Attached To    : VERSION (LETTER.OF.CREDIT,JBL.MT700AND701.IN)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 05/05/2021 -                            Create   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
      
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING EB.LocalReferences
    $USING LC.Contract
    
*-----------------------------------------------------------------------------
**********************************************
    WRITE.FILE.VAR = "test: "
    GOSUB FILE.WRITE
*****************************************************

    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.LC.AMOUNT.NEW = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
    Y.LC.AMOUNT.NEW.LAST = EB.SystemTables.getRNewLast(LC.Contract.LetterOfCredit.TfLcLcAmount)
**********************************************
    WRITE.FILE.VAR = "EB.SystemTables.getR(LC.Contract.LetterOfCredit.TfLcLcAmount): ":EB.SystemTables.getR(LC.Contract.LetterOfCredit.TfLcLcAmount)
    GOSUB FILE.WRITE
*****************************************************   \
**********************************************
    WRITE.FILE.VAR = "EB.SystemTables.getRNewLast(LC.Contract.LetterOfCredit.TfLcLcAmount): ":EB.SystemTables.getRNewLast(LC.Contract.LetterOfCredit.TfLcLcAmount)
    GOSUB FILE.WRITE
*****************************************************
**********************************************
    WRITE.FILE.VAR = "Y.LC.AMOUNT.NEW: ":Y.LC.AMOUNT.NEW
    GOSUB FILE.WRITE
*****************************************************
**********************************************
    WRITE.FILE.VAR = "Y.LC.AMOUNT.NEW.LAST: ":Y.LC.AMOUNT.NEW.LAST
    GOSUB FILE.WRITE
*****************************************************
    Y.LC.CURRENCY.NEW = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcCurrency)
    Y.LC.CURRENCY.NEW.LAST = EB.SystemTables.getRNewLast(LC.Contract.LetterOfCredit.TfLcLcCurrency)
**********************************************
    WRITE.FILE.VAR = "Y.LC.CURRENCY.NEW: ":Y.LC.CURRENCY.NEW
    GOSUB FILE.WRITE
**********************************************
    WRITE.FILE.VAR = "Y.LC.CURRENCY.NEW.LAST: ":Y.LC.CURRENCY.NEW.LAST
    GOSUB FILE.WRITE
**********************************************************************************************************
    Y.APPLICANT.NEW = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcApplicant)
    Y.APPLICANT.NEW.LAST = EB.SystemTables.getRNewLast(LC.Contract.LetterOfCredit.TfLcApplicant)
**********************************************
    WRITE.FILE.VAR = "Y.APPLICANT.NEW: ":Y.APPLICANT.NEW
    GOSUB FILE.WRITE
**********************************************
    WRITE.FILE.VAR = "**************Y.APPLICANT.NEW.LAST: ":Y.APPLICANT.NEW.LAST
    GOSUB FILE.WRITE
**********************************************************************************************************
    Y.BENEFICIARY.NEW = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcBeneficiary)
    Y.BENEFICIARY.NEW.LAST = EB.SystemTables.getRNewLast(LC.Contract.LetterOfCredit.TfLcBeneficiary)
    Y.ISSUE.DATE.NEW = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcIssueDate)
    Y.ISSUE.DATE.NEW.LAST = EB.SystemTables.getRNewLast(LC.Contract.LetterOfCredit.TfLcIssueDate)
    Y.EXPIRY.DATE.NEW = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcExpiryDate)
    Y.EXPIRY.DATE.NEW.LAST = EB.SystemTables.getRNewLast(LC.Contract.LetterOfCredit.TfLcExpiryDate)
    
    IF Y.LC.AMOUNT.NEW NE "" AND Y.LC.AMOUNT.NEW.LAST NE "" THEN
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLcAmount, Y.LC.AMOUNT.NEW.LAST)
    END
    IF Y.LC.CURRENCY.NEW NE "" AND Y.LC.CURRENCY.NEW.LAST NE "" THEN
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLcCurrency, Y.LC.CURRENCY.NEW.LAST)
    END
    IF Y.APPLICANT.NEW NE "" AND Y.APPLICANT.NEW.LAST NE "" THEN
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcApplicant, Y.APPLICANT.NEW.LAST)
    END
    IF Y.BENEFICIARY.NEW NE "" AND Y.BENEFICIARY.NEW.LAST NE "" THEN
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcBeneficiary, Y.BENEFICIARY.NEW.LAST)
    END
    IF Y.ISSUE.DATE.NEW NE "" AND Y.ISSUE.DATE.NEW.LAST NE "" THEN
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcIssueDate, Y.ISSUE.DATE.NEW.LAST)
    END
    IF Y.EXPIRY.DATE.NEW NE "" AND Y.EXPIRY.DATE.NEW.LAST NE "" THEN
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcExpiryDate, Y.EXPIRY.DATE.NEW.LAST)
    END
    
    
RETURN
*** </region>

*****************************************************
FILE.WRITE:
*    WriteData = ''
*    WriteData = '*1*' : WRITE.FILE.VAR
**     : '*14*' : R.BD.CHG<BD.CHG.SLAB.AMT> : '*15*' : R.BD.CHG<BD.CHG.TXN.REFNO> : '*16*' : R.BD.CHG<BD.CHG.TXN.AMT> : '*17*' : R.BD.CHG<BD.CHG.TXN.AMT>  : '*18*' : R.BD.CHG<BD.CHG.TXN.DUE.AMT> : '*19*' : R.BD.CHG<BD.TOTAL.REALIZE.AMT> : '*20*' : R.BD.CHG<BD.OS.DUE.AMT> : '*21*' : R.BD.CHG<BD.CHG.TXN.FLAG> : '*22*' : balanceAmount : '*23*' : Y.START.DATE : '*24*' : Y.END.DATE : '*25*' : BAL.DETAILS : '*26*' : CurrentDates : '*27*' : StartBalDate : '*28*' : EndBalDate : '*29*' : TotYdays : '*30*' : CloseBalCnt : '*31*' : Ydate2 : '*32*' : YdaysPrev : '*33*' : Ydays : '*34*' : Y.WORKING.BALANCE : '*35*' : Y.POS.1 : '*36*' : CompanyId : '*37*' : accountId
*    FileName = 'TF.JBL.I.MT700.NOINPUT.csv'
*    FilePath = 'JBL.DATA'
*    OPENSEQ FilePath,FileName TO FileOutput THEN NULL
*    ELSE
*        CREATE FileOutput ELSE
*        END
*    END
*    WRITESEQ WriteData APPEND TO FileOutput ELSE
*        CLOSESEQ FileOutput
*    END
*    CLOSESEQ FileOutput
RETURN
********************************************************
END
