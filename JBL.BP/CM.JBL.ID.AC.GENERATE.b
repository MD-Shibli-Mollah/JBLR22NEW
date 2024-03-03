*---------------------------------------------------------------------------------------
*Subroutine Description: Account Id Generation For Retail, Deposit & Loan.
*Subroutine Type       :
*Attached To           : COMPANY(ALL)
*Attached As           : ACCT.CHECKDIG.TYPE(FIELD NAME)
*Developed by          : MEHEDI(NTECH)
*Incoming Parameters   :
*Outgoing Parameters   :
*--------------------------------------------------------------------------------------
SUBROUTINE CM.JBL.ID.AC.GENERATE
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $USING ST.CompanyCreation
    $USING AC.AccountOpening
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.DataAccess
    $USING EB.TransactionControl
*-----------------------------------------------------------------------------
    IF EB.SystemTables.getVFunction() EQ 'I' THEN
        IF FIELD(EB.SystemTables.getComi(),@FM,2) NE 'NEW' THEN
            IF LEN(FIELD(EB.SystemTables.getComi(),@FM,1)) NE 13 THEN
                EB.SystemTables.setEtext('CLICK NEW DEAL')
                EB.ErrorProcessing.Err()
                RETURN
            END
        END ELSE
            GOSUB INITIALISE
            GOSUB CHECK.DIGIT
        END
    END
RETURN
*-----------
INITIALISE:
*-----------
    Y.ERROR.MSG = ''
*
    FN.LOCKING = 'F.LOCKING'
    FP.LOCKING = ''
    EB.DataAccess.Opf(FN.LOCKING,FP.LOCKING)
    R.LOCKING = ''
    Y.LOCKING.ID = 'FBNK.JBL.ACCT.SEQ.NO'
*Y.LOCKING.ID = 'FBNK.ACCOUNT'
*
    YBRANCH.MNEMONIC = ''
    YBRANCH.MNEMONIC<1> = R.INTERCO.PARAMETER<ST.CompanyCreation.IntercoParameter.IcpBranchCode>
    YBRANCH.MNEMONIC<2> = R.INTERCO.PARAMETER<ST.CompanyCreation.IntercoParameter.IcpFinMnemonic>
RETURN
*------------
CHECK.DIGIT:
*------------
    YBRANCH = R.COMPANY(ST.CompanyCreation.Company.EbComFinancialMne)
    FIND YBRANCH IN YBRANCH.MNEMONIC SETTING BFV,BMV,BSV THEN
*YBRANCH.CODE = "0" : YBRANCH.MNEMONIC<1,BMV>
        YBRANCH.CODE = YBRANCH.MNEMONIC<1,BMV>
    END ELSE        ;* Account is in master company
        BMV = 1
        YBRANCH.CODE = YBRANCH.MNEMONIC<1,BMV>
    END
    Y.ACCT.ID = YBRANCH.CODE
    Y.LOC.ERR = ''
    EB.DataAccess.FRead(FN.LOCKING,Y.LOCKING.ID,R.LOCKING,FP.LOCKING,Y.LOC.ERR)
    IF Y.LOC.ERR EQ '' THEN
        Y.SEQ = R.LOCKING<1>
        Y.SEQ.NO = FMT(Y.SEQ,"10'0'R")
        Y.SEQ = Y.SEQ + 1
*
        WRITE Y.SEQ ON FP.LOCKING, Y.LOCKING.ID
        EB.TransactionControl.JournalUpdate(Y.LOCKING.ID)
        SENSITIVITY = ''
        Y.ACCT.ID := Y.SEQ.NO
    END
*
*---------Janata Bank Check digit calculations/Start--------------
*
    CHECK.DIGIT = 0
    REMAINDER = ''
    TOTAL.1 = 0
*
    TOTAL.1 += Y.ACCT.ID[1,1] * 7
    TOTAL.1 += Y.ACCT.ID[2,1] * 6
    TOTAL.1 += Y.ACCT.ID[3,1] * 5
    TOTAL.1 += Y.ACCT.ID[4,1] * 4
    TOTAL.1 += Y.ACCT.ID[5,1] * 3
    TOTAL.1 += Y.ACCT.ID[6,1] * 2
    TOTAL.1 += Y.ACCT.ID[7,1] * 7
    TOTAL.1 += Y.ACCT.ID[8,1] * 6
    TOTAL.1 += Y.ACCT.ID[9,1] * 5
    TOTAL.1 += Y.ACCT.ID[10,1] * 4
    TOTAL.1 += Y.ACCT.ID[11,1] * 3
    TOTAL.1 += Y.ACCT.ID[12,1] * 2
*
    MOD.OF.COMI = MOD(TOTAL.1,11)
*
    LS.DIGIT = 11 - MOD.OF.COMI
*
    IF LEN(LS.DIGIT) > 1 THEN
        CHECK.DIGIT = LS.DIGIT[2,1]
    END ELSE
        CHECK.DIGIT = LS.DIGIT
    END
*---------Janatha Bank Check digit calculations/End--------------
    Y.ACCT.ID := CHECK.DIGIT
    EB.SystemTables.setComi(Y.ACCT.ID)
RETURN
END
